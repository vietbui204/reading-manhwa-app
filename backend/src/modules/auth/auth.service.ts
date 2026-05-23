import bcrypt from 'bcryptjs';
import { v4 as uuidv4 } from 'uuid';
import { OAuth2Client } from 'google-auth-library';
import { prisma } from '../../config/database';
import { redisHelper } from '../../config/redis';
import { AppError } from '../../utils/AppError';
import { signAccessToken, signRefreshToken } from '../../utils/jwt';
import { RegisterInput } from './auth.schema';

const googleClient = new OAuth2Client(process.env.GOOGLE_CLIENT_ID);

export class AuthService {
  async register(data: RegisterInput) {
    // 1. Check existing
    const existingUser = await prisma.user.findFirst({
      where: {
        OR: [{ email: data.email }, { username: data.username }],
      },
    });

    if (existingUser) {
      if (existingUser.email === data.email) throw new AppError('Email đã được sử dụng', 409);
      throw new AppError('Username đã được sử dụng', 409);
    }

    // 2. Hash password
    const passwordHash = await bcrypt.hash(data.password, 12);

    // 3. Create user
    const user = await prisma.user.create({
      data: {
        email: data.email,
        username: data.username,
        passwordHash: passwordHash,
        avatarUrl: data.avatar_url,
      },
    });

    // 4. Generate tokens
    const accessToken = signAccessToken({ userId: user.id, role: user.role });
    const refreshToken = signRefreshToken({ userId: user.id });

    // 5. Store in Redis (7 days)
    await redisHelper.setEx(`session:${user.id}`, 604800, refreshToken);

    const { passwordHash: _, ...userWithoutPassword } = user;
    return { accessToken, refreshToken, user: userWithoutPassword };
  }

  async login(email: string, password: string) {
    const user = await prisma.user.findUnique({ where: { email } });
    if (!user) throw new AppError('Email hoặc mật khẩu không đúng', 401);

    const isPasswordMatch = await bcrypt.compare(password, user.passwordHash);
    if (!isPasswordMatch) throw new AppError('Email hoặc mật khẩu không đúng', 401);

    const accessToken = signAccessToken({ userId: user.id, role: user.role });
    const refreshToken = signRefreshToken({ userId: user.id });

    await redisHelper.setEx(`session:${user.id}`, 604800, refreshToken);

    const { passwordHash: _, ...userWithoutPassword } = user;
    return { accessToken, refreshToken, user: userWithoutPassword };
  }

  async loginWithGoogle(idToken: string) {
    try {
      const ticket = await googleClient.verifyIdToken({
        idToken,
        audience: process.env.GOOGLE_CLIENT_ID,
      });
      const payload = ticket.getPayload();
      if (!payload || !payload.email) throw new AppError('Google token không hợp lệ', 400);

      let user = await prisma.user.findUnique({ where: { email: payload.email } });

      if (!user) {
        // Generate unique username
        let baseUsername = payload.email.split('@')[0].toLowerCase().replace(/[^a-z0-9_]/g, '');
        let username = baseUsername;
        let isUsernameTaken = true;

        while (isUsernameTaken) {
          const existing = await prisma.user.findUnique({ where: { username } });
          if (!existing) {
            isUsernameTaken = false;
          } else {
            username = `${baseUsername}_${Math.floor(Math.random() * 1000)}`;
          }
        }

        user = await prisma.user.create({
          data: {
            email: payload.email,
            username,
            passwordHash: await bcrypt.hash(uuidv4(), 12),
            avatarUrl: payload.picture,
          },
        });
      }

      const accessToken = signAccessToken({ userId: user.id, role: user.role });
      const refreshToken = signRefreshToken({ userId: user.id });

      await redisHelper.setEx(`session:${user.id}`, 604800, refreshToken);

      const { passwordHash: _, ...userWithoutPassword } = user;
      return { accessToken, refreshToken, user: userWithoutPassword };
    } catch (error: any) {
      if (error instanceof AppError) throw error;
      throw new AppError('Đăng nhập Google thất bại', 401);
    }
  }

  async refreshToken(refreshTokenInput: string) {
    const { verifyRefreshToken } = require('../../utils/jwt');
    const payload = verifyRefreshToken(refreshTokenInput);

    const savedToken = await redisHelper.get(`session:${payload.userId}`);
    if (!savedToken || savedToken !== refreshTokenInput) {
      throw new AppError('Token không hợp lệ hoặc đã hết hạn', 401);
    }

    const user = await prisma.user.findUnique({ where: { id: payload.userId } });
    if (!user) throw new AppError('User không tồn tại', 401);

    const accessToken = signAccessToken({ userId: user.id, role: user.role });
    return { accessToken };
  }

  async logout(userId: string) {
    await redisHelper.del(`session:${userId}`);
    return { message: 'Đăng xuất thành công' };
  }
}
