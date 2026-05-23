import { PutObjectCommand, DeleteObjectCommand } from '@aws-sdk/client-s3';
import { v4 as uuidv4 } from 'uuid';
import path from 'path';
import { r2Client, R2_BUCKET, R2_PUBLIC_URL } from '../../config/r2';
import { logger } from '../../utils/logger';

export class UploadService {
  private isMockMode: boolean;

  constructor() {
    this.isMockMode = !process.env.R2_ACCOUNT_ID || process.env.R2_ACCOUNT_ID === 'your_r2_account_id';
    if (this.isMockMode) {
      logger.warn('⚠️ Cloudflare R2 not configured, using Mock Mode for uploads');
    }
  }

  async uploadFile(file: Express.Multer.File, folder: string): Promise<string> {
    const ext = path.extname(file.originalname) || '.webp';
    const filename = `${folder}/${uuidv4()}${ext}`;

    if (this.isMockMode) {
      return `https://mock-cdn.mangax.com/${filename}`;
    }

    await r2Client.send(
      new PutObjectCommand({
        Bucket: R2_BUCKET,
        Key: filename,
        Body: file.buffer,
        ContentType: file.mimetype,
      })
    );

    return `${R2_PUBLIC_URL}/${filename}`;
  }

  async deleteFile(fileUrl: string): Promise<void> {
    if (this.isMockMode) {
      logger.info(`[Mock] Deleting file: ${fileUrl}`);
      return;
    }

    const key = fileUrl.replace(`${R2_PUBLIC_URL}/`, '');

    await r2Client.send(
      new DeleteObjectCommand({
        Bucket: R2_BUCKET,
        Key: key,
      })
    );
  }
}
