import { z } from 'zod';

export const createMangaSchema = z.object({
  title: z.string().min(1, 'Tiêu đề không được để trống').max(200, 'Tiêu đề quá dài'),
  description: z.string().optional(),
  cover_url: z.string().url('URL ảnh bìa không hợp lệ').optional(),
  status: z.enum(['ongoing', 'completed', 'hiatus']).default('ongoing'),
  genres: z.array(z.string()).optional().default([]),
});

export const updateMangaSchema = createMangaSchema.partial();

export const mangaQuerySchema = z.object({
  page: z.string().transform(val => parseInt(val, 10)).default('1'),
  limit: z.string().transform(val => parseInt(val, 10)).default('20'),
  genre: z.string().optional(),
  status: z.enum(['ongoing', 'completed', 'hiatus']).optional(),
  sort: z.enum(['latest', 'popular', 'view']).default('latest'),
  search: z.string().optional(),
});

export type CreateMangaInput = z.infer<typeof createMangaSchema>;
export type UpdateMangaInput = z.infer<typeof updateMangaSchema>;
export type MangaQueryInput = z.infer<typeof mangaQuerySchema>;
