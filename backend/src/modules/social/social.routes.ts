import { Router } from 'express';
import { SocialController } from './social.controller';
import { authenticate } from '../../middleware/authenticate';
import { validateBody, validateQuery } from '../../middleware/validate';
import { createStatusSchema, followQuerySchema } from './social.schema';

const router = Router();
const socialController = new SocialController();

router.post('/users/:id/follow', authenticate, socialController.followUser);
router.delete('/users/:id/follow', authenticate, socialController.unfollowUser);

router.get('/users/:id/followers', validateQuery(followQuerySchema), socialController.getFollowers);
router.get('/users/:id/following', validateQuery(followQuerySchema), socialController.getFollowing);

router.post('/status', authenticate, validateBody(createStatusSchema), socialController.createStatus);
router.get('/users/:id/status', validateQuery(followQuerySchema), socialController.getStatusPosts);

export const socialRouter = router;
