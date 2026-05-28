# BÁO CÁO CHI TIẾT HỆ THỐNG MANGAX

Tài liệu này cung cấp cái nhìn toàn diện về dự án MangaX, từ đặc tả chức năng đến thiết kế kỹ thuật và mô hình triển khai.

---

## 1. Mô tả chi tiết các chức năng ứng dụng

Hệ thống được chia thành 5 phân hệ chính:

### 1.1. Phân hệ Quản lý Người dùng (Auth & Account)
*   **Xác thực**: Đăng ký, đăng nhập qua Email/Password hoặc Google OAuth 2.0. Sử dụng JWT (Json Web Token) để duy trì phiên làm việc.
*   **Hồ sơ (Profile)**: Hiển thị avatar, tên người dùng, vai trò (User/Creator/Admin), số dư điểm và trạng thái Premium.
*   **Follow User**: Cho phép người dùng theo dõi các tác giả hoặc độc giả khác.

### 1.2. Phân hệ Nội dung Manga (Content Management)
*   **Trang chủ**: Banner các bộ truyện nổi bật, danh sách truyện mới cập nhật và Top 10 bảng xếp hạng.
*   **Tìm kiếm & Lọc**: Tìm kiếm theo tên truyện và lọc theo đa tiêu chí (Action, Romance, Isekai...; Đang ra/Hoàn thành).
*   **Chi tiết truyện**: Thông tin tóm tắt, danh sách chương, lượt xem, lượt thích và lượt theo dõi.

### 1.3. Phân hệ Trình đọc (Manga Reader)
*   **Chế độ đọc Webtoon**: Tối ưu cuộn dọc mượt mà, tự động tải trước các trang tiếp theo.
*   **Cài đặt trình đọc**: Tùy chỉnh độ sáng và lưu lại chương truyện đang đọc vào lịch sử.
*   **Hệ thống Mở khóa**: Tích hợp popup yêu cầu dùng điểm để mở khóa các chương truyện có phí.

### 1.4. Phân hệ Tương tác & Real-time (Social)
*   **Bình luận**: Gửi bình luận và phản hồi dưới các bộ truyện.
*   **Thông báo (Notifications)**: Nhận thông báo tức thì khi truyện theo dõi có chương mới hoặc có tương tác mới thông qua Socket.IO và Firebase.
*   **Status Post**: Đăng dòng trạng thái cá nhân tương tự mạng xã hội.

### 1.5. Phân hệ Gamification (Reward System)
*   **Nhiệm vụ hàng ngày**: Đăng nhập, đọc truyện, bình luận để nhận điểm thưởng.
*   **Nâng cấp Premium**: Đăng ký các gói thành viên để hưởng đặc quyền đọc truyện không giới hạn.

---

## 2. Kiến trúc Ứng dụng và Thiết kế Lớp

### 2.1. Kiến trúc Clean Architecture (Frontend)
Ứng dụng Flutter tuân thủ nghiêm ngặt 3 lớp:
1.  **Presentation Layer**: Sử dụng **BLoC** làm trung tâm quản lý trạng thái. UI không chứa logic nghiệp vụ, chỉ nhận State và phát Event.
2.  **Domain Layer**: Chứa **Entities** và **UseCases**. Đây là nơi định nghĩa "Luật chơi" của ứng dụng, không phụ thuộc vào bất kỳ framework hay thư viện nào.
3.  **Data Layer**: Triển khai các **Repository**. Chuyển đổi dữ liệu từ API (Models) thành thực thể (Entities). Sử dụng **Dio** để giao tiếp mạng.

### 2.2. Thiết kế Lớp (Class Design)
*   **Entity classes**: Định nghĩa dữ liệu bất biến (vd: `MangaEntity`).
*   **Model classes**: Mở rộng từ Entity, bổ sung logic `fromJson` và `toJson` để giao tiếp với Backend.
*   **Bloc classes**: Mỗi phân hệ có Bloc riêng (vd: `AuthBloc`, `ReaderBloc`) để quản lý các trạng thái phức tạp.
*   **Repository classes**: Sử dụng mẫu **Repository Pattern** để trừu tượng hóa nguồn dữ liệu.

---

## 3. Thiết kế UX/UI trên các nền tảng

### 3.1. Triết lý thiết kế (Design Language)
*   **Dark Mode**: Giao diện tối chủ đạo giúp tập trung vào nội dung truyện tranh và bảo vệ mắt.
*   **Accent Red**: Sử dụng màu đỏ thương hiệu cho các hành động quan trọng (Call-to-Action).
*   **Skeleton Loading**: Sử dụng Shimmer effect khi chờ dữ liệu, tạo cảm giác ứng dụng phản hồi nhanh.

### 3.2. Đặc thù nền tảng
*   **Mobile (Android/iOS)**: Sử dụng Bottom Navigation Bar để thao tác 1 tay dễ dàng. Trình đọc hỗ trợ cử chỉ vuốt chạm linh hoạt.
*   **Web (Edge/Chrome)**: Giao diện Responsive tự động điều chỉnh theo kích thước màn hình máy tính. Tối ưu hóa trình đọc với khổ ảnh lớn và phím tắt bàn phím.

---

## 4. Mô hình triển khai và Phân hệ

Hệ thống được triển khai theo mô hình **Distributed Client-Server**.

### 4.1. Các Phân hệ Triển khai (Subsystems)
1.  **Mobile/Web Client**: Flutter app, giao tiếp với server qua REST API và WebSocket.
2.  **API Server**: Node.js (TypeScript) + Express, đóng gói trong **Docker**.
3.  **Database**: **PostgreSQL** lưu trữ dữ liệu chính.
4.  **Cache**: **Redis** lưu trữ Session và Buffer dữ liệu.
5.  **Storage**: **Cloudflare R2** chứa hình ảnh (ảnh bìa, trang truyện).

### 4.2. Nền tảng và Mô hình vận hành
*   **Nền tảng**: Hệ thống chạy đồng thời trên Web, Android và có khả năng build cho iOS.
*   **Mô hình vận hành**: 
    *   **Backend Transaction**: Sử dụng Prisma Transaction để đảm bảo an toàn dữ liệu điểm.
    *   **Hybrid Storage**: Dữ liệu text lưu ở Database, dữ liệu binary (ảnh) lưu ở Object Storage (R2).
    *   **Real-time Push**: Sự kết hợp giữa Socket.IO (khi app đang mở) và Firebase FCM (khi app đang đóng).
