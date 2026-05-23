import { Router } from 'express';
import { PointsController } from './points.controller';
import { authenticate } from '../../middleware/authenticate';
import { validateBody, validateQuery } from '../../middleware/validate';
import { completeTaskSchema, pointHistoryQuerySchema } from './points.schema';

const router = Router();
const pointsController = new PointsController();

router.get('/tasks', authenticate, pointsController.getTasks);
router.post('/tasks/:id/complete', authenticate, validateBody(completeTaskSchema), pointsController.completeTask);

router.get('/points/balance', authenticate, pointsController.getBalance);
router.get('/points/history', authenticate, validateQuery(pointHistoryQuerySchema), pointsController.getHistory);

router.post('/chapters/:id/unlock', authenticate, pointsController.unlockChapter);

export const pointsRouter = router;
