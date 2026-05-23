import { Request, Response, NextFunction } from 'express';
import { InteractionService } from './interaction.service';
import { sendSuccess } from '../../utils/response';

const interactionService = new InteractionService();

export class InteractionController {
  async likeManga(req: Request, res: Response, next: NextFunction) {
    try {
      const result = await interactionService.likeManga(req.user!.userId, req.params.id);
      sendSuccess(res, result, 'Đã thích truyện');
    } catch (error) {
      next(error);
    }
  }

  async unlikeManga(req: Request, res: Response, next: NextFunction) {
    try {
      const result = await interactionService.unlikeManga(req.user!.userId, req.params.id);
      sendSuccess(res, result, 'Đã bỏ thích truyện');
    } catch (error) {
      next(error);
    }
  }

  async followManga(req: Request, res: Response, next: NextFunction) {
    try {
      const result = await interactionService.followManga(req.user!.userId, req.params.id);
      sendSuccess(res, result, 'Đã theo dõi truyện');
    } catch (error) {
      next(error);
    }
  }

  async unfollowManga(req: Request, res: Response, next: NextFunction) {
    try {
      const result = await interactionService.unfollowManga(req.user!.userId, req.params.id);
      sendSuccess(res, result, 'Đã bỏ theo dõi truyện');
    } catch (error) {
      next(error);
    }
  }

  async likeComment(req: Request, res: Response, next: NextFunction) {
    try {
      const result = await interactionService.likeComment(req.user!.userId, req.params.id);
      sendSuccess(res, result, 'Đã thích bình luận');
    } catch (error) {
      next(error);
    }
  }

  async unlikeComment(req: Request, res: Response, next: NextFunction) {
    try {
      const result = await interactionService.unlikeComment(req.user!.userId, req.params.id);
      sendSuccess(res, result, 'Đã bỏ thích bình luận');
    } catch (error) {
      next(error);
    }
  }
}
