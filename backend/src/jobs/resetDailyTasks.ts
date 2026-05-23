import nodeCron from 'node-cron';
import { redisHelper } from '../config/redis';
import { logger } from '../utils/logger';

export const startResetDailyTasks = () => {
  // Chạy lúc 00:00 mỗi ngày
  nodeCron.schedule('0 0 * * *', async () => {
    try {
      const keys = await redisHelper.keys('task_done:*:*');
      if (keys.length === 0) return;

      for (const key of keys) {
        await redisHelper.del(key);
      }
      logger.info(`✓ Reset daily tasks: Deleted ${keys.length} keys from Redis`);
    } catch (error) {
      logger.error('✗ Error resetting daily tasks:', error);
    }
  });
};
