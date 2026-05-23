import { prisma } from '../../config/database';
import { redisHelper } from '../../config/redis';
import { AppError } from '../../utils/AppError';
import { AdminUserQueryInput, CreateTaskInput, GrantPointsInput, UpdateRoleInput } from './admin.schema';

export class AdminService {
  async getStats() {
    const cached = await redisHelper.get('admin_stats');
    if (cached) return JSON.parse(cached);

    const todayStart = new Date();
    todayStart.setHours(0, 0, 0, 0);

    const [totalUsers, totalManga, totalChapters, totalComments, newUsersToday, activePremium] = await Promise.all([
      prisma.user.count(),
      prisma.manga.count(),
      prisma.chapter.count(),
      prisma.comment.count(),
      prisma.user.count({ where: { createdAt: { gte: todayStart } } }),
      prisma.user.count({ where: { isPremium: true, premiumUntil: { gt: new Date() } } }),
    ]);

    const stats = {
      total_users: totalUsers,
      total_manga: totalManga,
      total_chapters: totalChapters,
      total_comments: totalComments,
      new_users_today: newUsersToday,
      active_premium: activePremium,
    };

    await redisHelper.setEx('admin_stats', 600, JSON.stringify(stats));
    return stats;
  }

  async getUsers(query: AdminUserQueryInput) {
    const { page, limit, role, search } = query;
    const skip = (page - 1) * limit;

    const where: any = {};
    if (role) where.role = role;
    if (search) {
      where.OR = [
        { username: { contains: search, mode: 'insensitive' } },
        { email: { contains: search, mode: 'insensitive' } },
      ];
    }

    const [data, total] = await Promise.all([
      prisma.user.findMany({
        where,
        skip,
        take: limit,
        orderBy: { createdAt: 'desc' },
        select: {
          id: true,
          email: true,
          username: true,
          role: true,
          pointBalance: true,
          isPremium: true,
          premiumUntil: true,
          createdAt: true,
        },
      }),
      prisma.user.count({ where }),
    ]);

    return { data, pagination: { page, limit, total } };
  }

  async updateUserRole(targetUserId: string, newRole: string, adminId: string) {
    if (targetUserId === adminId) {
      throw new AppError('Không thể tự đổi role của chính mình', 400);
    }

    const user = await prisma.user.findUnique({ where: { id: targetUserId } });
    if (!user) throw new AppError('Người dùng không tồn tại', 404);

    return await prisma.user.update({
      where: { id: targetUserId },
      data: { role: newRole },
      select: { id: true, username: true, role: true },
    });
  }

  async createTask(data: CreateTaskInput) {
    return await prisma.task.create({
      data: {
        title: data.title,
        type: data.type,
        actionType: data.action_type,
        pointReward: data.point_reward,
        isActive: data.is_active,
      },
    });
  }

  async updateTask(taskId: string, data: any) {
    const task = await prisma.task.findUnique({ where: { id: taskId } });
    if (!task) throw new AppError('Nhiệm vụ không tồn tại', 404);

    const updateData: any = { ...data };
    if (data.action_type) {
      updateData.actionType = data.action_type;
      delete updateData.action_type;
    }
    if (data.point_reward) {
      updateData.pointReward = data.point_reward;
      delete updateData.point_reward;
    }
    if (data.is_active !== undefined) {
      updateData.isActive = data.is_active;
      delete updateData.is_active;
    }

    return await prisma.task.update({
      where: { id: taskId },
      data: updateData,
    });
  }

  async grantPoints(data: GrantPointsInput, adminId: string) {
    const user = await prisma.user.findUnique({ where: { id: data.user_id } });
    if (!user) throw new AppError('User không tồn tại', 404);

    if (data.amount < 0 && user.pointBalance + data.amount < 0) {
      throw new AppError('Điểm không đủ để trừ', 422);
    }

    const result = await prisma.$transaction(async (tx) => {
      const updatedUser = await tx.user.update({
        where: { id: data.user_id },
        data: { pointBalance: { increment: data.amount } },
      });

      await tx.pointTransaction.create({
        data: {
          userId: data.user_id,
          amount: data.amount,
          reason: data.reason,
          refId: adminId, // Lưu ID của admin thực hiện
        },
      });

      return updatedUser;
    });

    return {
      message: 'Cập nhật điểm thành công',
      amount: data.amount,
      new_balance: result.pointBalance,
    };
  }

  async deleteManga(mangaId: string) {
    const manga = await prisma.manga.findUnique({ where: { id: mangaId } });
    if (!manga) throw new AppError('Truyện không tồn tại', 404);

    await prisma.manga.delete({ where: { id: mangaId } });
    await redisHelper.del('home_data');
    return { message: 'Đã xoá manga thành công' };
  }
}
