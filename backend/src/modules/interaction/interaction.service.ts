import { prisma } from '../../config/database';
import { AppError } from '../../utils/AppError';

export class InteractionService {
  async likeManga(userId: string, mangaId: string) {
    const manga = await prisma.manga.findUnique({ where: { id: mangaId } });
    if (!manga) throw new AppError('Không tìm thấy truyện', 404);

    const existing = await prisma.mangaLike.findUnique({
      where: { userId_mangaId: { userId, mangaId } },
    });
    if (existing) throw new AppError('Bạn đã thích truyện này rồi', 409);

    await prisma.mangaLike.create({ data: { userId, mangaId } });
    return { message: 'Đã thích truyện' };
  }

  async unlikeManga(userId: string, mangaId: string) {
    const existing = await prisma.mangaLike.findUnique({
      where: { userId_mangaId: { userId, mangaId } },
    });
    if (!existing) throw new AppError('Bạn chưa thích truyện này', 400);

    await prisma.mangaLike.delete({
      where: { userId_mangaId: { userId, mangaId } },
    });
    return { message: 'Đã bỏ thích truyện' };
  }

  async followManga(userId: string, mangaId: string) {
    const manga = await prisma.manga.findUnique({ where: { id: mangaId } });
    if (!manga) throw new AppError('Không tìm thấy truyện', 404);

    const existing = await prisma.mangaFollow.findUnique({
      where: { userId_mangaId: { userId, mangaId } },
    });
    if (existing) throw new AppError('Bạn đã theo dõi truyện này rồi', 409);

    await prisma.mangaFollow.create({ data: { userId, mangaId } });
    return { message: 'Đã theo dõi truyện' };
  }

  async unfollowManga(userId: string, mangaId: string) {
    const existing = await prisma.mangaFollow.findUnique({
      where: { userId_mangaId: { userId, mangaId } },
    });
    if (!existing) throw new AppError('Bạn chưa theo dõi truyện này', 400);

    await prisma.mangaFollow.delete({
      where: { userId_mangaId: { userId, mangaId } },
    });
    return { message: 'Đã bỏ theo dõi truyện' };
  }

  async likeComment(userId: string, commentId: string) {
    const comment = await prisma.comment.findUnique({ where: { id: commentId } });
    if (!comment) throw new AppError('Không tìm thấy bình luận', 404);

    const existing = await prisma.commentLike.findUnique({
      where: { userId_commentId: { userId, commentId } },
    });
    if (existing) throw new AppError('Bạn đã thích bình luận này rồi', 409);

    await prisma.commentLike.create({ data: { userId, commentId } });
    return { message: 'Đã thích bình luận' };
  }

  async unlikeComment(userId: string, commentId: string) {
    const existing = await prisma.commentLike.findUnique({
      where: { userId_commentId: { userId, commentId } },
    });
    if (!existing) throw new AppError('Bạn chưa thích bình luận này', 400);

    await prisma.commentLike.delete({
      where: { userId_commentId: { userId, commentId } },
    });
    return { message: 'Đã bỏ thích bình luận' };
  }
}
