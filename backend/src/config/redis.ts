import { createClient } from 'redis';

const redisUrl = process.env.REDIS_URL || 'redis://localhost:6379';

export const redisClient = createClient({
  url: redisUrl,
});

redisClient.on('error', (err) => console.error('✗ Redis Client Error', err));
redisClient.on('connect', () => console.log('✓ Redis connected'));

export const connectRedis = async () => {
  if (!redisClient.isOpen) {
    await redisClient.connect();
  }
};

export const redisHelper = {
  client: redisClient,
  get: async (key: string) => await redisClient.get(key),
  set: async (key: string, value: string) => await redisClient.set(key, value),
  setEx: async (key: string, seconds: number, value: string) =>
    await redisClient.setEx(key, seconds, value),
  del: async (key: string) => await redisClient.del(key),
  exists: async (key: string) => await redisClient.exists(key),
  keys: async (pattern: string) => await redisClient.keys(pattern),
};
