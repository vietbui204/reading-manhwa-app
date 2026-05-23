import { prisma } from '../config/database';
import { redisHelper } from '../config/redis';
import { getIO } from '../config/socket';
import { messaging } from '../config/firebase';
import { logger } from './logger';

export type NotificationType = 'new_chapter' | 'new_follower' | 'comment_reply' | 'status_post' | 'manga_published';

interface EmitNotificationData {
  recipientId: string;
  actorId: string;
  type: NotificationType;
  refId?: string;
  emitData: any;
}

const getTitleByType = (type: NotificationType): string => {
  switch (type) {
    case 'new_chapter': return 'Chapter mới';
    case 'new_follower': return 'Người theo dõi mới';
    case 'comment_reply': return 'Có người reply bình luận';
    case 'status_post': return 'Cập nhật từ người bạn follow';
    case 'manga_published': return 'Truyện mới';
    default: return 'Thông báo mới';
  }
};

export const createAndEmitNotification = async ({
  recipientId,
  actorId,
  type,
  refId,
  emitData
}: EmitNotificationData) => {
  try {
    // 1. INSERT vào notifications (Prisma)
    const notification = await prisma.notification.create({
      data: {
        recipientId,
        actorId,
        type,
        refId,
      },
      include: {
        actor: { select: { id: true, username: true, avatarUrl: true } }
      }
    });

    // 2. Xoá Redis cache: notif_count:{recipientId}
    await redisHelper.del(`notif_count:${recipientId}`);

    const io = getIO();
    const payload = {
      id: notification.id,
      type,
      actor: notification.actor,
      ref_id: refId,
      is_read: false,
      created_at: notification.createdAt,
      ...emitData
    };

    // 3. Emit Socket.IO đến room recipientId
    io.to(recipientId).emit('notification', payload);

    // 4. Kiểm tra user online để gửi FCM
    const sockets = await io.in(recipientId).fetchSockets();
    const isOnline = sockets.length > 0;

    if (!isOnline) {
      const fcmToken = await redisHelper.get(`fcm_token:${recipientId}`);
      if (fcmToken) {
        try {
          await messaging().send({
            token: fcmToken,
            notification: {
              title: getTitleByType(type),
              body: emitData.message,
            },
            data: {
              type,
              ref_id: refId || '',
              click_action: 'FLUTTER_NOTIFICATION_CLICK',
            },
          });
          logger.info(`✓ FCM sent to user: ${recipientId}`);
        } catch (fcmError) {
          logger.error('✗ FCM sending failed:', fcmError);
        }
      }
    }

    return notification;
  } catch (error) {
    logger.error('✗ Error in createAndEmitNotification:', error);
  }
};
