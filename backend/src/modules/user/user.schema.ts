import { z } from 'zod';

export const updateProfileSchema = z.object({
  username: z.string()
    .min(3, 'Username phải có ít nhất 3 ký tự')
    .max(20, 'Username không quá 20 ký tự')
    .regex(/^[a-z0-9_]+$/, 'Username chỉ được chứa chữ thường, số và gạch dưới')
    .optional(),
  avatar_url: z.string().url('URL ảnh không hợp lệ').optional(),
});

export const updateReadingHistorySchema = z.object({
  chapter_id: z.string().uuid('ID chapter không hợp lệ'),
});

export const userQuerySchema = z.object({
  page: z.string().transform(val => parseInt(val, 10)).default('1'),
  limit: z.string().transform(val => parseInt(val, 10)).default('20'),
});

export type UpdateProfileInput = z.infer<typeof updateProfileSchema>;
export type UserQueryInput = z.infer<typeof userQuerySchema>;
