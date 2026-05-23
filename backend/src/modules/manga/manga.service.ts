import { prisma } from '../../config/database';
import { redisHelper } from '../../config/redis';
import { AppError } from '../../utils/AppError';
import { CreateMangaInput, MangaQueryInput, UpdateMangaInput } from './manga.schema';

export class MangaService {
  async getHomeData() {
    // Check Cache
    const cachedData = await redisHelper.get('home_data');
    if (cachedData) return JSON.parse(cachedData);

    const sevenDaysAgo = new Date();
    sevenDaysAgo.setDate(sevenDaysAgo.getDate() - 7);

    const twentyFourHoursAgo = new Date();
    twentyFourHoursAgo.setHours(twentyFourHoursAgo.getHours() - 24);

    const [bannersRaw, recentlyUpdatedRaw, recommendedRaw, rankingsRaw] = await Promise.all([
      // 1. Banners
      prisma.manga.findMany({
        take: 5,
        orderBy: { viewCount: 'desc' },
        select: { id: true, title: true, coverUrl: true, viewCount: true, createdAt: true },
      }),
      // 2. Recently Updated
      prisma.manga.findMany({
        take: 10,
        orderBy: { updatedAt: 'desc' },
        select: { id: true, title: true, coverUrl: true, status: true, genres: true, updatedAt: true },
      }),
      // 3. Recommended
      prisma.manga.findMany({
        take: 10,
        orderBy: { viewCount: 'desc' },
      }),
      // 4. Rankings
      prisma.manga.findMany({
        take: 10,
        orderBy: { likeCount: 'desc' },
      }),
    ]);

    // Process Banners with badges
    const banners = bannersRaw.map((m, index) => ({
      ...m,
      badgeType: m.createdAt > sevenDaysAgo ? 'new' : (index < 2 ? 'hot' : 'trending'),
    }));

    // Process Recently Updated
    const recentlyUpdated = recentlyUpdatedRaw.map(m => ({
      ...m,
      isNewChapter: m.updatedAt > twentyFourHoursAgo,
    }));

    const result = {
      banners,
      recentlyUpdated,
      recommended: recommendedRaw,
      rankings: rankingsRaw.map((m, i) => ({ ...m, rank: i + 1 })),
    };

    // Set Cache (5 minutes)
    await redisHelper.setEx('home_data', 300, JSON.stringify(result));

    return result;
  }

  async getMangaList(query: MangaQueryInput) {
    const { page, limit, genre, status, sort, search } = query;
    const skip = (page - 1) * limit;

    const where: any = {};
    if (genre) where.genres = { has: genre };
    if (status) where.status = status;
    if (search) {
      where.title = { contains: search, mode: 'insensitive' };
    }

    let orderBy: any = { updatedAt: 'desc' };
    if (sort === 'popular') orderBy = { followCount: 'desc' };
    if (sort === 'view') orderBy = { viewCount: 'desc' };

    const [data, total] = await Promise.all([
      prisma.manga.findMany({
        where,
        skip,
        take: limit,
        orderBy,
        include: {
          author: { select: { id: true, username: true, avatarUrl: true } },
        },
      }),
      prisma.manga.count({ where }),
    ]);

    return {
      data,
      pagination: { page, limit, total },
    };
  }

  async getMangaById(mangaId: string, userId?: string) {
    const manga = await prisma.manga.findUnique({
      where: { id: mangaId },
      include: {
        author: { select: { id: true, username: true, avatarUrl: true } },
        chapters: {
          orderBy: { chapterNumber: 'asc' },
          select: {
            id: true,
            chapterNumber: true,
            title: true,
            pageCount: true,
            isLocked: true,
            unlockCost: true,
            isPremiumOnly: true,
            publishedAt: true,
          },
        },
      },
    });

    if (!manga) throw new AppError('Không tìm thấy truyện', 404);

    let isLiked = false;
    let isFollowed = false;

    if (userId) {
      const [like, follow] = await Promise.all([
        prisma.mangaLike.findUnique({ where: { userId_mangaId: { userId, mangaId } } }),
        prisma.mangaFollow.findUnique({ where: { userId_mangaId: { userId, mangaId } } }),
      ]);
      isLiked = !!like;
      isFollowed = !!follow;
    }

    // Increment view via Redis
    redisHelper.client.incr(`manga_views:${mangaId}`);

    return { ...manga, isLiked, isFollowed };
  }

  async createManga(data: CreateMangaInput, authorId: string) {
    // Map thủ công từ API (snake_case) sang Prisma (camelCase)
    const manga = await prisma.manga.create({
      data: {
        title: data.title,
        description: data.description,
        coverUrl: data.cover_url,
        status: data.status,
        genres: data.genres,
        authorId: authorId,
      },
    });
    await redisHelper.del('home_data');
    return manga;
  }

  async updateManga(mangaId: string, data: UpdateMangaInput, userId: string, role: string) {
    const manga = await prisma.manga.findUnique({ where: { id: mangaId } });
    if (!manga) throw new AppError('Không tìm thấy truyện', 404);

    if (manga.authorId !== userId && role !== 'admin') {
      throw new AppError('Bạn không có quyền sửa truyện này', 403);
    }

    // Map fields cho update
    const updateData: any = {
      title: data.title,
      description: data.description,
      coverUrl: data.cover_url,
      status: data.status,
      genres: data.genres,
    };

    const updatedManga = await prisma.manga.update({
      where: { id: mangaId },
      data: updateData,
    });
    await redisHelper.del('home_data');
    return updatedManga;
  }

  async deleteManga(mangaId: string, userId: string, role: string) {
    const manga = await prisma.manga.findUnique({ where: { id: mangaId } });
    if (!manga) throw new AppError('Không tìm thấy truyện', 404);

    if (manga.authorId !== userId && role !== 'admin') {
      throw new AppError('Bạn không có quyền xoá truyện này', 403);
    }

    await prisma.manga.delete({ where: { id: mangaId } });
    await redisHelper.del('home_data');
    return { message: 'Xoá thành công' };
  }
}
