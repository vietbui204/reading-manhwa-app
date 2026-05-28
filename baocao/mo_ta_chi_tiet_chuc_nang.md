# MÔ TẢ CHI TIẾT CÁC CHỨC NĂNG ỨNG DỤNG MANGAX

Tài liệu này chi tiết hóa các nghiệp vụ và hành vi của từng phân hệ trong hệ thống.

## 1. Phân hệ Quản lý Tài khoản (Auth & Profile)
*   **Đăng ký/Đăng nhập**: Hỗ trợ xác thực qua Email/Mật khẩu truyền thống với mật khẩu được băm (hash) bằng thuật toán Bcrypt.
*   **Google OAuth**: Tích hợp đăng nhập một chạm, tự động lấy thông tin email, tên và ảnh đại diện từ tài khoản Google.
*   **Xác thực JWT**: Sử dụng Access Token (ngắn hạn - 15p) để truy cập API và Refresh Token (dài hạn - 7 ngày) lưu trong bảo mật thiết bị (Secure Storage) để duy trì phiên đăng nhập.
*   **Hồ sơ người dùng**: 
    *   Hiển thị thông tin cá nhân, vai trò (User/Creator/Admin).
    *   Thống kê số lượng người theo dõi, đang theo dõi và số dư điểm tích lũy.

## 2. Phân hệ Khám phá & Tìm kiếm (Discovery)
*   **Trang chủ động**: Hiển thị Banner theo thuật toán (Truyện mới nhất hoặc lượt xem cao nhất), danh sách truyện mới cập nhật và bảng xếp hạng Top 10.
*   **Bộ lọc thông minh**: Cho phép lọc truyện theo nhiều tiêu chí đồng thời: Thể loại (Action, Romance...), Trạng thái (Đang ra, Hoàn thành) và Sắp xếp (Theo lượt xem, theo lượt thích).
*   **Tìm kiếm tối ưu**: Sử dụng kỹ thuật **Debounce (500ms)** để trì hoãn việc gọi API cho đến khi người dùng ngừng gõ, giúp giảm tải cho server và tăng tốc độ phản hồi.

## 3. Phân hệ Nội dung & Trình đọc (Reader)
*   **Chi tiết truyện**: Hiển thị mô tả, danh sách chương được sắp xếp ngược (mới nhất lên đầu) và trạng thái đọc của người dùng.
*   **Trình đọc Webtoon**: Tối ưu cho cuộn dọc liên tục, tự động tải trước (pre-load) 3 trang tiếp theo để đảm bảo trải nghiệm đọc không bị gián đoạn.
*   **Lịch sử đọc**: Tự động ghi nhận chương truyện ngay khi người dùng bắt đầu đọc (Upsert logic), hỗ trợ tính năng "Đọc tiếp" từ trang chủ.

## 4. Phân hệ Tương tác & Xã hội (Social)
*   **Bình luận & Phản hồi**: Hỗ trợ thảo luận dưới mỗi bộ truyện với cấu trúc 1 cấp (Comment gốc và các Reply của nó).
*   **Thông báo thời gian thực**: Sử dụng **Socket.IO** để đẩy thông báo ngay lập tức đến thiết bị khi:
    *   Bộ truyện đang theo dõi có chương mới.
    *   Có người phản hồi bình luận.
    *   Có người dùng mới follow.
*   **Dòng trạng thái (Status)**: Cho phép tác giả và người dùng đăng tin vắn, tự động thông báo cho tất cả người đang theo dõi (Fan-out pattern).

## 5. Phân hệ Gamification & Kinh doanh (Reward System)
*   **Hệ thống nhiệm vụ**: Chia làm 2 loại: Nhiệm vụ hàng ngày (Daily - reset lúc 00:00) và Nhiệm vụ một lần (One-time).
*   **Hệ thống điểm (Points)**: Điểm thưởng được dùng để mở khóa các chương truyện trả phí. Mọi giao dịch điểm đều được lưu vết (Audit log) trong bảng `point_transactions`.
*   **Gói Premium**: Cung cấp các gói thuê bao (Tháng/Quý/Năm) để người dùng có đặc quyền đọc mọi chương truyện mà không cần dùng điểm.

## 6. Phân hệ Quản trị & Sáng tác (Creator/Admin)
*   **Quản lý nội dung**: Creator có quyền tạo bộ truyện, chỉnh sửa thông tin và đăng chương mới.
*   **Batch Upload**: Cho phép tải lên hàng chục trang truyện cùng lúc, tự động xử lý lưu trữ trên Cloudflare R2 và đồng bộ URL vào Database.
*   **Dashboard Admin**: Thống kê tổng quan hệ thống (User mới, doanh thu Premium, lượng tương tác) và quản lý vi phạm.
