import { prisma } from '../../config/database';
import { AppError } from '../../utils/AppError';

export class PremiumService {
  async getPremiumStatus(userId: string) {
    const user = await prisma.user.findUnique({
      where: { id: userId },
      select: { isPremium: true, premiumUntil: true },
    });

    if (!user) throw new AppError('Không tìm thấy người dùng', 404);

    const now = new Date();
    let isActive = user.isPremium;

    // Tự động kiểm tra hết hạn
    if (user.isPremium && user.premiumUntil && user.premiumUntil < now) {
      await prisma.user.update({
        where: { id: userId },
        data: { isPremium: false, premiumUntil: null },
      });
      isActive = false;
    }

    const daysRemaining = user.premiumUntil
      ? Math.ceil((user.premiumUntil.getTime() - now.getTime()) / (1000 * 60 * 60 * 24))
      : null;

    return {
      is_premium: isActive,
      premium_until: user.premiumUntil,
      is_active: isActive,
      days_remaining: daysRemaining > 0 ? daysRemaining : 0,
    };
  }

  getPremiumPlans() {
    return [
      {
        id: 'monthly',
        name: 'Gói tháng',
        price: 29000,
        currency: 'VND',
        duration: 30,
        description: 'Đọc không giới hạn trong 30 ngày',
        features: [
          'Đọc tất cả chapter premium',
          'Đọc chapter sớm nhất',
          'Không cần dùng điểm',
        ],
      },
      {
        id: 'quarterly',
        name: 'Gói quý',
        price: 79000,
        currency: 'VND',
        duration: 90,
        description: 'Tiết kiệm 10% so với gói tháng',
        features: [
          'Tất cả quyền lợi gói tháng',
          'Ưu tiên hỗ trợ',
        ],
      },
      {
        id: 'yearly',
        name: 'Gói năm',
        price: 249000,
        currency: 'VND',
        duration: 365,
        description: 'Tiết kiệm 30% so với gói tháng',
        features: [
          'Tất cả quyền lợi gói tháng',
          'Badge premium đặc biệt',
          'Ưu tiên hỗ trợ cao nhất',
        ],
      },
    ];
  }

  async activatePremium(userId: string, durationDays: number) {
    const premiumUntil = new Date();
    premiumUntil.setDate(premiumUntil.getDate() + durationDays);

    const updatedUser = await prisma.user.update({
      where: { id: userId },
      data: {
        isPremium: true,
        premiumUntil: premiumUntil,
      },
    });

    return {
      message: 'Kích hoạt Premium thành công',
      premium_until: updatedUser.premiumUntil,
    };
  }
}
