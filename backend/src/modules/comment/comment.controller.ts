import { Request, Response, NextFunction } from 'express';
import { CommentService } from './comment.service';
import { sendSuccess } from '../../utils/response';
import { verifyAccessToken } from '../../utils/jwt';

const commentService = new CommentService();

const getUserIdFromToken = (req: Request): string | undefined => {
  try {
    const token = req.headers.authorization?.split(' ')[1];
    if (!token) return undefined;
    const payload = verifyAccessToken(token);
    return payload.userId;
  } catch {
    return undefined;
  }
};

export class CommentController {
  async getComments(req: Request, res: Response, next: NextFunction) {
    try {
      const userId = getUserIdFromToken(req);
      const result = await commentService.getComments(req.params.mangaId, req.query as any, userId);
      sendSuccess(res, result, 'Lấy danh sách bình luận thành công');
    } catch (error) {
      next(error);
    }
  }

  async getReplies(req: Request, res: Response, next: NextFunction) {
    try {
      const userId = getUserIdFromToken(req);
      const result = await commentService.getReplies(req.params.id, userId);
      sendSuccess(res, result, 'Lấy danh sách phản hồi thành công');
    } catch (error) {
      next(error);
    }
  }

  async createComment(req: Request, res: Response, next: NextFunction) {
    try {
      const result = await commentService.createComment(req.params.mangaId, req.user!.userId, req.body);
      sendSuccess(res, result, 'Đã đăng bình luận', 201);
    } catch (error) {
      next(error);
    }
  }

  async updateComment(req: Request, res: Response, next: NextFunction) {
    try {
      const result = await commentService.updateComment(req.params.id, req.user!.userId, req.body.content);
      sendSuccess(res, result, 'Đã sửa bình luận');
    } catch (error) {
      next(error);
    }
  }

  async deleteComment(req: Request, res: Response, next: NextFunction) {
    try {
      const result = await commentService.deleteComment(req.params.id, req.user!.userId, req.user!.role);
      sendSuccess(res, result, 'Đã xoá bình luận');
    } catch (error) {
      next(error);
    }
  }
}
