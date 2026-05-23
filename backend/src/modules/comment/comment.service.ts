import { prisma } from '../../config/database';
import { AppError } from '../../utils/AppError';
import { CreateCommentInput, CommentQueryInput } from './comment.schema';

export class CommentService {
  async getComments(mangaId: string, query: CommentQueryInput, userId?: string) {
    const { cursor, limit } = query;

    let commentAtCursor = null;
    if (cursor) {
      commentAtCursor = await prisma.comment.findUnique({ where: { id: cursor } });
      if (!commentAtCursor) throw new AppError('Cursor không hợp lệ', 400);
    }

    const comments = await prisma.comment.findMany({
      where: {
        mangaId,
        parentId: null,
        ...(commentAtCursor ? {
          createdAt: {
            lt: commentAtCursor.createdAt,
          },
        } : {}),
      },
      orderBy: { createdAt: 'desc' },
      take: limit + 1,
      include: {
        user: { select: { id: true, username: true, avatarUrl: true } },
        _count: { select: { replies: true } },
      },
    });

    const hasMore = comments.length > limit;
    const data = hasMore ? comments.slice(0, limit) : comments;
    const nextCursor = hasMore ? data[data.length - 1].id : null;

    // Check isLiked
    let processedData = data as any[];
    if (userId) {
      const commentIds = data.map(c => c.id);
      const likes = await prisma.commentLike.findMany({
        where: {
          userId,
          commentId: { in: commentIds },
        },
      });
      const likedIds = new Set(likes.map(l => l.commentId));
      processedData = data.map(c => ({
        ...c,
        isLiked: likedIds.has(c.id),
      }));
    } else {
      processedData = data.map(c => ({ ...c, isLiked: false }));
    }

    return {
      data: processedData,
      nextCursor,
      hasMore,
    };
  }

  async getReplies(commentId: string, userId?: string) {
    const parent = await prisma.comment.findUnique({ where: { id: commentId } });
    if (!parent) throw new AppError('Bình luận gốc không tồn tại', 404);

    const replies = await prisma.comment.findMany({
      where: { parentId: commentId },
      orderBy: { createdAt: 'asc' },
      include: {
        user: { select: { id: true, username: true, avatarUrl: true } },
      },
    });

    let processedData = replies as any[];
    if (userId) {
      const replyIds = replies.map(r => r.id);
      const likes = await prisma.commentLike.findMany({
        where: {
          userId,
          commentId: { in: replyIds },
        },
      });
      const likedIds = new Set(likes.map(l => l.commentId));
      processedData = replies.map(r => ({
        ...r,
        isLiked: likedIds.has(r.id),
      }));
    } else {
      processedData = replies.map(r => ({ ...r, isLiked: false }));
    }

    return { data: processedData };
  }

  async createComment(mangaId: string, userId: string, data: CreateCommentInput) {
    const manga = await prisma.manga.findUnique({ where: { id: mangaId } });
    if (!manga) throw new AppError('Truyện không tồn tại', 404);

    if (data.parent_id) {
      const parent = await prisma.comment.findUnique({ where: { id: data.parent_id } });
      if (!parent) throw new AppError('Bình luận cha không tồn tại', 404);
      if (parent.mangaId !== mangaId) throw new AppError('Bình luận cha không thuộc truyện này', 400);
      if (parent.parentId !== null) throw new AppError('Chỉ reply được bình luận gốc', 400);
    }

    const comment = await prisma.comment.create({
      data: {
        content: data.content,
        mangaId,
        userId,
        parentId: data.parent_id || null,
      },
      include: {
        user: { select: { id: true, username: true, avatarUrl: true } },
      },
    });

    // Create Notification for reply
    if (data.parent_id) {
      const parentComment = await prisma.comment.findUnique({ where: { id: data.parent_id } });
      if (parentComment && parentComment.userId !== userId) {
        await prisma.notification.create({
          data: {
            recipientId: parentComment.userId,
            actorId: userId,
            type: 'comment_reply',
            refId: comment.id,
          },
        });
      }
    }

    return comment;
  }

  async updateComment(commentId: string, userId: string, content: string) {
    const comment = await prisma.comment.findUnique({ where: { id: commentId } });
    if (!comment) throw new AppError('Bình luận không tồn tại', 404);

    if (comment.userId !== userId) {
      throw new AppError('Bạn không có quyền sửa bình luận này', 403);
    }

    return await prisma.comment.update({
      where: { id: commentId },
      data: { content },
    });
  }

  async deleteComment(commentId: string, userId: string, role: string) {
    const comment = await prisma.comment.findUnique({ where: { id: commentId } });
    if (!comment) throw new AppError('Bình luận không tồn tại', 404);

    if (comment.userId !== userId && role !== 'admin') {
      throw new AppError('Bạn không có quyền xoá bình luận này', 403);
    }

    await prisma.comment.delete({ where: { id: commentId } });
    return { message: 'Đã xoá bình luận' };
  }
}
