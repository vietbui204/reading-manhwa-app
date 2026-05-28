import { S3Client } from '@aws-sdk/client-s3';
import { logger } from '../utils/logger';

// Hàm helper để làm sạch biến môi trường
const cleanEnv = (key: string | undefined): string => {
  if (!key) return '';
  return key.trim().replace(/^"|"$/g, '');
};

const accountId = cleanEnv(process.env.R2_ACCOUNT_ID);
const accessKeyId = cleanEnv(process.env.R2_ACCESS_KEY_ID);
const secretAccessKey = cleanEnv(process.env.R2_SECRET_ACCESS_KEY);

if (!accountId || !accessKeyId || !secretAccessKey) {
    logger.warn('⚠️ Cloudflare R2 credentials are not fully configured in .env');
}

export const r2Client = new S3Client({
  region: 'auto',
  endpoint: `https://${accountId}.r2.cloudflarestorage.com`,
  credentials: {
    accessKeyId: accessKeyId,
    secretAccessKey: secretAccessKey,
  },
});

export const R2_BUCKET = cleanEnv(process.env.R2_BUCKET_NAME) || 'mangaapp-media';
export const R2_PUBLIC_URL = cleanEnv(process.env.R2_PUBLIC_URL) || 'https://cdn.mangax.com';
