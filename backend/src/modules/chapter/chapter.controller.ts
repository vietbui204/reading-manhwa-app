import { Request, Response, NextFunction } from 'express';
import { ChapterService } from './chapter.service';
import { sendSuccess } from '../../utils/response';
import { verifyAccessToken } from '../../utils/jwt';
import { prisma } from '../../config/database';

const chapterService = new ChapterService();

const getAuthInfo = async (req: Request) => {
  try {
    const token = req.headers.authorization?.split(' ')[1];
    if (!token) return { userId: undefined, isPremium: false, role: undefined };

    const payload = verifyAccessToken(token);
    const user = await prisma.user.findUnique({
      where: { id: payload.userId },
      select: { isPremium: true, premiumUntil: true, role: true }
    });

    const isPremium = !!(user?.isPremium && (user?.premiumUntil ? user.premiumUntil > new Date() : false));
    return { userId: payload.userId, isPremium, role: user?.role };
  } catch {
    return { userId: undefined, isPremium: false, role: undefined };
  }
};

export class ChapterController {
  async getChapters(req: Request, res: Response, next: NextFunction) {
    try {
      const result = await chapterService.getChaptersByMangaId(req.params.mangaId);
      sendSuccess(res, result, 'Lấy danh sách chapter thành công');
    } catch (error) {
      next(error);
    }
  }

  async getChapter(req: Request, res: Response, next: NextFunction) {
    try {
      const { userId, isPremium } = await getAuthInfo(req);
      const result = await chapterService.getChapterById(req.params.id, userId, isPremium);
      sendSuccess(res, result, 'Lấy chi tiết chapter thành công');
    } catch (error) {
      next(error);
    }
  }

  async getPages(req: Request, res: Response, next: NextFunction) {
    try {
      const { userId, isPremium } = await getAuthInfo(req);
      const result = await chapterService.getChapterPages(req.params.id, userId, isPremium);
      sendSuccess(res, result, 'Lấy danh sách trang thành công');
    } catch (error) {
      next(error);
    }
  }

  async createChapter(req: Request, res: Response, next: NextFunction) {
    try {
      const result = await chapterService.createChapter(
        req.params.mangaId,
        req.body,
        req.user!.userId,
        req.user!.role
      );
      sendSuccess(res, result, 'Tạo chapter thành công', 201);
    } catch (error) {
      next(error);
    }
  }

  async addPages(req: Request, res: Response, next: NextFunction) {
    try {
      const result = await chapterService.addPages(
        req.params.id,
        req.body.pages,
        req.user!.userId,
        req.user!.role
      );
      sendSuccess(res, result, 'Thêm trang thành công', 201);
    } catch (error) {
      next(error);
    }
  }

  async updateChapter(req: Request, res: Response, next: NextFunction) {
    try {
      const result = await chapterService.updateChapter(
        req.params.id,
        req.body,
        req.user!.userId,
        req.user!.role
      );
      sendSuccess(res, result, 'Cập nhật chapter thành công');
    } catch (error) {
      next(error);
    }
  }

  async deleteChapter(req: Request, res: Response, next: NextFunction) {
    try {
      const result = await chapterService.deleteChapter(
        req.params.id,
        req.user!.userId,
        req.user!.role
      );
      sendSuccess(res, result, 'Xoá chapter thành công');
    } catch (error) {
      next(error);
    }
  }
}
