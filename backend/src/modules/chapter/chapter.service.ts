import { prisma } from '../../config/database';
import { redisHelper } from '../../config/redis';
import { AppError } from '../../utils/AppError';

export class ChapterService {
  async checkChapterAccess(chapter: any, userId?: string, isPremium: boolean = false) {
    if (!chapter.isLocked) return { hasAccess: true };

    if (chapter.isPremiumOnly) {
      if (isPremium) return { hasAccess: true };
      return { hasAccess: false, reason: 'premium_only' };
    }

    if (userId) {
      const unlock = await prisma.chapterUnlock.findUnique({
        where: { userId_chapterId: { userId, chapterId: chapter.id } },
      });
      if (unlock) return { hasAccess: true };
    }

    return { hasAccess: false, reason: 'chapter_locked', unlockCost: chapter.unlockCost };
  }

  async getChaptersByMangaId(mangaId: string) {
    const cached = await redisHelper.get(`chapter_list:${mangaId}`);
    if (cached) return JSON.parse(cached);

    const chapters = await prisma.chapter.findMany({
      where: { mangaId },
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
    });

    await redisHelper.setEx(`chapter_list:${mangaId}`, 300, JSON.stringify(chapters));
    return chapters;
  }

  async getChapterById(chapterId: string, userId?: string, isPremium: boolean = false) {
    const chapter = await prisma.chapter.findUnique({
      where: { id: chapterId },
      include: { manga: { select: { title: true, authorId: true } } },
    });

    if (!chapter) throw new AppError('Không tìm thấy chapter', 404);

    const access = await this.checkChapterAccess(chapter, userId, isPremium);
    if (!access.hasAccess) {
      throw new AppError('Chapter này yêu cầu mở khoá', 403);
    }

    return chapter;
  }

  async getChapterPages(chapterId: string, userId?: string, isPremium: boolean = false) {
    const chapter = await prisma.chapter.findUnique({ where: { id: chapterId } });
    if (!chapter) throw new AppError('Không tìm thấy chapter', 404);

    const access = await this.checkChapterAccess(chapter, userId, isPremium);
    if (!access.hasAccess) throw new AppError('Bạn không có quyền xem các trang này', 403);

    const cached = await redisHelper.get(`chapter_pages:${chapterId}`);
    if (cached) return JSON.parse(cached);

    const pages = await prisma.page.findMany({
      where: { chapterId },
      orderBy: { pageNumber: 'asc' },
    });

    await redisHelper.setEx(`chapter_pages:${chapterId}`, 3600, JSON.stringify(pages));
    return pages;
  }

  async createChapter(mangaId: string, data: any, userId: string, role: string) {
    const manga = await prisma.manga.findUnique({ where: { id: mangaId } });
    if (!manga) throw new AppError('Không tìm thấy truyện', 404);

    if (manga.authorId !== userId && role !== 'admin') {
      throw new AppError('Bạn không có quyền thêm chapter cho truyện này', 403);
    }

    // MAP THỦ CÔNG TỪ API (snake_case) SANG PRISMA (camelCase)
    const chapter = await prisma.chapter.create({
      data: {
        mangaId: mangaId,
        chapterNumber: data.chapter_number,
        title: data.title,
        isLocked: data.is_locked || false,
        unlockCost: data.unlock_cost || 0,
        isPremiumOnly: data.is_premium_only || false,
      },
    });

    await Promise.all([
      redisHelper.del(`chapter_list:${mangaId}`),
      redisHelper.del('home_data'),
    ]);

    return chapter;
  }

  async addPages(chapterId: string, pages: any[], userId: string, role: string) {
    const chapter = await prisma.chapter.findUnique({
      where: { id: chapterId },
      include: { manga: true },
    });
    if (!chapter) throw new AppError('Không tìm thấy chapter', 404);

    if (chapter.manga.authorId !== userId && role !== 'admin') {
      throw new AppError('Không có quyền', 403);
    }

    await prisma.$transaction([
      prisma.page.createMany({
        data: pages.map(p => ({
          chapterId: chapterId,
          pageNumber: p.page_number,
          imageUrl: p.image_url
        })),
      }),
      prisma.chapter.update({
        where: { id: chapterId },
        data: { pageCount: pages.length },
      }),
    ]);

    await redisHelper.del(`chapter_pages:${chapterId}`);
    return { message: 'Thêm trang thành công', pageCount: pages.length };
  }

  async deleteChapter(chapterId: string, userId: string, role: string) {
    const chapter = await prisma.chapter.findUnique({
      where: { id: chapterId },
      include: { manga: true },
    });
    if (!chapter) throw new AppError('Không tìm thấy chapter', 404);

    if (chapter.manga.authorId !== userId && role !== 'admin') {
      throw new AppError('Không có quyền', 403);
    }

    await prisma.chapter.delete({ where: { id: chapterId } });

    await Promise.all([
      redisHelper.del(`chapter_list:${chapter.mangaId}`),
      redisHelper.del(`chapter_pages:${chapterId}`),
    ]);

    return { message: 'Xoá chapter thành công' };
  }
}
