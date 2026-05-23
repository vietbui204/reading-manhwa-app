import { z } from 'zod';

export const registerSchema = z.object({
  email: z.string().email('Email không hợp lệ'),
  password: z.string().min(6, 'Mật khẩu phải có ít nhất 6 ký tự'),
  username: z.string()
    .min(3, 'Username phải có ít nhất 3 ký tự')
    .max(20, 'Username không quá 20 ký tự')
    .regex(/^[a-z0-9_]+$/, 'Username chỉ được chứa chữ thường, số và gạch dưới'),
  // Thêm .nullable() để chấp nhận giá trị null từ Client
  avatar_url: z.string().url('URL ảnh không hợp lệ').optional().nullable(),
});

export const loginSchema = z.object({
  email: z.string().email('Email không hợp lệ'),
  password: z.string().min(1, 'Vui lòng nhập mật khẩu'),
});

export const googleLoginSchema = z.object({
  id_token: z.string().min(1, 'Vui lòng cung cấp Google id_token'),
});

export const refreshTokenSchema = z.object({
  refresh_token: z.string().min(1, 'Vui lòng cung cấp refresh_token'),
});

export type RegisterInput = z.infer<typeof registerSchema>;
export type LoginInput = z.infer<typeof loginSchema>;
