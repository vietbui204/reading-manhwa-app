# TÀI LIỆU CHI TIẾT KIẾN TRÚC, THIẾT KẾ VÀ TRIỂN KHAI HỆ THỐNG MANGAX

## 1. Kiến trúc Ứng dụng (Application Architecture)

Hệ thống MangaX được xây dựng dựa trên sự kết hợp của **Clean Architecture** (phía Frontend) và **Layered Architecture** (phía Backend).

### 1.1. Kiến trúc Clean Architecture (Flutter)
Ứng dụng được chia làm 3 lớp độc lập với nguyên tắc "Phụ thuộc hướng vào tâm" (Dependencies point inwards):

*   **Lớp Domain (Core Business Logic)**: Chứa các **Entities** (Thực thể kinh doanh), **UseCases** (Nghiệp vụ cụ thể như Đăng nhập, Mở khóa chương) và **Repository Interfaces**. Lớp này hoàn toàn "sạch", không chứa bất kỳ thư viện hiển thị hay logic truyền tải dữ liệu nào.
*   **Lớp Data (Infrastructure)**: Triển khai các Interface của lớp Domain. Bao gồm **DataSources** (gọi API qua Dio hoặc truy cập SharedPreferences), **Models** (có logic parse JSON) và **Repository Implementations** (điều phối luồng dữ liệu từ Remote và Local).
*   **Lớp Presentation (UI/State Management)**: Sử dụng mẫu **BLoC (Business Logic Component)** để quản lý trạng thái. UI chỉ nhận State để hiển thị và phát ra các Event, không trực tiếp xử lý nghiệp vụ.

### 1.2. Kiến trúc Backend (Node.js/Express)
Backend tuân thủ mô hình **Micro-service ready Layered Architecture**:
*   **Routes**: Định nghĩa các điểm cuối (Endpoints) và áp dụng Middleware (Xác thực, Phân quyền, Giới hạn lưu lượng).
*   **Controllers**: Điều hướng dữ liệu, tiếp nhận yêu cầu và phản hồi JSON theo chuẩn thống nhất.
*   **Services**: Chứa logic xử lý trung tâm, đảm bảo tính nguyên tử (Atomicity) của các giao dịch điểm thông qua **Prisma Transactions**.
*   **Database (ORM)**: Sử dụng **Prisma** như một lớp trừu tượng để tương tác với PostgreSQL, giúp code an toàn và dễ bảo trì.

---

## 2. Thiết kế Lớp (Class Design)

Hệ thống được thiết kế theo nguyên tắc **Single Responsibility (SOLID)**:

### 2.1. Phân cấp Thực thể (Entity Hierarchy)
*   **UserEntity**: Thực thể gốc quản lý định danh.
*   **MangaEntity**: Thực thể nền tảng cho nội dung.
*   **MangaDetailEntity**: Kế thừa MangaEntity, bổ sung danh sách Chapter cho màn hình chi tiết.
*   **ChapterEntity & PageEntity**: Cấu trúc thành phần để quản lý nội dung ảnh.

### 2.2. Xử lý Logic (UseCase & Bloc)
Mỗi hành động của người dùng được chuẩn hóa thành một lớp UseCase duy nhất (vd: `UnlockChapterUseCase`). Việc này giúp:
*   Dễ dàng tái sử dụng logic ở nhiều màn hình khác nhau.
*   Dễ dàng viết Unit Test cho từng chức năng độc lập.

---

## 3. Thiết kế Trải nghiệm (UX/UI Design)

Thiết kế tập trung vào sự tối giản, hiện đại và khả năng thích ứng đa nền tảng.

### 3.1. Nguyên tắc thiết kế UI
*   **Dark Mode First**: Sử dụng tông màu chủ đạo là đen (`#0F0F12`) và xám sâu để bảo vệ mắt và làm nổi bật màu sắc rực rỡ của truyện tranh.
*   **Accent Color**: Màu đỏ (`#E8192C`) được dùng cho các thành phần hành động (CTA), tạo sự kích thích và nhận diện thương hiệu.
*   **Typography**: Sử dụng font **Bebas Neue** cho các tiêu đề mạnh mẽ và **Noto Sans** cho phần nội dung để đảm bảo tính đọc hiểu cao.

### 3.2. UX Đa nền tảng (Cross-platform UX)
*   **Mobile**: Ưu tiên thao tác một tay với **Bottom Navigation Bar**. Các cử chỉ (gestures) như cuộn dọc mượt mà cho Webtoon và lật trang cho Manga. Sử dụng Shimmer (xương giao diện) để giảm cảm giác chờ đợi khi tải ảnh.
*   **Web**: Tối ưu hóa không gian hiển thị lớn. Trình đọc truyện tự động căn giữa và thu phóng ảnh theo kích thước trình duyệt. Hệ thống Upload (Creator) hỗ trợ kéo thả và xem trước ảnh (Preview) tức thì.

---

## 4. Mô hình Triển khai (Deployment Model)

Hệ thống được triển khai theo mô hình **Hybrid Cloud Distribution** nhằm tối ưu chi phí và hiệu suất.

### 4.1. Phân hệ và Nền tảng
*   **Mobile App (Android/iOS)**: Biên dịch từ Flutter, phân phối qua APK/Store.
*   **Web Portal**: Chạy trên trình duyệt Web (Chrome, Edge), tối ưu cho tác giả đăng truyện.
*   **API Server**: Chạy trên môi trường **Node.js Runtime**, đóng gói bằng **Docker** để dễ dàng scale ngang.

### 4.2. Mô hình Vận hành (Operational Model)
*   **Mô hình Client-Server**: Flutter App tương tác với REST API qua HTTPS.
*   **Mô hình Real-time (Pub/Sub)**: Sử dụng **Socket.IO** để duy trì kết nối bền vững, phục vụ việc đẩy thông báo (Push) mà không cần người dùng tải lại trang.
*   **Mô hình Lưu trữ phân tán**: 
    *   **PostgreSQL**: Lưu trữ dữ liệu cấu trúc (người dùng, quan hệ truyện).
    *   **Redis**: Lưu trữ dữ liệu tạm thời, cache API và buffer lượt xem.
    *   **Cloudflare R2**: Lưu trữ dữ liệu phi cấu trúc (hình ảnh) theo mô hình Edge Computing, giúp ảnh được tải từ node gần người dùng nhất.
