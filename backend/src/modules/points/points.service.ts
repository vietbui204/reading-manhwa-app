import { prisma } from '../../config/database';
import { redisHelper } from '../../config/redis';
import { AppError } from '../../utils/AppError';
import { PointHistoryQueryInput } from './points.schema';

export class PointsService {
  async getTasks(userId: string) {
    const tasks = await prisma.task.findMany({
      where: { isActive: true },
    });

    const results = await Promise.all(
      tasks.map(async (task) => {
        let isDone = false;
        if (task.type === 'daily') {
          const redisKey = `task_done:${userId}:${task.id}`;
          const exists = await redisHelper.exists(redisKey);
          isDone = exists === 1;
        } else {
          const completion = await prisma.taskCompletion.findFirst({
            where: { userId, taskId: task.id },
          });
          isDone = !!completion;
        }

        return {
          ...task,
          isDone,
          canClaim: !isDone,
        };
      })
    );

    return results;
  }

  async completeTask(userId: string, taskId: string, proof?: any) {
    const task = await prisma.task.findUnique({ where: { id: taskId } });
    if (!task || !task.isActive) throw new AppError('Nhiệm vụ không tồn tại hoặc đã bị vô hiệu hóa', 404);

    // Check duplicate
    if (task.type === 'daily') {
      const exists = await redisHelper.exists(`task_done:${userId}:${taskId}`);
      if (exists === 1) throw new AppError('Nhiệm vụ hôm nay đã hoàn thành', 409);
    } else {
      const completion = await prisma.taskCompletion.findFirst({
        where: { userId, taskId },
      });
      if (completion) throw new AppError('Nhiệm vụ đã hoàn thành trước đó', 409);
    }

    // Verify proof
    if (task.actionType === 'read_chapter') {
      if (!proof?.chapter_id) throw new AppError('Thiếu bằng chứng đọc chapter', 400);
      const history = await prisma.readingHistory.findUnique({
        where: { userId_chapterId: { userId, chapterId: proof.chapter_id } },
      });
      if (!history) throw new AppError('Bạn chưa đọc chapter này', 400);
    }

    if (task.actionType === 'follow_manga') {
      if (!proof?.manga_id) throw new AppError('Thiếu bằng chứng follow manga', 400);
      const follow = await prisma.mangaFollow.findUnique({
        where: { userId_mangaId: { userId, mangaId: proof.manga_id } },
      });
      if (!follow) throw new AppError('Bạn chưa follow truyện này', 400);
    }

    // Atomic transaction
    const result = await prisma.$transaction(async (tx) => {
      const user = await tx.user.findUnique({
        where: { id: userId },
        select: { pointBalance: true },
      });

      const completion = await tx.taskCompletion.create({
        data: { userId, taskId },
      });

      await tx.user.update({
        where: { id: userId },
        data: { pointBalance: { increment: task.pointReward } },
      });

      await tx.pointTransaction.create({
        data: {
          userId,
          amount: task.pointReward,
          reason: 'task_reward',
          refId: completion.id,
        },
      });

      return { completion, oldBalance: user!.pointBalance };
    });

    // Set Redis if daily
    if (task.type === 'daily') {
      const now = new Date();
      const tomorrow = new Date(now);
      tomorrow.setHours(24, 0, 0, 0);
      const ttlSeconds = Math.floor((tomorrow.getTime() - now.getTime()) / 1000);
      await redisHelper.setEx(`task_done:${userId}:${taskId}`, ttlSeconds, '1');
    }

    return {
      points_earned: task.pointReward,
      new_balance: result.oldBalance + task.pointReward,
      completion: result.completion,
    };
  }

  async getPointBalance(userId: string) {
    const user = await prisma.user.findUnique({
      where: { id: userId },
      select: { pointBalance: true },
    });
    return { balance: user?.pointBalance || 0 };
  }

  async getPointHistory(userId: string, query: PointHistoryQueryInput) {
    const { page, limit, reason } = query;
    const skip = (page - 1) * limit;

    const where: any = { userId };
    if (reason) where.reason = reason;

    const [data, total] = await Promise.all([
      prisma.pointTransaction.findMany({
        where,
        skip,
        take: limit,
        orderBy: { createdAt: 'desc' },
      }),
      prisma.pointTransaction.count({ where }),
    ]);

    return { data, pagination: { page, limit, total } };
  }

  async unlockChapter(userId: string, chapterId: string) {
    const chapter = await prisma.chapter.findUnique({ where: { id: chapterId } });
    if (!chapter) throw new AppError('Chapter không tồn tại', 404);
    if (!chapter.isLocked) throw new AppError('Chapter này không cần mở khóa', 400);
    if (chapter.isPremiumOnly) throw new AppError('Chapter này chỉ dành cho thành viên Premium', 400);

    const existingUnlock = await prisma.chapterUnlock.findUnique({
      where: { userId_chapterId: { userId, chapterId } },
    });
    if (existingUnlock) throw new AppError('Bạn đã mở khóa chapter này rồi', 409);

    const user = await prisma.user.findUnique({
      where: { id: userId },
      select: { pointBalance: true },
    });

    if (!user || user.pointBalance < chapter.unlockCost) {
      throw new AppError(`Không đủ điểm. Cần ${chapter.unlockCost}, bạn hiện có ${user?.pointBalance || 0}`, 422);
    }

    const result = await prisma.$transaction(async (tx) => {
      await tx.user.update({
        where: { id: userId },
        data: { pointBalance: { decrement: chapter.unlockCost } },
      });

      const unlock = await tx.chapterUnlock.create({
        data: {
          userId,
          chapterId,
          pointsSpent: chapter.unlockCost,
        },
      });

      await tx.pointTransaction.create({
        data: {
          userId,
          amount: -chapter.unlockCost,
          reason: 'chapter_unlock',
          refId: unlock.id,
        },
      });

      return unlock;
    });

    return {
      unlock: result,
      points_spent: chapter.unlockCost,
      new_balance: user.pointBalance - chapter.unlockCost,
    };
  }
}
