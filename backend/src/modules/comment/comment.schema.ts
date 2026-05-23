import { z } from 'zod';

export const createCommentSchema = z.object({
  content: z.string().min(1, 'Bình luận không được để trống').max(1000, 'Bình luận quá dài'),
  parent_id: z.string().uuid('ID cha không hợp lệ').optional(),
});

export const updateCommentSchema = z.object({
  content: z.string().min(1, 'Bình luận không được để trống').max(1000, 'Bình luận quá dài'),
});

export const commentQuerySchema = z.object({
  cursor: z.string().uuid('Cursor không hợp lệ').optional(),
  limit: z.string().transform(val => parseInt(val, 10)).default('20'),
});

export type CreateCommentInput = z.infer<typeof createCommentSchema>;
export type UpdateCommentInput = z.infer<typeof updateCommentSchema>;
export type CommentQueryInput = z.infer<typeof commentQuerySchema>;
