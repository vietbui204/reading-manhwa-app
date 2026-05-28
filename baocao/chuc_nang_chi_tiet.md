# MÔ TẢ CHI TIẾT CÁC CHỨC NĂNG ỨNG DỤNG MANGAX

Hệ thống MangaX được thiết kế để cung cấp trải nghiệm đọc truyện tranh toàn diện, kết hợp giữa việc đọc nội dung và tương tác cộng đồng.

## 1. Phân hệ Quản lý Người dùng
*   **Xác thực bảo mật**: Hỗ trợ đăng ký và đăng nhập qua Email/Mật khẩu. Tích hợp Google OAuth giúp rút ngắn quy trình đăng ký. Hệ thống sử dụng JWT (JSON Web Token) để duy trì phiên làm việc, bao gồm cơ chế Access Token và Refresh Token tự động.
*   **Quản lý hồ sơ (Profile)**: Người dùng có trang cá nhân riêng hiển thị Avatar, Username, Vai trò (Người dùng, Tác giả, Quản trị viên), số dư điểm thưởng và trạng thái Premium.
*   **Mạng xã hội**: Tính năng Follow (Theo dõi) giữa các người dùng. Khi một tác giả được theo dõi đăng truyện mới, người theo dõi sẽ nhận được thông báo tức thì.

## 2. Phân hệ Khám phá và Nội dung
*   **Trang chủ thông minh**: 
    *   **Banner**: Hiển thị các truyện nổi bật (Hot/Trending) dựa trên lượt xem.
    *   **Mới cập nhật**: Liệt kê các bộ truyện vừa có chương mới trong vòng 24h.
    *   **Bảng xếp hạng (Rankings)**: Vinh danh Top 10 bộ truyện có lượt thích và theo dõi cao nhất.
*   **Tìm kiếm & Lọc**: Công cụ tìm kiếm hỗ trợ tìm theo tên truyện, tác giả. Bộ lọc cho phép phân loại theo Thể loại (Action, Romance, Isekai...), Trạng thái (Đang ra, Hoàn thành) và các tiêu chí sắp xếp.
*   **Chi tiết truyện**: Cung cấp cái nhìn tổng quan về nội dung, thông tin tác giả, các số liệu thống kê (Lượt xem, Thích, Theo dõi, Bình luận) và danh sách toàn bộ các chương.

## 3. Phân hệ Trình đọc truyện (Manga Reader)
*   **Chế độ Webtoon**: Tối ưu cho trải nghiệm cuộn dọc liên tục trên di động và web.
*   **Hệ thống Cache & Pre-load**: Tự động tải trước các trang tiếp theo khi người dùng đang đọc, đảm bảo không có độ trễ khi chuyển trang.
*   **Cài đặt cá nhân**: Cho phép điều chỉnh độ sáng màn hình trực tiếp trong giao diện đọc để phù hợp với môi trường ánh sáng.
*   **Lịch sử đọc**: Tự động lưu lại chương truyện cuối cùng mà người dùng vừa mở, hỗ trợ tính năng "Đọc tiếp" từ trang chủ.

## 4. Phân hệ Tương tác xã hội
*   **Hệ thống Bình luận**: Cho phép người dùng thảo luận dưới mỗi bộ truyện. Hỗ trợ phản hồi (Reply) một cấp để giữ cho luồng thảo luận gọn gàng.
*   **Thông báo (Notifications)**: Hệ thống thông báo đa kênh:
    *   **In-app**: Thông báo thời gian thực qua Socket.IO khi đang mở ứng dụng.
    *   **Push**: Thông báo đẩy qua Firebase Cloud Messaging (FCM) khi ứng dụng đang đóng.
*   **Dòng trạng thái (Status)**: Người dùng có thể đăng các cập nhật ngắn để chia sẻ suy nghĩ, tin tức với những người đang theo dõi mình.

## 5. Phân hệ Gamification và Kinh doanh
*   **Hệ thống nhiệm vụ (Tasks)**: Bao gồm nhiệm vụ hàng ngày (như Đăng nhập) và nhiệm vụ một lần (như Follow truyện). Hoàn thành nhiệm vụ giúp người dùng tích lũy điểm thưởng.
*   **Mở khóa nội dung (Unlock)**: Sử dụng điểm thưởng tích lũy để mở khóa các chương truyện có phí hoặc chương truyện bản quyền.
*   **Đặc quyền Premium**: Người dùng có thể đăng ký gói Premium để đọc toàn bộ kho truyện không giới hạn, không cần tích điểm và sở hữu huy hiệu Premium đặc biệt trên hồ sơ.

## 6. Phân hệ Creator (Công cụ cho tác giả)
*   **Quản lý truyện**: Giao diện cho phép tác giả tạo bộ truyện mới, cập nhật mô tả và ảnh bìa.
*   **Đăng chương (Upload)**: Hệ thống hỗ trợ tải lên hàng loạt ảnh trang truyện (Batch Upload), tự động xử lý và lưu trữ trên Cloudflare R2.
