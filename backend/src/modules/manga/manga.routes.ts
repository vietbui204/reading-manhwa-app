import { Router } from 'express';
import { MangaController } from './manga.controller';
import { validateQuery, validateBody } from '../../middleware/validate';
import { authenticate } from '../../middleware/authenticate';
import { authorize } from '../../middleware/authorize';
import { createMangaSchema, updateMangaSchema, mangaQuerySchema } from './manga.schema';

const router = Router();
const mangaController = new MangaController();

router.get('/home', mangaController.getHome);
router.get('/manga', validateQuery(mangaQuerySchema), mangaController.getMangaList);
router.get('/manga/search', validateQuery(mangaQuerySchema), mangaController.getMangaList);
router.get('/manga/:id', mangaController.getMangaById);

router.post(
  '/manga',
  authenticate,
  authorize('creator', 'admin'),
  validateBody(createMangaSchema),
  mangaController.createManga
);

router.put(
  '/manga/:id',
  authenticate,
  authorize('creator', 'admin'),
  validateBody(updateMangaSchema),
  mangaController.updateManga
);

router.delete(
  '/manga/:id',
  authenticate,
  authorize('creator', 'admin'),
  mangaController.deleteManga
);

export const mangaRouter = router;
