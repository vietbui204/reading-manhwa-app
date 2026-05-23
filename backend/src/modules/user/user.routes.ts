import { Router } from 'express';
import { UserController } from './user.controller';
import { authenticate } from '../../middleware/authenticate';
import { validateBody, validateQuery } from '../../middleware/validate';
import { updateProfileSchema, updateReadingHistorySchema, userQuerySchema } from './user.schema';

const router = Router();
const userController = new UserController();

// LƯU Ý: Các route 'me' phải đặt TRƯỚC các route ':id'
router.get('/users/me/history', authenticate, validateQuery(userQuerySchema), userController.getHistory);
router.get('/users/me/bookmarks', authenticate, validateQuery(userQuerySchema), userController.getBookmarks);
router.put('/users/me', authenticate, validateBody(updateProfileSchema), userController.updateProfile);

router.get('/users/:id', userController.getProfile);
router.get('/users/:id/manga', userController.getUserMangas);

router.post('/reading-history', authenticate, validateBody(updateReadingHistorySchema), userController.updateHistory);

export const userRouter = router;
