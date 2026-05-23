import { z } from 'zod';

export const notificationQuerySchema = z.object({
  page: z.string().transform(val => parseInt(val, 10)).default('1'),
  limit: z.string().transform(val => parseInt(val, 10)).default('20'),
  type: z.enum(['new_chapter', 'new_follower', 'comment_reply', 'status_post', 'manga_published']).optional(),
});

export type NotificationQueryInput = z.infer<typeof notificationQuerySchema>;
