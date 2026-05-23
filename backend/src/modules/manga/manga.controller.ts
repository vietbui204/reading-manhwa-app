import { Request, Response, NextFunction } from 'express';
import { MangaService } from './manga.service';
import { sendSuccess, sendPaginated } from '../../utils/response';
import { verifyAccessToken } from '../../utils/jwt';

const mangaService = new MangaService();

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

export class MangaController {
  async getHome(req: Request, res: Response, next: NextFunction) {
    try {
      const result = await mangaService.getHomeData();
      sendSuccess(res, result, 'Lấy dữ liệu trang chủ thành công');
    } catch (error) {
      next(error);
    }
  }

  async getMangaList(req: Request, res: Response, next: NextFunction) {
    try {
      const result = await mangaService.getMangaList(req.query as any);
      sendPaginated(res, result.data, result.pagination, 'Lấy danh sách truyện thành công');
    } catch (error) {
      next(error);
    }
  }

  async getMangaById(req: Request, res: Response, next: NextFunction) {
    try {
      const userId = getUserIdFromToken(req);
      const result = await mangaService.getMangaById(req.params.id, userId);
      sendSuccess(res, result, 'Lấy chi tiết truyện thành công');
    } catch (error) {
      next(error);
    }
  }

  async createManga(req: Request, res: Response, next: NextFunction) {
    try {
      const result = await mangaService.createManga(req.body, req.user!.userId);
      sendSuccess(res, result, 'Tạo truyện mới thành công', 201);
    } catch (error) {
      next(error);
    }
  }

  async updateManga(req: Request, res: Response, next: NextFunction) {
    try {
      const result = await mangaService.updateManga(
        req.params.id,
        req.body,
        req.user!.userId,
        req.user!.role
      );
      sendSuccess(res, result, 'Cập nhật truyện thành công');
    } catch (error) {
      next(error);
    }
  }

  async deleteManga(req: Request, res: Response, next: NextFunction) {
    try {
      const result = await mangaService.deleteManga(
        req.params.id,
        req.user!.userId,
        req.user!.role
      );
      sendSuccess(res, result, 'Xoá truyện thành công');
    } catch (error) {
      next(error);
    }
  }
}
