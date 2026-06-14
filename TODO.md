# TODO - Fix DB connection + mapping mismatch (HanGo)

## Đã làm
- Cập nhật `backend/src/main/resources/application.yml` để dùng database `hango_db` thay vì `hango`.

## Cần làm tiếp
1. (Khuyến nghị) Đảm bảo backend đang chạy lại sau khi sửa config.
2. Kiểm tra Hibernate có tạo/đồng bộ bảng `user_accounts` hay không.
3. Nếu DB của bạn chỉ có bảng `users` (theo script), cần chỉnh entity `UserAccount` để map sang `users` thay vì `user_accounts`.
4. (Nếu cần) chỉnh các cột trong `UserAccount` (email/full_name/password_hash/role/status...) cho khớp schema `users` của bạn.
5. Test lại luồng đăng ký:
   - gọi `POST /api/auth/register`
   - xác nhận record xuất hiện đúng trong bảng `users`.

