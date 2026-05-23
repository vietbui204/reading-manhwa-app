import { Request, Response, NextFunction } from 'express';
import { SocialService } from './social.service';
import { sendSuccess, sendPaginated } from '../../utils/response';
import { verifyAccessToken } from '../../utils/jwt';

const socialService = new SocialService();

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

export class SocialController {
  async followUser(req: Request, res: Response, next: NextFunction) {
    try {
      const result = await socialService.followUser(req.user!.userId, req.params.id);
      sendSuccess(res, result, 'Đã follow người dùng');
    } catch (error) {
      next(error);
    }
  }

  async unfollowUser(req: Request, res: Response, next: NextFunction) {
    try {
      const result = await socialService.unfollowUser(req.user!.userId, req.params.id);
      sendSuccess(res, result, 'Đã bỏ follow người dùng');
    } catch (error) {
      next(error);
    }
  }

  async getFollowers(req: Request, res: Response, next: NextFunction) {
    try {
      const requesterId = getUserIdFromToken(req);
      const result = await socialService.getFollowers(req.params.id, req.query as any, requesterId);
      sendPaginated(res, result.data, result.pagination, 'Lấy danh sách người theo dõi thành công');
    } catch (error) {
      next(error);
    }
  }

  async getFollowing(req: Request, res: Response, next: NextFunction) {
    try {
      const result = await socialService.getFollowing(req.params.id, req.query as any);
      sendPaginated(res, result.data, result.pagination, 'Lấy danh sách đang theo dõi thành công');
    } catch (error) {
      next(error);
    }
  }

  async createStatus(req: Request, res: Response, next: NextFunction) {
    try {
      const result = await socialService.createStatusPost(req.user!.userId, req.body.content);
      sendSuccess(res, result, 'Đăng trạng thái thành công', 201);
    } catch (error) {
      next(error);
    }
  }

  async getStatusPosts(req: Request, res: Response, next: NextFunction) {
    try {
      const result = await socialService.getStatusPosts(req.params.id, req.query as any);
      sendPaginated(res, result.data, result.pagination, 'Lấy danh sách trạng thái thành công');
    } catch (error) {
      next(error);
    }
  }
}
