import { PrismaClient } from '@prisma/client';
import { PrismaPg } from '@prisma/adapter-pg';
import { Pool } from 'pg';
import 'dotenv/config';

// 1. Khởi tạo Pool kết nối từ thư viện pg (cần thiết cho Prisma 7+ với Driver Adapters)
const pool = new Pool({
  connectionString: process.env.DATABASE_URL
});

// 2. Khởi tạo Adapter
const adapter = new PrismaPg(pool);

// 3. Khởi tạo PrismaClient với adapter
export const prisma = new PrismaClient({
  adapter,
  log: ['error', 'warn'],
});

export const connectDB = async () => {
  try {
    // Kiểm tra kết nối database thông qua Pool
    const client = await pool.connect();
    console.log('✓ Database connected (via Driver Adapter)');
    client.release();
  } catch (error) {
    console.error('✗ Database connection failed:', error);
    process.exit(1);
  }
};
