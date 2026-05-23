# PHÂN TÍCH VÀ THIẾT KẾ HỆ THỐNG MANGAX

## 1. Đối tượng sử dụng (Actors)
*   **Khách (Guest)**: Có thể xem danh sách truyện, đọc chương truyện công khai, tìm kiếm truyện.
*   **Người dùng (User)**: Đã đăng nhập, có thể theo dõi truyện, bình luận, đánh giá, nhận thông báo và tham gia hệ thống tích điểm/nhiệm vụ.
*   **Quản trị viên (Admin)**: Quản lý danh mục truyện, chương truyện, người dùng và các báo cáo vi phạm.

## 2. Các chức năng chính (Main Features)

### 2.1. Quản lý nội dung Manga
*   **Duyệt truyện**: Phân loại theo thể loại, trạng thái (đang tiến hành/hoàn thành), xếp hạng (Top views, Top likes).
*   **Đọc truyện**: Trình đọc tối ưu, hỗ trợ cuộn dọc/ngang, tự động lưu lịch sử chương đang đọc.
*   **Tìm kiếm**: Tìm kiếm thông minh theo tên, tác giả hoặc mô tả.

### 2.2. Tương tác và Cá nhân hóa
*   **Hệ thống Theo dõi (Library)**: Lưu các bộ truyện yêu thích và nhận thông báo khi có chương mới.
*   **Bình luận & Thảo luận**: Cho phép người dùng trao đổi trong mỗi chương truyện hoặc trang chi tiết truyện.
*   **Hệ thống Điểm (Points System)**: Người dùng làm nhiệm vụ hàng ngày (điểm danh, đọc truyện) để tích điểm đổi quà hoặc mở khóa chương đặc biệt.

### 2.3. Thông báo (Notifications)
*   Thông báo thời gian thực khi có chương mới từ truyện đang theo dõi.
*   Thông báo đẩy (Push) về các sự kiện hoặc cập nhật hệ thống.

## 3. Quy trình nghiệp vụ tiêu biểu
1.  **Quy trình Đọc & Tích điểm**: Người dùng đọc đủ thời gian quy định -> Hệ thống gửi Event về Backend -> Cộng điểm vào tài khoản -> Cập nhật State trên giao diện Flutter.
2.  **Quy trình Cập nhật chương mới**: Admin đăng tải chương -> Backend lưu vào DB & Cloudflare R2 -> Kích hoạt Socket.io gửi thông báo đến các Client đang online -> Gửi FCM đến các Client offline.
