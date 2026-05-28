# TÀI LIỆU MÔ TẢ CHI TIẾT CHỨC NĂNG HỆ THỐNG MANGAX

## 1. Phân hệ Quản lý Người dùng và Xác thực
*   **Xác thực đa phương thức**: Người dùng có thể đăng ký tài khoản mới qua Email hoặc sử dụng tài khoản Google để đăng nhập nhanh. Mật khẩu được bảo mật bằng thuật toán Bcrypt trước khi lưu trữ.
*   **Duy trì phiên đăng nhập**: Sử dụng cơ chế JWT kép (Access Token & Refresh Token). Token được lưu trữ an toàn trong Secure Storage của thiết bị để tránh các cuộc tấn công đánh cắp dữ liệu.
*   **Quản lý hồ sơ cá nhân**: Cho phép người dùng thay đổi ảnh đại diện (upload lên Cloudflare R2), cập nhật tên hiển thị và theo dõi các thông số cá nhân như số dư điểm, trạng thái Premium.

## 2. Phân hệ Khám phá và Tìm kiếm
*   **Trang chủ động (Dynamic Home)**: Tự động phân loại nội dung dựa trên thuật toán:
    *   **Banner**: Hiển thị truyện HOT dựa trên lượt xem thực tế.
    *   **Mới cập nhật**: Hiển thị truyện có chương mới trong vòng 24 giờ.
    *   **Bảng xếp hạng**: Vinh danh Top 10 truyện dựa trên lượt yêu thích.
*   **Bộ lọc nâng cao**: Tìm kiếm truyện theo tổ hợp: Thể loại (Genre), Trạng thái (Ongoing/Completed) và các tiêu chí sắp xếp.
*   **Tìm kiếm thông minh**: Tích hợp tính năng gợi ý kết quả khi đang gõ và cơ chế Debounce để tối ưu hóa hiệu năng hạ tầng.

## 3. Phân hệ Nội dung và Trình đọc (Manga Reader)
*   **Chi tiết truyện**: Cung cấp thông tin tóm tắt, đánh giá, danh sách chương và thông tin tác giả.
*   **Trình đọc đa chế độ**: Hỗ trợ chế độ đọc Webtoon (cuộn dọc liên tục) và chế độ Manga (lật trang ngang) với tính năng thu phóng (Pinch-to-zoom).
*   **Cài đặt trình đọc**: Cho phép điều chỉnh độ sáng màn hình trực tiếp trong app để tối ưu cho việc đọc ban đêm.
*   **Đồng bộ lịch sử**: Tự động lưu lại vị trí chương và trang đang đọc, giúp người dùng tiếp tục hành trình trên mọi thiết bị.

## 4. Phân hệ Tương tác Xã hội và Real-time
*   **Hệ thống Bình luận**: Hỗ trợ thảo luận đa tầng (1 cấp phản hồi), cho phép người dùng Like bình luận của nhau.
*   **Mạng xã hội thu nhỏ**: Tính năng Follow người dùng/tác giả và đăng dòng trạng thái (Status) để chia sẻ suy nghĩ.
*   **Thông báo Real-time**: Sử dụng Socket.IO để thông báo ngay lập tức (In-app) và Firebase FCM để gửi thông báo đẩy (Push Notification) khi có chương mới hoặc tương tác mới.

## 5. Phân hệ Gamification và Kinh doanh
*   **Nhiệm vụ nhận điểm**: Khuyến khích người dùng đăng nhập hàng ngày, đọc truyện và tương tác để nhận điểm tích lũy.
*   **Hệ thống Mở khóa**: Sử dụng điểm tích lũy để mở khóa các chương truyện có phí hoặc chương truyện sớm.
*   **Đặc quyền Premium**: Cho phép đăng ký các gói thuê bao để bỏ qua việc tích điểm, mở khóa toàn bộ kho nội dung và nhận badge huy hiệu đặc biệt.

## 6. Phân hệ Quản trị (Admin/Creator)
*   **Creator Studio**: Công cụ cho tác giả đăng truyện, quản lý chương và upload ảnh hàng loạt.
*   **Quản lý hệ thống**: Admin có quyền quản lý vai trò người dùng, kiểm duyệt nội dung và xem thống kê tăng trưởng.
