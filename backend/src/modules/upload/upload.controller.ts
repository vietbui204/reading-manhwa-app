import { Request, Response, NextFunction } from 'express';
import { UploadService } from './upload.service';
import { sendSuccess } from '../../utils/response';
import { AppError } from '../../utils/AppError';

const uploadService = new UploadService();

export class UploadController {
  async uploadPage(req: Request, res: Response, next: NextFunction) {
    try {
      if (!req.file) throw new AppError('Không có file được tải lên', 400);
      const url = await uploadService.uploadFile(req.file, 'pages');
      sendSuccess(res, { url }, 'Upload trang thành công', 201);
    } catch (error) {
      next(error);
    }
  }

  async uploadPages(req: Request, res: Response, next: NextFunction) {
    try {
      const files = req.files as Express.Multer.File[];
      if (!files || files.length === 0) throw new AppError('Không có file nào', 400);

      const urls = await Promise.all(
        files.map((f) => uploadService.uploadFile(f, 'pages'))
      );
      sendSuccess(res, { urls, count: urls.length }, 'Upload nhiều trang thành công', 201);
    } catch (error) {
      next(error);
    }
  }

  async uploadCover(req: Request, res: Response, next: NextFunction) {
    try {
      if (!req.file) throw new AppError('Không có file', 400);
      const url = await uploadService.uploadFile(req.file, 'covers');
      sendSuccess(res, { url }, 'Upload ảnh bìa thành công', 201);
    } catch (error) {
      next(error);
    }
  }

  async uploadAvatar(req: Request, res: Response, next: NextFunction) {
    try {
      if (!req.file) throw new AppError('Không có file', 400);
      const url = await uploadService.uploadFile(req.file, 'avatars');
      sendSuccess(res, { url }, 'Upload avatar thành công', 201);
    } catch (error) {
      next(error);
    }
  }

  async deleteFile(req: Request, res: Response, next: NextFunction) {
    try {
      const { url } = req.body;
      if (!url) throw new AppError('Vui lòng cung cấp URL file cần xoá', 400);
      await uploadService.deleteFile(url);
      sendSuccess(res, null, 'Xoá file thành công');
    } catch (error) {
      next(error);
    }
  }
}
