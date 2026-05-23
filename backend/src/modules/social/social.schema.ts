import { z } from 'zod';

export const createStatusSchema = z.object({
  content: z.string().min(1, 'Nội dung không được để trống').max(500, 'Nội dung không quá 500 ký tự'),
});

export const followQuerySchema = z.object({
  page: z.string().transform(val => parseInt(val, 10)).default('1'),
  limit: z.string().transform(val => parseInt(val, 10)).default('20'),
});

export type CreateStatusInput = z.infer<typeof createStatusSchema>;
export type FollowQueryInput = z.infer<typeof followQuerySchema>;
