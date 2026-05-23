import { z } from 'zod';

export const createChapterSchema = z.object({
  chapter_number: z.number().min(0, 'Số chapter không được âm'),
  title: z.string().optional(),
  is_locked: z.boolean().default(false),
  unlock_cost: z.number().min(0).default(0),
  is_premium_only: z.boolean().default(false),
});

export const updateChapterSchema = createChapterSchema.partial();

export const addPagesSchema = z.object({
  pages: z.array(z.object({
    page_number: z.number().min(1),
    image_url: z.string().url(),
  })).min(1, 'Phải có ít nhất 1 trang'),
});
