import { Request, Response, NextFunction } from 'express';
import { AdminService } from './admin.service';
import { sendSuccess, sendPaginated } from '../../utils/response';

const adminService = new AdminService();

export class AdminController {
  async getStats(req: Request, res: Response, next: NextFunction) {
    try {
      const result = await adminService.getStats();
      sendSuccess(res, result, 'Lấy thống kê thành công');
    } catch (error) {
      next(error);
    }
  }

  async getUsers(req: Request, res: Response, next: NextFunction) {
    try {
      const result = await adminService.getUsers(req.query as any);
      sendPaginated(res, result.data, result.pagination, 'Lấy danh sách người dùng thành công');
    } catch (error) {
      next(error);
    }
  }

  async updateRole(req: Request, res: Response, next: NextFunction) {
    try {
      const result = await adminService.updateUserRole(req.params.id, req.body.role, req.user!.userId);
      sendSuccess(res, result, 'Cập nhật role thành công');
    } catch (error) {
      next(error);
    }
  }

  async createTask(req: Request, res: Response, next: NextFunction) {
    try {
      const result = await adminService.createTask(req.body);
      sendSuccess(res, result, 'Tạo nhiệm vụ thành công', 201);
    } catch (error) {
      next(error);
    }
  }

  async updateTask(req: Request, res: Response, next: NextFunction) {
    try {
      const result = await adminService.updateTask(req.params.id, req.body);
      sendSuccess(res, result, 'Cập nhật nhiệm vụ thành công');
    } catch (error) {
      next(error);
    }
  }

  async grantPoints(req: Request, res: Response, next: NextFunction) {
    try {
      const result = await adminService.grantPoints(req.body, req.user!.userId);
      sendSuccess(res, result, 'Cập nhật điểm thành công');
    } catch (error) {
      next(error);
    }
  }

  async deleteManga(req: Request, res: Response, next: NextFunction) {
    try {
      const result = await adminService.deleteManga(req.params.id);
      sendSuccess(res, result, 'Xoá truyện thành công');
    } catch (error) {
      next(error);
    }
  }
}
