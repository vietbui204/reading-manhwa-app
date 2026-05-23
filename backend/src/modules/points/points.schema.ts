import { z } from 'zod';

export const completeTaskSchema = z.object({
  proof: z.object({
    chapter_id: z.string().uuid().optional(),
    manga_id: z.string().uuid().optional(),
  }).optional(),
});

export const pointHistoryQuerySchema = z.object({
  page: z.string().transform(val => parseInt(val, 10)).default('1'),
  limit: z.string().transform(val => parseInt(val, 10)).default('20'),
  reason: z.enum(['task_reward', 'chapter_unlock', 'admin_grant', 'admin_deduct']).optional(),
});

export type CompleteTaskInput = z.infer<typeof completeTaskSchema>;
export type PointHistoryQueryInput = z.infer<typeof pointHistoryQuerySchema>;
