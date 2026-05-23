import { PrismaClient } from '@prisma/client';
import { PrismaPg } from '@prisma/adapter-pg';
import { Pool } from 'pg';
import bcrypt from 'bcryptjs';
import 'dotenv/config';

const pool = new Pool({ connectionString: process.env.DATABASE_URL });
const adapter = new PrismaPg(pool);
const prisma = new PrismaClient({ adapter });

async function main() {
  const passwordHash = await bcrypt.hash('Admin@123456', 12);

  // 1. Users
  const admin = await prisma.user.upsert({
    where: { email: 'admin@mangax.com' },
    update: {},
    create: {
      email: 'admin@mangax.com',
      passwordHash,
      username: 'admin',
      role: 'admin',
    },
  });

  const creator = await prisma.user.upsert({
    where: { email: 'creator@mangax.com' },
    update: {},
    create: {
      email: 'creator@mangax.com',
      passwordHash,
      username: 'manga_creator',
      role: 'creator',
    },
  });

  const user = await prisma.user.upsert({
    where: { email: 'user@mangax.com' },
    update: {},
    create: {
      email: 'user@mangax.com',
      passwordHash,
      username: 'manga_reader',
      role: 'user',
    },
  });

  // 2. Tasks
  const tasks = [
    { title: 'Đăng nhập hàng ngày', type: 'daily', actionType: 'daily_login', pointReward: 10 },
    { title: 'Đọc 1 chapter', type: 'daily', actionType: 'read_chapter', pointReward: 20 },
    { title: 'Đăng bình luận đầu tiên', type: 'one_time', actionType: 'comment', pointReward: 50 },
    { title: 'Follow 1 bộ truyện', type: 'one_time', actionType: 'follow_manga', pointReward: 30 },
    { title: 'Follow 1 tác giả', type: 'one_time', actionType: 'follow_user', pointReward: 30 },
  ];

  for (const t of tasks) {
    await prisma.task.upsert({
      where: { id: '00000000-0000-0000-0000-000000000000' }, // Dummy id for seed check
      update: {},
      create: { ...t },
    });
  }

  // 3. Manga
  await prisma.manga.create({
    data: {
      authorId: creator.id,
      title: 'Demon Slayer Test',
      description: 'Mô tả truyện test action fantasy',
      status: 'ongoing',
      genres: ['action', 'fantasy'],
    },
  });

  await prisma.manga.create({
    data: {
      authorId: creator.id,
      title: 'Blue Lock Test',
      description: 'Mô tả truyện test sports',
      status: 'ongoing',
      genres: ['sports'],
    },
  });

  console.log('✓ Seed data completed');
}

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
    await pool.end();
  });
