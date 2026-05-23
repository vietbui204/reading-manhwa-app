import { Router } from 'express';
import { NotificationController } from './notification.controller';
import { authenticate } from '../../middleware/authenticate';
import { validateQuery } from '../../middleware/validate';
import { notificationQuerySchema } from './notification.schema';

const router = Router();
const notificationController = new NotificationController();

// LƯU Ý: Các route tĩnh phải đặt TRƯỚC route có param :id
router.get('/', authenticate, validateQuery(notificationQuerySchema), notificationController.getNotifications);
router.get('/unread-count', authenticate, notificationController.getUnreadCount);
router.put('/read-all', authenticate, notificationController.markAllAsRead);
router.put('/:id/read', authenticate, notificationController.markAsRead);

export const notificationRouter = router;
