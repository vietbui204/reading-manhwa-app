import { Server } from 'socket.io';
import { Server as HttpServer } from 'http';
import { verifyAccessToken } from '../utils/jwt';
import { logger } from '../utils/logger';
import { redisHelper } from './redis';

let io: Server;

export const initSocket = (httpServer: HttpServer) => {
  io = new Server(httpServer, {
    cors: {
      origin: process.env.CLIENT_URL || '*',
      methods: ['GET', 'POST'],
    },
  });

  // Middleware xác thực Socket.IO
  io.use((socket, next) => {
    const token = socket.handshake.auth.token;
    if (!token) {
      return next(new Error('Authentication required'));
    }
    try {
      const payload = verifyAccessToken(token);
      socket.data.userId = payload.userId;
      socket.data.role = payload.role;
      next();
    } catch (error) {
      next(new Error('Invalid token'));
    }
  });

  io.on('connection', (socket) => {
    const userId = socket.data.userId;
    logger.info(`✓ Socket connected: ${userId} (${socket.id})`);

    // User join room cá nhân theo userId
    socket.join(userId);

    // Đăng ký FCM Token để gửi Push Notification khi offline
    socket.on('register_fcm_token', async (fcmToken: string) => {
      try {
        if (fcmToken) {
          await redisHelper.setEx(`fcm_token:${userId}`, 30 * 24 * 60 * 60, fcmToken);
          logger.info(`✓ FCM token registered for user: ${userId}`);
        }
      } catch (error) {
        logger.error('✗ Error registering FCM token:', error);
      }
    });

    socket.on('disconnect', () => {
      logger.info(`✗ Socket disconnected: ${userId}`);
    });
  });

  return io;
};

export const getIO = (): Server => {
  if (!io) {
    throw new Error('Socket.io not initialized');
  }
  return io;
};
