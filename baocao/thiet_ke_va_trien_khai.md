# CHI TIẾT THIẾT KẾ VÀ MÔ HÌNH TRIỂN KHAI HỆ THỐNG MANGAX

Tài liệu này trình bày chuyên sâu về kiến trúc phần mềm, thiết kế lớp, trải nghiệm người dùng (UX/UI) và mô hình vận hành thực tế của dự án.

---

## 1. Kiến trúc Ứng dụng (Application Architecture)

Dự án sử dụng kiến trúc **Clean Architecture** kết hợp với mẫu **Domain-Driven Design (DDD)** thu nhỏ để đảm bảo tính độc lập giữa các thành phần.

### 1.1. Luồng dữ liệu (Data Flow)
Hệ thống vận hành theo luồng một chiều nhằm kiểm soát trạng thái tốt hơn:
1.  **User Interface (UI)** phát ra các **Events**.
2.  **Bloc** nhận Event, gọi đến **UseCase** tương ứng.
3.  **UseCase** tương tác với **Repository** (Interface).
4.  **Repository Implementation** lấy dữ liệu từ **Remote Data Source** (API) hoặc **Local Data Source**.
5.  Dữ liệu trả về dưới dạng **Entity** (trong sáng, không phụ thuộc thư viện).
6.  **Bloc** cập nhật **State**, UI phản hồi lại trạng thái mới nhất cho người dùng.

### 1.2. Kiến trúc Backend
Sử dụng mô hình **Layered Architecture** (Kiến trúc phân lớp):
*   **Controller Layer**: Tiếp nhận request, validate dữ liệu đầu vào bằng Zod.
*   **Service Layer**: Chứa toàn bộ logic nghiệp vụ (tính điểm, kiểm tra quyền đọc, xử lý fan-out thông báo).
*   **Data Access Layer (Prisma)**: Tương tác với PostgreSQL và Redis thông qua các phương thức Type-safe.

---

## 2. Thiết kế Lớp (Class Design)

### 2.1. Cấu trúc thực thể (Entities)
Các lớp thực thể được thiết kế theo hướng bất biến (Immutable) sử dụng thư viện `Equatable`:
*   **UserEntity**: Định danh và vai trò.
*   **MangaEntity / MangaDetailEntity**: Chứa thông tin nội dung truyện.
*   **ChapterEntity / PageEntity**: Cấu trúc phân cấp của chương truyện.
*   **CommentEntity**: Mô hình dữ liệu cho tương tác xã hội.

### 2.2. Xử lý logic và trạng thái (Blocs)
Mỗi tính năng lớn có một cặp Bloc/Cubit riêng:
*   **AuthBloc**: Quản lý vòng đời đăng nhập.
*   **MangaDetailBloc**: Xử lý logic Thích/Follow với kỹ thuật **Optimistic Update** (cập nhật giao diện trước khi server phản hồi).
*   **NotificationBloc**: Chạy ở cấp ứng dụng (Global) để nhận dữ liệu từ Socket.IO.

---

## 3. Thiết kế UX/UI trên các nền tảng

Ứng dụng được thiết kế theo phong cách **Dark Mode** mặc định, tối ưu cho việc đọc truyện trong thời gian dài.

### 3.1. Trải nghiệm trên Mobile (Android/iOS)
*   **Navigation**: Bottom Navigation Bar 5 tab giúp người dùng truy cập nhanh các tính năng quan trọng bằng một tay.
*   **Trình đọc Webtoon**: Hỗ trợ cuộn dọc liên tục (Smooth scrolling) và cử chỉ chạm vào giữa màn hình để hiện/ẩn menu điều hướng.
*   **Hiệu ứng**: Sử dụng **Shimmer Loading** (Skeleton) để tạo cảm giác ứng dụng tải nhanh và mượt mà hơn.

### 3.2. Trải nghiệm trên Web (Edge/Chrome)
*   **Responsive**: Giao diện tự động điều chỉnh tỷ lệ khung hình truyện phù hợp với kích thước cửa sổ trình duyệt.
*   **Keyboard Support**: Hỗ trợ phím mũi tên để chuyển trang hoặc cuộn nội dung.
*   **Bảo mật**: Tận dụng cơ chế Sandbox của trình duyệt để xử lý các Blob URL khi upload ảnh.

---

## 4. Mô hình triển khai (Deployment Model)

Hệ thống được thiết kế theo mô hình **Client-Server** truyền thống nhưng phân tách các dịch vụ hạ tầng để tối ưu hiệu năng.

### 4.1. Các phân hệ chính
*   **Client App**: Chạy trên nền tảng Flutter (Web và Android).
*   **API Server**: Chạy trên Node.js (TypeScript), đóng gói trong Docker Container.
*   **Real-time Engine**: Socket.IO Server chạy song song với API để quản lý các kết nối thời gian thực.

### 4.2. Hạ tầng kỹ thuật
*   **Containerization**: Sử dụng **Docker Compose** để quản lý các dịch vụ PostgreSQL (Lưu trữ chính) và Redis (Cache/Session).
*   **Lưu trữ Cloud (Object Storage)**: Tích hợp **Cloudflare R2** để lưu trữ hàng Terabyte dữ liệu hình ảnh.
*   **Push Notification**: Sử dụng **Firebase Admin SDK** kết nối với Google FCM.
*   **Networking**: Chạy theo mô hình **Hybrid Cloud**, Backend có thể đặt tại VPS và Media đặt tại Cloudflare R2 để tối ưu chi phí băng thông.
