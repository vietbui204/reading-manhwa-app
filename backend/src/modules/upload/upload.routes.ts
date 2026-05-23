import { Router } from 'express';
import { UploadController } from './upload.controller';
import { authenticate } from '../../middleware/authenticate';
import { authorize } from '../../middleware/authorize';
import { uploadSingle, uploadMultiple } from './upload.middleware';

const router = Router();
const uploadController = new UploadController();

router.post(
  '/upload/page',
  authenticate,
  authorize('creator', 'admin'),
  uploadSingle,
  uploadController.uploadPage
);

router.post(
  '/upload/pages',
  authenticate,
  authorize('creator', 'admin'),
  uploadMultiple,
  uploadController.uploadPages
);

router.post(
  '/upload/cover',
  authenticate,
  authorize('creator', 'admin'),
  uploadSingle,
  uploadController.uploadCover
);

router.post(
  '/upload/avatar',
  authenticate,
  uploadSingle,
  uploadController.uploadAvatar
);

router.delete('/upload', authenticate, uploadController.deleteFile);

export const uploadRouter = router;
