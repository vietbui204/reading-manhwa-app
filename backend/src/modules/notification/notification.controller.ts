import { Request, Response, NextFunction } from 'express';
import { NotificationService } from './notification.service';
import { sendSuccess } from '../../utils/response';

const notificationService = new NotificationService();

export class NotificationController {
  async getNotifications(req: Request, res: Response, next: NextFunction) {
    try {
      const result = await notificationService.getNotifications(req.user!.userId, req.query as any);
      sendSuccess(res, result, 'Lấy danh sách thông báo thành công');
    } catch (error) {
      next(error);
    }
  }

  async getUnreadCount(req: Request, res: Response, next: NextFunction) {
    try {
      const result = await notificationService.getUnreadCount(req.user!.userId);
      sendSuccess(res, result, 'Lấy số thông báo chưa đọc thành công');
    } catch (error) {
      next(error);
    }
  }

  async markAsRead(req: Request, res: Response, next: NextFunction) {
    try {
      const result = await notificationService.markAsRead(req.params.id, req.user!.userId);
      sendSuccess(res, result, 'Đã đánh dấu thông báo đã đọc');
    } catch (error) {
      next(error);
    }
  }

  async markAllAsRead(req: Request, res: Response, next: NextFunction) {
    try {
      const result = await notificationService.markAllAsRead(req.user!.userId);
      sendSuccess(res, result, 'Đã đánh dấu tất cả đã đọc');
    } catch (error) {
      next(error);
    }
  }
}
