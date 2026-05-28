# CHI TIẾT KIẾN TRÚC VÀ THIẾT KẾ LỚP HỆ THỐNG MANGAX

Tài liệu này phân tích cấu trúc kỹ thuật cốt lõi của ứng dụng, đảm bảo tính mở rộng và dễ bảo trì.

## 1. Kiến trúc Ứng dụng (Application Architecture)

Hệ thống được xây dựng trên sự kết hợp của hai mô hình kiến trúc hiện đại:

### 1.1. Frontend: Clean Architecture (3 Layers)
Ứng dụng Flutter tuân thủ nghiêm ngặt mô hình 3 lớp độc lập:
*   **Lớp Domain (Core)**: Là lớp trung tâm, không phụ thuộc vào bất kỳ thư viện nào. Nó định nghĩa các **Entities** (Thực thể dữ liệu như Manga, User) và **UseCases** (Các logic nghiệp vụ đơn lẻ như `LoginUseCase`, `UnlockChapterUseCase`).
*   **Lớp Data (Infrastructure)**: Chịu trách nhiệm giao tiếp với thế giới bên ngoài. Nó triển khai các Repository Interfaces từ lớp Domain. Chứa các **Models** (dùng để parse JSON), **DataSources** (gọi API qua Dio) và **Mappers**.
*   **Lớp Presentation (UI)**: Sử dụng mẫu **BLoC (Business Logic Component)** để quản lý trạng thái. UI chỉ đóng vai trò hiển thị và phát ra các Event, mọi logic xử lý đều nằm trong Bloc.

### 1.2. Backend: Layered Architecture (Phân lớp)
Backend Node.js được chia thành các phân hệ (Modules) độc lập:
*   **Route**: Định nghĩa các điểm cuối (Endpoints) của API.
*   **Controller**: Xử lý yêu cầu HTTP và điều phối phản hồi.
*   **Service**: Tầng xử lý logic nghiệp vụ trung tâm (Business Logic).
*   **Repository/Prisma**: Tương tác trực tiếp với cơ sở dữ liệu.

---

## 2. Thiết kế Lớp Chi tiết (Class Design)

Hệ thống được thiết kế theo các mẫu thiết kế (Design Patterns) tiêu chuẩn:

### 2.1. Mẫu Repository (Repository Pattern)
Giúp trừu tượng hóa nguồn dữ liệu. Ví dụ: `MangaRepository` định nghĩa hành động lấy danh sách truyện. Phiên bản triển khai `MangaRepositoryImpl` sẽ quyết định lấy từ API hay Cache, giúp lớp Domain không bị ảnh hưởng bởi sự thay đổi của công nghệ lưu trữ.

### 2.2. Mẫu Thực thể và Mô hình (Entity vs Model)
*   **Entity**: Chứa các thuộc tính dữ liệu thuần túy phục vụ ứng dụng (ví dụ: `MangaEntity` có tiêu đề và ảnh bìa).
*   **Model**: Là phiên bản "kỹ thuật" của Entity nằm ở lớp Data. Nó bổ sung các hàm xử lý dữ liệu như `fromJson`, `toJson` để làm việc với API.

### 2.3. Mẫu Quản lý Trạng thái (State Management)
Sử dụng **States** để đại diện cho mọi tình huống của UI:
*   `InitialState`: Trạng thái ban đầu.
*   `LoadingState`: Đang tải dữ liệu.
*   `LoadedState`: Tải thành công kèm theo dữ liệu Entity.
*   `ErrorState`: Xảy ra lỗi kèm theo thông báo.

---

## 3. Ưu điểm của thiết kế
*   **Dễ kiểm thử (Testability)**: Các UseCase có thể được kiểm thử độc lập mà không cần khởi động giao diện.
*   **Tính linh hoạt**: Có thể thay đổi Database (ví dụ từ PostgreSQL sang MongoDB) mà không phải sửa code giao diện Flutter.
*   **Tính ổn định**: Lỗi ở một phân hệ (ví dụ: lỗi parsing ảnh) sẽ được khu trú và xử lý thông qua Error Handling tập trung, không làm sập toàn bộ ứng dụng.
