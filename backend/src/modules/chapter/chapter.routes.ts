import { Router } from 'express';
import { ChapterController } from './chapter.controller';
import { validateBody } from '../../middleware/validate';
import { authenticate } from '../../middleware/authenticate';
import { authorize } from '../../middleware/authorize';
import { createChapterSchema, updateChapterSchema, addPagesSchema } from './chapter.schema';

const router = Router();
const chapterController = new ChapterController();

router.get('/manga/:mangaId/chapters', chapterController.getChapters);
router.get('/chapters/:id', chapterController.getChapter);
router.get('/chapters/:id/pages', chapterController.getPages);

router.post(
  '/manga/:mangaId/chapters',
  authenticate,
  authorize('creator', 'admin'),
  validateBody(createChapterSchema),
  chapterController.createChapter
);

router.post(
  '/chapters/:id/pages',
  authenticate,
  authorize('creator', 'admin'),
  validateBody(addPagesSchema),
  chapterController.addPages
);

router.put(
  '/chapters/:id',
  authenticate,
  authorize('creator', 'admin'),
  validateBody(updateChapterSchema),
  chapterController.updateChapter
);

router.delete(
  '/chapters/:id',
  authenticate,
  authorize('creator', 'admin'),
  chapterController.deleteChapter
);

export const chapterRouter = router;
