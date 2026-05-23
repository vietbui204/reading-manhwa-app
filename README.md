# MangaX - Ứng dụng đọc truyện tranh hiện đại

MangaX là một nền tảng đọc truyện tranh trực tuyến được xây dựng với hiệu năng cao, trải nghiệm người dùng mượt mà và hệ thống Gamification (tích điểm đổi thưởng) hấp dẫn. Dự án sử dụng Flutter cho ứng dụng di động và Node.js (TypeScript) cho hệ thống Backend.

## 🚀 Tính năng chính

- **Trải nghiệm đọc mượt mà**: Hỗ trợ bộ nhớ đệm hình ảnh (Caching), tải trang thông minh.
- **Hệ thống Gamification**: Điểm danh hàng ngày, làm nhiệm vụ đọc truyện để nhận điểm thưởng.
- **Thông báo thời gian thực**: Nhận thông báo chương mới ngay lập tức qua Socket.io và Firebase Cloud Messaging.
- **Tìm kiếm thông minh**: Tìm kiếm truyện theo tên, tác giả và thể loại.
- **Thư viện cá nhân**: Theo dõi truyện, lưu lịch sử đọc và quản lý danh sách yêu thích.
- **Chế độ tối (Dark Mode)**: Giao diện hiện đại, thân thiện với mắt.

## 🛠 Công nghệ sử dụng

### Frontend (Flutter)
- **Kiến trúc**: Clean Architecture.
- **Quản lý trạng thái**: BLoC (Business Logic Component).
- **Mạng**: Dio & Retrofit.
- **DI**: GetIt & Injectable.
- **Điều hướng**: GoRouter.
- **Xử lý lỗi**: Dartz (Functional Programming).

### Backend (Node.js)
- **Framework**: Express.js với TypeScript.
- **Database**: PostgreSQL & Redis.
- **ORM**: Prisma.
- **Real-time**: Socket.io.
- **Lưu trữ**: Cloudflare R2 (S3 Compatible).

---

## 💻 Hướng dẫn cài đặt (Setup)

### 1. Yêu cầu hệ thống
- Flutter SDK v3.11.4 trở lên.
- Node.js v18 trở lên.
- Docker (khuyên dùng để chạy DB và Redis).

### 2. Cài đặt Backend
1. Di chuyển vào thư mục backend:
   ```bash
   cd backend
   ```
2. Cài đặt dependencies:
   ```bash
   npm install
   ```
3. Tạo file `.env` dựa trên file `.env.example` và cấu hình các thông số:
   - `DATABASE_URL`: Kết nối PostgreSQL.
   - `REDIS_URL`: Kết nối Redis.
   - `CLOUDFLARE_R2_*`: Cấu hình lưu trữ ảnh.
4. Chạy Docker Compose để khởi động Database:
   ```bash
   docker-compose up -d
   ```
5. Thực thi Migration và Seed dữ liệu:
   ```bash
   npx prisma migrate dev
   npx prisma db seed
   ```
6. Chạy ứng dụng ở chế độ phát triển:
   ```bash
   npm run dev
   ```

### 3. Cài đặt Frontend (Flutter)
1. Quay lại thư mục gốc:
   ```bash
   cd ..
   ```
2. Cài đặt dependencies:
   ```bash
   flutter pub get
   ```
3. Chạy build runner để sinh mã nguồn (Retrofit, Injectable):
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```
4. Cấu hình Firebase:
   - Thêm file `google-services.json` (Android) và `GoogleService-Info.plist` (iOS).
5. Chạy ứng dụng:
   ```bash
   flutter run
   ```

## 📂 Cấu trúc thư mục
- `/lib`: Chứa mã nguồn Flutter (Features, Core, Shared).
- `/backend`: Chứa mã nguồn Node.js (Prisma, Src, Config).
- `/baocao`: Chứa các tài liệu báo cáo dự án (.md).

