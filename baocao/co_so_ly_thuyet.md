# CƠ SỞ LÝ THUYẾT VÀ PHÂN TÍCH CÔNG NGHỆ CHI TIẾT - DỰ ÁN MANGAX

Bản báo cáo này cung cấp cái nhìn sâu sắc về các phương pháp, kỹ thuật và thư viện lập trình được sử dụng trong dự án MangaX. Nội dung tập trung vào cách thức hoạt động, lợi ích thực tế mang lại cho dự án và những mặt hạn chế cần lưu ý.

---

## 1. Kiến trúc phần mềm (Software Architecture)

### 1.1. Clean Architecture (Kiến trúc sạch)
Dự án áp dụng mô hình Clean Architecture để phân tách các quy tắc nghiệp vụ (business rules) khỏi các yếu tố kỹ thuật (UI, Database, Frameworks).

*   **Chi tiết phương pháp**: Hệ thống được chia thành 3 lớp chính:
    *   **Presentation Layer**: Chứa giao diện (UI) và logic quản lý trạng thái (BLoC).
    *   **Domain Layer**: Lớp trung tâm chứa các thực thể (Entities) và quy tắc nghiệp vụ (UseCases). Lớp này hoàn toàn không phụ thuộc vào bất kỳ thư viện bên ngoài nào.
    *   **Data Layer**: Triển khai các Repository, thực hiện gọi API (DataSources) và chuyển đổi dữ liệu (Models/Mappers).
*   **Lợi ích**:
    *   **Khả năng bảo trì**: Việc tách biệt rõ ràng giúp việc sửa lỗi hoặc thay đổi công nghệ ở lớp này không ảnh hưởng đến lớp khác.
    *   **Dễ dàng kiểm thử (Testability)**: Có thể viết Unit Test cho lớp Domain một cách độc lập mà không cần quan tâm đến giao diện hay kết nối mạng thật.
    *   **Tính linh hoạt**: Cho phép thay đổi Database hoặc UI framework mà không phải viết lại logic cốt lõi.
*   **Hạn chế**:
    *   **Độ phức tạp (Boilerplate)**: Đòi hỏi viết nhiều mã nguồn bổ sung cho các Interface, Models và Mappers để kết nối giữa các lớp.
    *   **Đường cong học tập**: Gây khó khăn cho các thành viên mới trong việc nắm bắt luồng dữ liệu đi qua nhiều lớp trung gian.

### 1.2. Mẫu thiết kế BLoC (Business Logic Component)
Sử dụng thư viện `flutter_bloc` để quản lý trạng thái ứng dụng theo cơ chế Reactive Programming.

*   **Chi tiết kỹ thuật**: BLoC nhận các **Events** từ giao diện, xử lý logic (thường thông qua UseCases) và phát ra (emit) các **States** mới để UI cập nhật.
*   **Lợi ích**:
    *   **Tính dự đoán (Predictability)**: Trạng thái ứng dụng chỉ thay đổi thông qua các Event cụ thể, giúp dễ dàng kiểm soát luồng logic và tái hiện lỗi khi debug.
    *   **Hiệu năng**: Chỉ những Widget thực sự cần thiết mới được cập nhật (rebuild) khi có State mới, đảm bảo trải nghiệm đọc truyện mượt mà.
*   **Hạn chế**:
    *   Cần tạo nhiều file (Event, State, Bloc) cho mỗi module nhỏ, có thể dẫn đến sự bùng nổ số lượng tệp tin trong dự án nếu không được tổ chức tốt.

---

## 2. Hệ sinh thái Frontend (Flutter)

### 2.1. Quản lý phụ thuộc: GetIt & Injectable
*   **Lợi ích**: Tự động hóa việc khởi tạo và quản lý vòng đời của các đối tượng (Dependency Injection). Giúp mã nguồn linh hoạt, dễ dàng "mock" dữ liệu khi làm Unit Test.
*   **Hạn chế**: Phụ thuộc vào quá trình phát sinh mã (Code generation), làm chậm thời gian build ban đầu của dự án.

### 2.2. Xử lý mạng: Dio & Retrofit
*   **Lợi ích**: 
    *   **Type-safety**: Retrofit đảm bảo dữ liệu trả về từ Server khớp chính xác với Model trong code, tránh lỗi runtime do sai kiểu dữ liệu.
    *   **Interceptors**: Dio cho phép xử lý tập trung việc thêm Token bảo mật hoặc tự động Refresh Token khi hết hạn (401 Unauthorized).
*   **Hạn chế**: Cấu hình ban đầu phức tạp để xử lý mọi trường hợp ngoại lệ của mạng.

### 2.3. Lập trình hàm với Dartz
*   **Lợi ích**: Sử dụng kiểu `Either<Failure, Success>` ép buộc lập trình viên phải xử lý mọi trường hợp lỗi ngay tại thời điểm viết code, làm giảm thiểu tối đa tình trạng ứng dụng bị đóng đột ngột (crash).
*   **Hạn chế**: Cú pháp lạ lẫm với những người chỉ quen phong cách lập trình mệnh lệnh (Imperative programming).

---

## 3. Hệ thống Backend (Node.js)

### 3.1. TypeScript & Express.js
*   **Lợi ích**: TypeScript cung cấp cơ chế kiểm tra kiểu (Static Typing), giúp phát hiện lỗi logic ngay từ lúc viết mã. Express.js nhẹ và cực kỳ linh hoạt cho việc xây dựng API nhanh chóng.
*   **Hạn chế**: Express không cung cấp khung quản lý file mặc định (opinionated framework), đòi hỏi đội ngũ phát triển phải tự thống nhất cấu trúc thư mục.

### 3.2. Cơ sở dữ liệu: PostgreSQL, Prisma & Redis
*   **Prisma ORM**: Tự động đồng bộ giữa Database Schema và code, giúp truy vấn dữ liệu cực kỳ an toàn (Type-safe). Tuy nhiên, có thể gặp vấn đề hiệu năng với các truy vấn quá phức tạp (Deep nesting).
*   **PostgreSQL**: Hệ quản trị DB quan hệ mạnh mẽ, hỗ trợ tốt cho dữ liệu có cấu trúc như thông tin người dùng và truyện.
*   **Redis**: Tăng tốc độ phản hồi cho các dữ liệu thường xuyên truy cập (top truyện, session), giảm tải cho Database chính. Hạn chế là cần cơ chế đồng bộ (Cache Invalidation) phức tạp.

---

## 4. Hạ tầng và Dịch vụ đặc thù

### 4.1. Cloudflare R2 (Lưu trữ ảnh Manga)
*   **Lợi ích chiến lược**: Đây là yếu tố then chốt cho một ứng dụng truyện tranh. R2 tương thích S3 nhưng **không tính phí băng thông ra (Zero Egress)**. Điều này giúp dự án tiết kiệm gần như 100% chi phí truyền tải dữ liệu hình ảnh khổng lồ.
*   **Hạn chế**: Hệ sinh thái công cụ hỗ trợ và các tính năng xử lý ảnh trực tiếp (Image Resizing) chưa phong phú bằng AWS S3.

### 4.2. Socket.IO & Firebase Cloud Messaging (FCM)
*   **Lợi ích**: Socket.IO hỗ trợ thông báo tức thì (Real-time). FCM giúp duy trì kết nối qua thông báo đẩy ngay cả khi người dùng đã thoát ứng dụng.
*   **Hạn chế**: Socket.IO tiêu tốn tài nguyên máy chủ để duy trì kết nối ổn định. FCM có độ trễ nhất định tùy thuộc vào dịch vụ của Google/Apple.

---

## 5. Kết luận
Việc kết hợp giữa các kiến trúc hiện đại (**Clean Architecture**) và các giải pháp hạ tầng tối ưu (**Cloudflare R2**) tạo nên một nền tảng vững chắc cho MangaX. Dù có một số hạn chế về độ phức tạp ban đầu, nhưng sự ổn định, tính bảo mật và khả năng tiết kiệm chi phí lâu dài là những giá trị cốt lõi mà các công nghệ này mang lại.
