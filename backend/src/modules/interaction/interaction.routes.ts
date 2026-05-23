import { Router } from 'express';
import { InteractionController } from './interaction.controller';
import { authenticate } from '../../middleware/authenticate';

const router = Router();
const interactionController = new InteractionController();

router.post('/manga/:id/like', authenticate, interactionController.likeManga);
router.delete('/manga/:id/like', authenticate, interactionController.unlikeManga);

router.post('/manga/:id/follow', authenticate, interactionController.followManga);
router.delete('/manga/:id/follow', authenticate, interactionController.unfollowManga);

router.post('/comments/:id/like', authenticate, interactionController.likeComment);
router.delete('/comments/:id/like', authenticate, interactionController.unlikeComment);

export const interactionRouter = router;
