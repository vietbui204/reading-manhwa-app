import { Request, Response, NextFunction } from 'express';
import { UserService } from './user.service';
import { sendSuccess, sendPaginated } from '../../utils/response';
import { verifyAccessToken } from '../../utils/jwt';

const userService = new UserService();

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

export class UserController {
  async getProfile(req: Request, res: Response, next: NextFunction) {
    try {
      const requesterId = getUserIdFromToken(req);
      const result = await userService.getUserById(req.params.id, requesterId);
      sendSuccess(res, result, 'Lấy thông tin người dùng thành công');
    } catch (error) {
      next(error);
    }
  }

  async updateProfile(req: Request, res: Response, next: NextFunction) {
    try {
      const result = await userService.updateProfile(req.user!.userId, req.body);
      sendSuccess(res, result, 'Cập nhật hồ sơ thành công');
    } catch (error) {
      next(error);
    }
  }

  async getHistory(req: Request, res: Response, next: NextFunction) {
    try {
      const result = await userService.getReadingHistory(req.user!.userId, req.query as any);
      sendPaginated(res, result.data, result.pagination, 'Lấy lịch sử đọc thành công');
    } catch (error) {
      next(error);
    }
  }

  async updateHistory(req: Request, res: Response, next: NextFunction) {
    try {
      const { chapter_id } = req.body;
      const result = await userService.updateReadingHistory(req.user!.userId, chapter_id);
      sendSuccess(res, result, 'Cập nhật lịch sử đọc thành công');
    } catch (error) {
      next(error);
    }
  }

  async getBookmarks(req: Request, res: Response, next: NextFunction) {
    try {
      const result = await userService.getBookmarks(req.user!.userId, req.query as any);
      sendPaginated(res, result.data, result.pagination, 'Lấy danh sách bookmark thành công');
    } catch (error) {
      next(error);
    }
  }

  async getUserMangas(req: Request, res: Response, next: NextFunction) {
    try {
      const result = await userService.getUserMangas(req.params.id, req.query as any);
      sendPaginated(res, result.data, result.pagination, 'Lấy danh sách truyện của người dùng thành công');
    } catch (error) {
      next(error);
    }
  }
}
