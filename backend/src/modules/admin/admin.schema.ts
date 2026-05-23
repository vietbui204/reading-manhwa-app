import { z } from 'zod';

export const updateRoleSchema = z.object({
  role: z.enum(['user', 'creator', 'admin']),
});

export const createTaskSchema = z.object({
  title: z.string().min(1).max(100),
  type: z.enum(['daily', 'one_time']),
  action_type: z.enum(['read_chapter', 'comment', 'follow_manga', 'daily_login', 'share', 'follow_user']),
  point_reward: z.number().min(1).max(1000),
  is_active: z.boolean().default(true),
});

export const updateTaskSchema = createTaskSchema.partial();

export const grantPointsSchema = z.object({
  user_id: z.string().uuid(),
  amount: z.number().refine(n => n !== 0, "Số lượng điểm phải khác 0"),
  reason: z.enum(['admin_grant', 'admin_deduct']),
  note: z.string().optional(),
});

export const adminUserQuerySchema = z.object({
  page: z.string().transform(val => parseInt(val, 10)).default('1'),
  limit: z.string().transform(val => parseInt(val, 10)).default('20'),
  role: z.enum(['user', 'creator', 'admin']).optional(),
  search: z.string().optional(),
});

export type UpdateRoleInput = z.infer<typeof updateRoleSchema>;
export type CreateTaskInput = z.infer<typeof createTaskSchema>;
export type GrantPointsInput = z.infer<typeof grantPointsSchema>;
export type AdminUserQueryInput = z.infer<typeof adminUserQuerySchema>;
