# BIỂU ĐỒ USE CASE (USE CASE DIAGRAM)

Biểu đồ này mô tả các tác nhân chính và các hành động họ thực hiện trong hệ thống MangaX.

## 1. Mã nguồn PlantUML

```puml
@startuml
left to right direction
skinparam theme plain
skinparam packageStyle rectangle
skinparam shadowing false

title BIỂU ĐỒ USE CASE - HỆ THỐNG MANGAX

actor "Người dùng chưa đăng nhập" as Guest
actor "Người dùng đã đăng nhập" as User
actor "Tác giả (Creator)" as Creator
actor "Quản trị viên (Admin)" as Admin

rectangle "Hệ thống MangaX" {
    
    package "Xác thực" {
        usecase "Đăng ký/Đăng nhập" as UC_Auth
        usecase "Đăng nhập Google" as UC_Google
    }
    
    package "Người dùng cơ bản" {
        usecase "Xem trang chủ & Ranking" as UC_ViewHome
        usecase "Tìm kiếm & Lọc truyện" as UC_Search
        usecase "Xem chi tiết truyện" as UC_MangaDetail
        usecase "Đọc chương truyện (Free)" as UC_ReadFree
    }
    
    package "Tính năng thành viên" {
        usecase "Thích & Theo dõi truyện" as UC_Interact
        usecase "Bình luận & Phản hồi" as UC_Comment
        usecase "Theo dõi người dùng khác" as UC_FollowUser
        usecase "Làm nhiệm vụ nhận điểm" as UC_Tasks
        usecase "Mở khóa chương bằng điểm" as UC_Unlock
        usecase "Nâng cấp Premium" as UC_Premium
        usecase "Quản lý lịch sử đọc" as UC_History
    }
    
    package "Dành cho Tác giả" {
        usecase "Tạo bộ truyện mới" as UC_CreateManga
        usecase "Đăng chương (Chapter) mới" as UC_AddChapter
        usecase "Quản lý truyện đã đăng" as UC_ManageManga
    }
    
    package "Dành cho Quản trị viên" {
        usecase "Xem thống kê hệ thống" as UC_Stats
        usecase "Quản lý người dùng & Vai trò" as UC_ManageUsers
        usecase "Quản lý nội dung vi phạm" as UC_Moderate
    }
}

Guest --> UC_Auth
Guest --> UC_Google
Guest --> UC_ViewHome
Guest --> UC_Search
Guest --> UC_MangaDetail
Guest --> UC_ReadFree

User --|> Guest
User --> UC_Interact
User --> UC_Comment
User --> UC_FollowUser
User --> UC_Tasks
User --> UC_Unlock
User --> UC_Premium
User --> UC_History

Creator --|> User
Creator --> UC_CreateManga
Creator --> UC_AddChapter
Creator --> UC_ManageManga

Admin --|> User
Admin --> UC_Stats
Admin --> UC_ManageUsers
Admin --> UC_Moderate

@enduml
```

## 2. Giải thích các tác nhân (Actors)

*   **Guest (Khách)**: Có quyền tiếp cận các nội dung công khai, tìm kiếm và đọc các chương truyện miễn phí.
*   **User (Thành viên)**: Kế thừa toàn bộ quyền của Khách, bổ sung các tính năng tương tác xã hội, tích lũy điểm và quản lý cá nhân.
*   **Creator (Tác giả)**: Kế thừa quyền của Thành viên, có thêm các công cụ để xuất bản và quản lý nội dung truyện.
*   **Admin (Quản trị viên)**: Có quyền cao nhất, quản lý toàn bộ hệ thống từ dữ liệu người dùng đến các số liệu thống kê kinh doanh.
