# CHI TIẾT KIẾN TRÚC VÀ THIẾT KẾ LỚP HỆ THỐNG MANGAX

Tài liệu này mô tả cấu trúc kỹ thuật cốt lõi, cách thức tổ chức các lớp và luồng dữ liệu của ứng dụng.

## 1. Kiến trúc Clean Architecture (3 Layers)
Ứng dụng sử dụng kiến trúc Clean Architecture để tách biệt các mối quan tâm (Separation of Concerns), giúp hệ thống dễ bảo trì và mở rộng.

### 1.1. Lớp Domain (Lõi nghiệp vụ)
Đây là lớp quan trọng nhất, không phụ thuộc vào bất kỳ thư viện hay framework nào (kể cả Flutter).
*   **Entities**: Các lớp dữ liệu thuần túy (vd: `MangaEntity`, `UserEntity`) định nghĩa cấu trúc dữ liệu mà ứng dụng cần.
*   **UseCases**: Các lớp thực hiện một nhiệm vụ nghiệp vụ duy nhất (vd: `LoginUseCase`, `GetChapterPagesUseCase`). Mỗi UseCase đóng vai trò là một "Command" trong hệ thống.
*   **Repositories (Interfaces)**: Định nghĩa các bản hợp đồng dữ liệu. Lớp Domain không quan tâm dữ liệu đến từ đâu, nó chỉ yêu cầu các hành động (vd: `getMangaDetail`).

### 1.2. Lớp Data (Cơ sở hạ tầng)
Chịu trách nhiệm cung cấp dữ liệu thật cho lớp Domain.
*   **Models**: Kế thừa từ Entities nhưng bổ sung logic kỹ thuật như `fromJson`, `toJson`.
*   **DataSources**: Thực hiện các truy vấn mạng (Remote) qua Dio hoặc truy cập bộ nhớ máy (Local) qua Secure Storage/SharedPreferences.
*   **Repositories (Implementations)**: Triển khai các Interface từ Domain. Đây là nơi chứa logic điều phối, ví dụ: kiểm tra cache trước khi gọi API.

### 1.3. Lớp Presentation (Giao diện và Trạng thái)
*   **BLoC (Business Logic Component)**: Đóng vai trò là "bộ não" của giao diện. Nó nhận các **Events** từ người dùng, gọi UseCase xử lý và phát ra (emit) các **States** mới.
*   **Widgets**: Các thành phần UI của Flutter, chỉ làm nhiệm vụ hiển thị dựa trên State và gửi Event cho Bloc.

---

## 2. Thiết kế Lớp Chi tiết (Class Design)

Hệ thống áp dụng các nguyên lý **SOLID**:
*   **S (Single Responsibility)**: Mỗi Bloc, UseCase hay Repository chỉ chịu trách nhiệm cho một tính năng hoặc một nguồn dữ liệu duy nhất.
*   **O (Open/Closed)**: Dễ dàng thêm các tính năng mới (như thêm phương thức thanh toán) bằng cách tạo thêm UseCase mà không phải sửa đổi code cũ.
*   **D (Dependency Inversion)**: Các lớp cấp cao (Bloc) không phụ thuộc vào lớp cấp thấp (DataSource). Chúng kết nối với nhau thông qua các Interface (Repository) và được quản lý bởi **Dependency Injection (GetIt)**.

---

## 3. Quản lý lỗi và Phân giải dữ liệu
*   **Failures**: Định nghĩa các lớp lỗi thống nhất (`ServerFailure`, `AuthFailure`) giúp UI hiển thị thông báo lỗi chính xác cho người dùng.
*   **Resilient Parsing**: Các Model được thiết kế với các hàm `toInt`, `toBool` an toàn, giúp ứng dụng không bị crash khi Backend trả về dữ liệu thiếu hoặc sai định dạng (vd: null thay vì mảng rỗng).
