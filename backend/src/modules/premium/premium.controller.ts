import { Request, Response, NextFunction } from 'express';
import { PremiumService } from './premium.service';
import { sendSuccess } from '../../utils/response';

const premiumService = new PremiumService();

export class PremiumController {
  async getStatus(req: Request, res: Response, next: NextFunction) {
    try {
      const result = await premiumService.getPremiumStatus(req.user!.userId);
      sendSuccess(res, result, 'Lấy trạng thái Premium thành công');
    } catch (error) {
      next(error);
    }
  }

  async getPlans(req: Request, res: Response, next: NextFunction) {
    try {
      const result = premiumService.getPremiumPlans();
      sendSuccess(res, result, 'Lấy danh sách gói Premium thành công');
    } catch (error) {
      next(error);
    }
  }

  async activate(req: Request, res: Response, next: NextFunction) {
    try {
      const { user_id, duration_days } = req.body;
      const result = await premiumService.activatePremium(user_id, duration_days);
      sendSuccess(res, result, 'Kích hoạt Premium thành công');
    } catch (error) {
      next(error);
    }
  }
}
