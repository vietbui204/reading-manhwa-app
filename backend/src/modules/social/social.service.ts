import { prisma } from '../../config/database';
import { AppError } from '../../utils/AppError';
import { createAndEmitNotification } from '../../utils/notification.helper';
import { FollowQueryInput } from './social.schema';

export class SocialService {
  async followUser(followerId: string, followingId: string) {
    if (followerId === followingId) throw new AppError('Không thể tự follow mình', 400);

    const followingUser = await prisma.user.findUnique({ where: { id: followingId } });
    if (!followingUser) throw new AppError('Người dùng không tồn tại', 404);

    const existing = await prisma.userFollow.findUnique({
      where: { followerId_followingId: { followerId, followingId } },
    });
    if (existing) throw new AppError('Bạn đã follow người dùng này rồi', 409);

    await prisma.userFollow.create({ data: { followerId, followingId } });

    // Emit Notification
    const follower = await prisma.user.findUnique({ where: { id: followerId } });
    await createAndEmitNotification({
      recipientId: followingId,
      actorId: followerId,
      type: 'new_follower',
      refId: followerId,
      emitData: {
        message: `${follower?.username} đã bắt đầu theo dõi bạn`,
      },
    });

    return { message: 'Đã follow người dùng' };
  }

  async unfollowUser(followerId: string, followingId: string) {
    const existing = await prisma.userFollow.findUnique({
      where: { followerId_followingId: { followerId, followingId } },
    });
    if (!existing) throw new AppError('Bạn chưa follow người dùng này', 400);

    await prisma.userFollow.delete({
      where: { followerId_followingId: { followerId, followingId } },
    });

    return { message: 'Đã bỏ follow người dùng' };
  }

  async getFollowers(userId: string, query: FollowQueryInput, requesterId?: string) {
    const { page, limit } = query;
    const skip = (page - 1) * limit;

    const [follows, total] = await Promise.all([
      prisma.userFollow.findMany({
        where: { followingId: userId },
        skip,
        take: limit,
        include: {
          follower: { select: { id: true, username: true, avatarUrl: true } },
        },
      }),
      prisma.userFollow.count({ where: { followingId: userId } }),
    ]);

    const data = await Promise.all(follows.map(async (f) => {
      let isFollowed = false;
      if (requesterId) {
        const check = await prisma.userFollow.findUnique({
          where: { followerId_followingId: { followerId: requesterId, followingId: f.followerId } },
        });
        isFollowed = !!check;
      }
      return { ...f.follower, isFollowed };
    }));

    return { data, pagination: { page, limit, total } };
  }

  async getFollowing(userId: string, query: FollowQueryInput) {
    const { page, limit } = query;
    const skip = (page - 1) * limit;

    const [follows, total] = await Promise.all([
      prisma.userFollow.findMany({
        where: { followerId: userId },
        skip,
        take: limit,
        include: {
          following: { select: { id: true, username: true, avatarUrl: true } },
        },
      }),
      prisma.userFollow.count({ where: { followerId: userId } }),
    ]);

    return {
      data: follows.map(f => f.following),
      pagination: { page, limit, total },
    };
  }

  async createStatusPost(userId: string, content: string) {
    const post = await prisma.statusPost.create({
      data: { userId, content },
      include: { user: { select: { id: true, username: true, avatarUrl: true } } }
    });

    // Fan-out Notifications to followers (limit 1000)
    const followers = await prisma.userFollow.findMany({
      where: { followingId: userId },
      take: 1000,
      select: { followerId: true },
    });

    if (followers.length === 1000) {
      console.warn('Fan-out limited to 1000 followers');
    }

    await Promise.all(followers.map(f =>
      createAndEmitNotification({
        recipientId: f.followerId,
        actorId: userId,
        type: 'status_post',
        refId: post.id,
        emitData: {
          message: `${post.user.username} đã đăng trạng thái mới`,
          preview: content.substring(0, 100),
        },
      })
    ));

    return post;
  }

  async getStatusPosts(userId: string, query: FollowQueryInput) {
    const { page, limit } = query;
    const skip = (page - 1) * limit;

    const [data, total] = await Promise.all([
      prisma.statusPost.findMany({
        where: { userId },
        skip,
        take: limit,
        orderBy: { createdAt: 'desc' },
      }),
      prisma.statusPost.count({ where: { userId } }),
    ]);

    return { data, pagination: { page, limit, total } };
  }
}
