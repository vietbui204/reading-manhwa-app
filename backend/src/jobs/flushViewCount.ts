import nodeCron from 'node-cron';
import { redisHelper } from '../config/redis';
import { prisma } from '../config/database';
import { logger } from '../utils/logger';

export const startFlushViewCount = () => {
  // Chạy mỗi 5 phút
  nodeCron.schedule('*/5 * * * *', async () => {
    try {
      const keys = await redisHelper.keys('manga_views:*');
      if (keys.length === 0) return;

      let count = 0;
      for (const key of keys) {
        const mangaId = key.split(':')[1];
        const views = await redisHelper.get(key);

        if (views && parseInt(views, 10) > 0) {
          await prisma.manga.update({
            where: { id: mangaId },
            data: { viewCount: { increment: parseInt(views, 10) } },
          });
          await redisHelper.del(key);
          count++;
        }
      }
      if (count > 0) {
        logger.info(`✓ Flushed views for ${count} mangas from Redis to DB`);
      }
    } catch (error) {
      logger.error('✗ Error flushing view count:', error);
    }
  });
};
