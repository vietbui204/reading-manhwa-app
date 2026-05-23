import { Router } from 'express';
import { CommentController } from './comment.controller';
import { authenticate } from '../../middleware/authenticate';
import { validateBody, validateQuery } from '../../middleware/validate';
import { createCommentSchema, updateCommentSchema, commentQuerySchema } from './comment.schema';

const router = Router();
const commentController = new CommentController();

router.get('/manga/:mangaId/comments', validateQuery(commentQuerySchema), commentController.getComments);
router.post('/manga/:mangaId/comments', authenticate, validateBody(createCommentSchema), commentController.createComment);

router.get('/comments/:id/replies', commentController.getReplies);
router.put('/comments/:id', authenticate, validateBody(updateCommentSchema), commentController.updateComment);
router.delete('/comments/:id', authenticate, commentController.deleteComment);

export const commentRouter = router;
