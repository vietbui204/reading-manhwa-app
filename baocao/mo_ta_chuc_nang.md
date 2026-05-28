# TÀI LIỆU MÔ TẢ CHI TIẾT CHỨC NĂNG HỆ THỐNG MANGAX

Hệ thống MangaX là một nền tảng đọc truyện tranh hiện đại, kết hợp giữa trải nghiệm đọc tối ưu và mạng xã hội tương tác.

## 1. Phân hệ Quản lý Người dùng và Bảo mật
*   **Xác thực đa lớp**: Người dùng có thể đăng ký tài khoản qua Email/Mật khẩu hoặc sử dụng Google OAuth để đăng nhập nhanh. Hệ thống sử dụng cơ chế JWT kép (Access Token và Refresh Token) giúp duy trì phiên làm việc an toàn và tự động.
*   **Quản lý Hồ sơ cá nhân**: Người dùng có thể tùy chỉnh Avatar (upload lên Cloudflare R2), thay đổi tên hiển thị và theo dõi các chỉ số: Số truyện đã đăng (đối với tác giả), số người theo dõi (Followers), và danh sách người đang theo dõi (Following).
*   **Phân quyền (RBAC)**: Hệ thống chia làm 3 vai trò chính:
    *   **User**: Đọc truyện, tương tác xã hội, tích điểm.
    *   **Creator**: Quyền của User cộng thêm khả năng tạo bộ truyện và đăng chương mới.
    *   **Admin**: Quản trị toàn bộ hệ thống, quản lý người dùng và xem thống kê.

## 2. Phân hệ Nội dung và Khám phá
*   **Trang chủ động (Dynamic Home)**: Tự động phân phối nội dung qua các thuật toán:
    *   **Banner**: Quảng bá các tác phẩm HOT dựa trên lượt xem.
    *   **Mới cập nhật**: Hiển thị truyện có chương mới trong 24h.
    *   **Bảng xếp hạng**: Vinh danh Top 10 dựa trên lượt Thích/Theo dõi.
*   **Tìm kiếm thông minh**: Hỗ trợ tìm kiếm theo tên truyện, tác giả với cơ chế gợi ý tức thì và xử lý Debounce (trì hoãn 500ms) để tối ưu hiệu năng.
*   **Bộ lọc đa tiêu chí**: Cho phép người dùng thu hẹp danh sách theo Thể loại, Trạng thái (Đang ra/Hoàn thành) và cách sắp xếp.

## 3. Phân hệ Trình đọc truyện chuyên sâu (Reader)
*   **Trình đọc Webtoon**: Tối ưu hóa cho việc cuộn dọc liên tục, tự động tải trước các trang ảnh tiếp theo (Pre-loading) để loại bỏ độ trễ khi đọc.
*   **Cài đặt trải nghiệm**: Người dùng có thể điều chỉnh độ sáng màn hình trực tiếp trong app, chuyển đổi linh hoạt giữa các chương qua Navbar ẩn/hiện thông minh.
*   **Đồng bộ lịch sử**: Hệ thống tự động ghi nhận chương truyện đã đọc ngay khi mở, hỗ trợ tính năng "Đọc tiếp" từ màn hình chính.

## 4. Phân hệ Tương tác Xã hội
*   **Hệ thống Bình luận đa cấp**: Người dùng có thể đăng bình luận dưới mỗi bộ truyện và phản hồi (Reply) bình luận của người khác. Tích hợp tính năng Like bình luận để tăng tính tương tác.
*   **Thông báo Real-time**: Sử dụng Socket.IO để gửi thông báo tức thời (In-app) về các sự kiện như: Có người Follow, có Chapter mới, hoặc có người phản hồi bình luận.
*   **Dòng trạng thái (Status)**: Cho phép người dùng đăng các tin vắn, chia sẻ suy nghĩ tương tự như một mạng xã hội thu nhỏ.

## 5. Phân hệ Gamification và Kinh doanh
*   **Nhiệm vụ & Điểm thưởng**: Người dùng nhận điểm qua các hoạt động hàng ngày (Đăng nhập, đọc truyện).
*   **Mở khóa chương (Unlock)**: Sử dụng điểm tích lũy để mua quyền truy cập vào các chương truyện độc quyền hoặc trả phí.
*   **Đặc quyền Premium**: Gói thuê bao giúp người dùng truy cập toàn bộ kho truyện không giới hạn và nhận huy hiệu xác minh trên hồ sơ.
