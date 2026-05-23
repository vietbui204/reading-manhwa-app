import jwt from 'jsonwebtoken';
import { AppError } from './AppError';

const accessTokenSecret = process.env.JWT_ACCESS_SECRET || 'access_secret';
const refreshTokenSecret = process.env.JWT_REFRESH_SECRET || 'refresh_secret';
const accessTokenExpiresIn = process.env.JWT_ACCESS_EXPIRES_IN || '15m';
const refreshTokenExpiresIn = process.env.JWT_REFRESH_EXPIRES_IN || '7d';

export interface TokenPayload {
  userId: string;
  role: string;
}

export interface RefreshPayload {
  userId: string;
}

export const signAccessToken = (payload: TokenPayload): string => {
  return jwt.sign(payload, accessTokenSecret, { expiresIn: accessTokenExpiresIn as any });
};

export const signRefreshToken = (payload: RefreshPayload): string => {
  return jwt.sign(payload, refreshTokenSecret, { expiresIn: refreshTokenExpiresIn as any });
};

export const verifyAccessToken = (token: string): TokenPayload => {
  try {
    return jwt.verify(token, accessTokenSecret) as TokenPayload;
  } catch (error: any) {
    if (error.name === 'TokenExpiredError') {
      throw new AppError('Token đã hết hạn', 401);
    }
    throw new AppError('Token không hợp lệ', 401);
  }
};

export const verifyRefreshToken = (token: string): RefreshPayload => {
  try {
    return jwt.verify(token, refreshTokenSecret) as RefreshPayload;
  } catch (error: any) {
    throw new AppError('Refresh Token không hợp lệ', 401);
  }
};
