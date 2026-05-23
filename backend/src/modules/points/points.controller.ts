import { Request, Response, NextFunction } from 'express';
import { PointsService } from './points.service';
import { sendSuccess } from '../../utils/response';

const pointsService = new PointsService();

export class PointsController {
  async getTasks(req: Request, res: Response, next: NextFunction) {
    try {
      const result = await pointsService.getTasks(req.user!.userId);
      sendSuccess(res, result, 'Lấy danh sách nhiệm vụ thành công');
    } catch (error) {
      next(error);
    }
  }

  async completeTask(req: Request, res: Response, next: NextFunction) {
    try {
      const result = await pointsService.completeTask(req.user!.userId, req.params.id, req.body.proof);
      sendSuccess(res, result, 'Hoàn thành nhiệm vụ thành công');
    } catch (error) {
      next(error);
    }
  }

  async getBalance(req: Request, res: Response, next: NextFunction) {
    try {
      const result = await pointsService.getPointBalance(req.user!.userId);
      sendSuccess(res, result, 'Lấy số dư điểm thành công');
    } catch (error) {
      next(error);
    }
  }

  async getHistory(req: Request, res: Response, next: NextFunction) {
    try {
      const result = await pointsService.getPointHistory(req.user!.userId, req.query as any);
      sendSuccess(res, result.data, 'Lấy lịch sử điểm thành công');
    } catch (error) {
      next(error);
    }
  }

  async unlockChapter(req: Request, res: Response, next: NextFunction) {
    try {
      const result = await pointsService.unlockChapter(req.user!.userId, req.params.id);
      sendSuccess(res, result, 'Mở khóa chapter thành công');
    } catch (error) {
      next(error);
    }
  }
}
