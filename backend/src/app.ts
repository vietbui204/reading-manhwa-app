import 'dotenv/config';
import express from 'express';
import helmet from 'helmet';
import cors from 'cors';
import { createServer } from 'http';
import { connectDB } from './config/database';
import { connectRedis } from './config/redis';
import { initSocket } from './config/socket';
import { initFirebase } from './config/firebase';
import { errorHandler } from './middleware/errorHandler';
import { apiLimiter } from './middleware/rateLimiter';
import { logger } from './utils/logger';

// Routers
import { authRouter } from './modules/auth/auth.routes';
import { mangaRouter } from './modules/manga/manga.routes';
import { chapterRouter } from './modules/chapter/chapter.routes';
import { uploadRouter } from './modules/upload/upload.routes';
import { userRouter } from './modules/user/user.routes';
import { interactionRouter } from './modules/interaction/interaction.routes';
import { commentRouter } from './modules/comment/comment.routes';
import { socialRouter } from './modules/social/social.routes';
import { notificationRouter } from './modules/notification/notification.routes';
import { pointsRouter } from './modules/points/points.routes';
import { premiumRouter } from './modules/premium/premium.routes';
import { adminRouter } from './modules/admin/admin.routes';

// Cron Jobs
import { startFlushViewCount } from './jobs/flushViewCount';
import { startResetDailyTasks } from './jobs/resetDailyTasks';

const app = express();
const httpServer = createServer(app);
const port = process.env.PORT || 3000;

// 1. Security Middlewares
app.use(helmet());
app.use(cors());
app.use(express.json());

// 2. Global Rate Limiter
app.use(apiLimiter);

// 3. Health Check
app.get('/health', (req, res) => {
  res.status(200).json({ status: 'OK' });
});

// 4. API Routes
app.use('/api/auth', authRouter);
app.use('/api', mangaRouter);
app.use('/api', chapterRouter);
app.use('/api', uploadRouter);
app.use('/api', userRouter);
app.use('/api', interactionRouter);
app.use('/api', commentRouter);
app.use('/api', socialRouter);
app.use('/api/notifications', notificationRouter);
app.use('/api', pointsRouter);
app.use('/api/premium', premiumRouter);
app.use('/api/admin', adminRouter);

// 5. 404 Handler
app.use((req, res) => {
  res.status(404).json({ success: false, message: 'Route không tồn tại' });
});

// 6. Global Error Handler
app.use(errorHandler);

// Initialization
const startServer = async () => {
  try {
    await connectDB();
    await connectRedis();
    initFirebase();
    initSocket(httpServer);

    httpServer.listen(port, () => {
      logger.info(`✓ Server running on port ${port} in ${process.env.NODE_ENV} mode`);

      startFlushViewCount();
      startResetDailyTasks();
      logger.info('✓ Cron jobs started');
    });
  } catch (error) {
    logger.error('✗ Failed to start server:', error);
    process.exit(1);
  }
};

startServer();
