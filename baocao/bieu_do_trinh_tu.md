# BIỂU ĐỒ TRÌNH TỰ (SEQUENCE DIAGRAM)

Biểu đồ này mô tả luồng tương tác giữa các lớp khi thực hiện chức năng **Đăng nhập**.

## 1. Mã nguồn PlantUML

```puml
@startuml
skinparam theme plain
autonumber

actor "Người dùng" as User
participant "LoginPage (UI)" as UI
participant "AuthBloc" as Bloc
participant "LoginUseCase" as UC
participant "AuthRepository" as Repo
participant "AuthRemoteDataSource" as RDS
participant "API Server (Node.js)" as Server
database "PostgreSQL" as DB

User -> UI: Nhập email/mật khẩu & nhấn Đăng nhập
UI -> Bloc: Dispatch AuthLoginRequested(email, pass)
activate Bloc

Bloc -> UC: call(params)
UC -> Repo: login(email, pass)
Repo -> RDS: login(email, pass)

RDS -> Server: HTTP POST /api/auth/login
Server -> DB: findUserByEmail(email)
DB --> Server: user_data
Server -> Server: verifyPassword(hash)
Server --> RDS: 200 OK (User + Tokens)

RDS --> Repo: AuthTokenModel
Repo -> Repo: Save tokens to LocalStorage
Repo --> UC: Right(AuthToken)
UC --> Bloc: Right(AuthToken)
Bloc --> UI: emit AuthSuccess(user)
deactivate Bloc

UI -> User: Chuyển hướng sang HomePage
@enduml
```

## 2. Giải thích luồng xử lý

1.  **Tính đóng gói**: Người dùng chỉ tương tác với lớp UI. UI không bao giờ gọi trực tiếp API mà phải thông qua Bloc.
2.  **Tính minh bạch**: UseCase làm cầu nối, tách biệt logic nghiệp vụ khỏi cách thức lấy dữ liệu.
3.  **Xử lý bất đồng bộ**: Toàn bộ luồng từ RDS đến Repository đều xử lý bất đồng bộ (Future/Async) để tránh làm treo ứng dụng (ANR).
4.  **Lưu trữ an toàn**: Token được Repository chủ động lưu xuống thiết bị ngay sau khi nhận từ Data Source trước khi báo thành công lên Bloc.
