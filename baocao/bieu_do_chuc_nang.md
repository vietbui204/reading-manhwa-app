# BIỂU ĐỒ PHÂN CẤP CHỨC NĂNG (FUNCTIONAL DECOMPOSITION DIAGRAM)

Dưới đây là biểu đồ mô tả cấu trúc các tính năng của ứng dụng MangaX được trình bày bằng ngôn ngữ PlantUML.

## 1. Mã nguồn PlantUML

```puml
@startuml
skinparam theme plain
skinparam packageStyle rectangle
skinparam shadowing false
skinparam defaultFontName "Arial"

title BIỂU ĐỒ PHÂN CẤP CHỨC NĂNG - HỆ THỐNG MANGAX

rectangle "Ứng dụng MangaX" as Root {
    
    rectangle "1. Quản lý Tài khoản" as Auth {
        rectangle "Đăng ký / Đăng nhập" as Login
        rectangle "Đăng nhập Google" as GoogleAuth
        rectangle "Quản lý Hồ sơ cá nhân" as Profile
        rectangle "Đổi mật khẩu / Quên mật khẩu" as PwdMgmt
    }
    
    rectangle "2. Khám phá & Tìm kiếm" as Discovery {
        rectangle "Trang chủ (Banner, Ranking)" as Home
        rectangle "Lọc truyện theo Thể loại" as GenreFilter
        rectangle "Tìm kiếm thông minh (Debounce)" as Search
        rectangle "Đề xuất nội dung" as Recommendation
    }
    
    rectangle "3. Nội dung & Trình đọc" as Reader {
        rectangle "Chi tiết bộ truyện" as MangaDetail
        rectangle "Danh sách chương (Chapter)" as Chapters
        rectangle "Trình đọc Webtoon (Cuộn dọc)" as VerticalReader
        rectangle "Điều chỉnh độ sáng & Chế độ đọc" as ReaderSettings
        rectangle "Tự động lưu lịch sử đọc" as History
    }
    
    rectangle "4. Tương tác & Xã hội" as Social {
        rectangle "Yêu thích & Theo dõi truyện" as Interaction
        rectangle "Bình luận & Phản hồi (1 cấp)" as Comments
        rectangle "Theo dõi người dùng (Follow)" as UserFollow
        rectangle "Thông báo thời gian thực (Socket.IO)" as Notifications
        rectangle "Đăng dòng trạng thái (Status)" as Status
    }
    
    rectangle "5. Gamification & Premium" as Gamification {
        rectangle "Hệ thống Nhiệm vụ (Daily/One-time)" as Tasks
        rectangle "Tích lũy & Nhận điểm" as Points
        rectangle "Mở khóa chương bằng điểm" as Unlock
        rectangle "Đăng ký thành viên Premium" as Premium
    }
    
    rectangle "6. Công cụ Sáng tác (Creator)" as Creator {
        rectangle "Tạo & Quản lý bộ truyện" as MangaMgmt
        rectangle "Thêm chương mới" as ChapterMgmt
        rectangle "Upload ảnh hàng loạt (Cloudflare R2)" as BatchUpload
    }
}

@enduml
```

## 2. Mô tả các nhóm chức năng chính

### 2.1. Quản lý Tài khoản (Authentication & User)
Cung cấp các phương thức xác thực bảo mật qua JWT (Access Token & Refresh Token). Cho phép người dùng cá nhân hóa thông tin cá nhân và quản lý trạng thái đăng nhập trên nhiều nền tảng.

### 2.2. Khám phá & Tìm kiếm (Discovery)
Hệ thống điều hướng giúp người dùng tiếp cận nội dung nhanh nhất thông qua các bộ lọc thể loại, bảng xếp hạng (Like/View) và cơ chế tìm kiếm tối ưu hóa hiệu năng (Debounce search).

### 2.3. Nội dung & Trình đọc (Manga Reader)
Trái tim của ứng dụng, hỗ trợ đọc truyện mượt mà với tính năng cache ảnh thông minh, tải trước (pre-load) trang tiếp theo và lưu trữ vị trí chương đã đọc gần nhất.

### 2.4. Tương tác & Xã hội (Social Interaction)
Xây dựng cộng đồng thông qua các tính năng Like, Follow và Comment. Hệ thống thông báo thời gian thực đảm bảo người dùng luôn cập nhật được các hoạt động mới nhất từ bộ truyện hoặc người dùng mà họ quan tâm.

### 2.5. Gamification & Hệ thống Điểm (Reward System)
Tăng tỷ lệ giữ chân người dùng (Retention rate) bằng cách khuyến khích hoàn thành nhiệm vụ để nhận điểm. Điểm thưởng được dùng làm "tiền tệ" trong app để mở khóa các nội dung trả phí hoặc nội dung độc quyền.

### 2.6. Công cụ Sáng tác (Creator Tools)
Dành cho người dùng có vai trò 'creator' hoặc 'admin'. Cung cấp giao diện upload mạnh mẽ, tích hợp trực tiếp với Cloudflare R2 để xử lý khối lượng lớn hình ảnh chất lượng cao.
