import admin from 'firebase-admin';
import { logger } from '../utils/logger';

export const initFirebase = () => {
  try {
    const projectId = process.env.FIREBASE_PROJECT_ID;
    const clientEmail = process.env.FIREBASE_CLIENT_EMAIL;
    let privateKey = process.env.FIREBASE_PRIVATE_KEY;

    // Kiểm tra cấu hình tối thiểu
    if (!projectId || !privateKey || !clientEmail || privateKey.includes('your_')) {
      logger.warn('⚠️ Firebase chưa được cấu hình đúng. Tính năng Push Notification sẽ bị vô hiệu hóa.');
      return;
    }

    // Làm sạch key: Xử lý dấu ngoặc kép và ký tự xuống dòng
    const cleanedKey = privateKey
      .replace(/^"|"$/g, '') // Xóa ngoặc kép ở 2 đầu
      .replace(/\\n/g, '\n'); // Chuyển \n text thành ký tự xuống dòng thực tế

    // Kiểm tra định dạng PEM cơ bản
    if (!cleanedKey.startsWith('-----BEGIN PRIVATE KEY-----')) {
      logger.warn('⚠️ Định dạng FIREBASE_PRIVATE_KEY không hợp lệ (Thiếu PEM header).');
      return;
    }

    admin.initializeApp({
      credential: admin.credential.cert({
        projectId,
        clientEmail,
        privateKey: cleanedKey,
      }),
    });

    logger.info('✓ Firebase Admin initialized (Push Notifications Ready)');
  } catch (error: any) {
    // Log dưới dạng cảnh báo để không làm gián đoạn quá trình dev
    logger.warn(`⚠️ Firebase Admin không thể khởi tạo: ${error.message}`);
  }
};

export const messaging = () => admin.messaging();
