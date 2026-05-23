import { prisma } from '../../config/database';
import { redisHelper } from '../../config/redis';
import { AppError } from '../../utils/AppError';
import { NotificationQueryInput } from './notification.schema';

export class NotificationService {
  async getNotifications(userId: string, query: NotificationQueryInput) {
    const { page, limit, type } = query;
    const skip = (page - 1) * limit;

    const where: any = { recipientId: userId };
    if (type) where.type = type;

    const [data, total] = await Promise.all([
      prisma.notification.findMany({
        where,
        skip,
        take: limit,
        orderBy: { createdAt: 'desc' },
        include: {
          actor: { select: { id: true, username: true, avatarUrl: true } },
        },
      }),
      prisma.notification.count({ where }),
    ]);

    return { data, pagination: { page, limit, total } };
  }

  async getUnreadCount(userId: string) {
    const cacheKey = `notif_count:${userId}`;
    const cached = await redisHelper.get(cacheKey);
    if (cached) return { count: parseInt(cached, 10) };

    const count = await prisma.notification.count({
      where: { recipientId: userId, isRead: false },
    });

    await redisHelper.setEx(cacheKey, 60, count.toString());
    return { count };
  }

  async markAsRead(notificationId: string, userId: string) {
    const notification = await prisma.notification.findUnique({ where: { id: notificationId } });
    if (!notification) throw new AppError('Thông báo không tồn tại', 404);

    if (notification.recipientId !== userId) {
      throw new AppError('Bạn không có quyền thực hiện hành động này', 403);
    }

    const updated = await prisma.notification.update({
      where: { id: notificationId },
      data: { isRead: true },
    });

    await redisHelper.del(`notif_count:${userId}`);
    return updated;
  }

  async markAllAsRead(userId: string) {
    const result = await prisma.notification.updateMany({
      where: { recipientId: userId, isRead: false },
      data: { isRead: true },
    });

    await redisHelper.del(`notif_count:${userId}`);
    return { message: 'Đã đánh dấu tất cả đã đọc', updatedCount: result.count };
  }
}
