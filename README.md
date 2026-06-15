# HanGo 4.0

Repo bao gồm 2 phần:
- **backend**: Spring Boot REST API (Java)
- **frontend**: Flutter app (Dart)

Tài liệu này hướng dẫn cách cài đặt và chạy dự án sau khi **pull** về máy.

---

## 1) Kiến trúc thư mục

- `backend/`
  - `src/main/java/...`: Spring Boot code
  - `src/main/resources/application.yml`: cấu hình MySQL, mail OTP, CORS
  - `src/main/resources/db/migration/`: migration SQL (Flyway)
  - `README.md`: hướng dẫn chạy riêng cho backend
- `frontend/`
  - `lib/main.dart`: entrypoint của Flutter
  - `lib/data/services/`: service gọi API backend
  - `pubspec.yaml`: khai báo dependencies

---

## 2) Yêu cầu hệ thống (Prerequisites)

### Backend (Spring Boot)
- **Java 21**
- **Maven 3.9+**
- **MySQL 8+**

### Frontend (Flutter)
- **Flutter SDK** (version tương thích với `frontend/pubspec.yaml`)
- Tương ứng code dùng:
  - `sdk: ^3.10.4`

---

## 3) Cấu hình MySQL cho backend

Backend đọc cấu hình MySQL từ biến môi trường và `application.yml`:

- `spring.datasource.url` (mặc định):
  - `jdbc:mysql://localhost:3306/hango_db2?createDatabaseIfNotExist=true&useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC`
- `spring.datasource.username`: `${DB_USERNAME:root}`
- `spring.datasource.password`: `${DB_PASSWORD:123456}`

Vì URL có `createDatabaseIfNotExist=true`, app có thể tự tạo database nếu MySQL user có quyền.

---

## 4) Cấu hình email OTP (Forgot password)

Backend gửi OTP qua mail (SMTP).

Trong `application.yml`:
- `spring.mail.username`: `${MAIL_USERNAME:}`
- `spring.mail.password`: `${MAIL_PASSWORD:}`
- `spring.mail.host`: `${MAIL_HOST:smtp.gmail.com}`
- `spring.mail.port`: `${MAIL_PORT:587}`
- `app.mail.from`: `${MAIL_FROM:no-reply@hango.local}`

Lưu ý:
- Nếu **MAIL_USERNAME / MAIL_PASSWORD để trống**, OTP sẽ được **log ra console** (theo mô tả trong `backend/README.md`).

---

## 5) Cấu hình base URL cho Flutter

Flutter gọi backend thông qua:
- `frontend/lib/data/services/api_client.dart`

Base URL lấy từ môi trường Dart:
- env `HANGO_API_BASE_URL`
- default: `http://localhost:8081/api`

Bạn có thể chạy Flutter với `--dart-define` để trỏ đúng backend.

---

## 6) Cách chạy Backend

### Bước 1: Chuẩn bị MySQL
- Tạo MySQL server và kiểm tra port **3306**.
- Không nhất thiết phải tạo database trước vì có `createDatabaseIfNotExist=true`, nhưng bạn có thể tạo thủ công nếu muốn.

### Bước 2: Set biến môi trường (Windows)
Trong PowerShell/CMD set các biến sau:

- `DB_USERNAME`
- `DB_PASSWORD`

Tùy chọn OTP:
- `MAIL_USERNAME`
- `MAIL_PASSWORD`
- `MAIL_FROM`

Ví dụ (PowerShell):
```powershell
$env:DB_USERNAME="root"
$env:DB_PASSWORD="your_mysql_password"
$env:MAIL_USERNAME="your_email@gmail.com"
$env:MAIL_PASSWORD="your_app_password"
$env:MAIL_FROM="your_email@gmail.com"
```

### Bước 3: Chạy Spring Boot
Chạy trong thư mục `backend/`:

```powershell
cd backend
mvn spring-boot:run
```

- Backend chạy mặc định tại:
  - **http://localhost:8081**
  - API base path: **/api**
  - Ví dụ endpoint: `http://localhost:8081/api/auth/login`

### Tài khoản seed để test nhanh
Backend có sẵn seed user (DataInitializer) khi app chạy.
- Admin: `admin@hango.local` / password `Password@123`
- Trainer: `trainer@hango.local` / password `Password@123`
- Learner: `learner@hango.local` / password `Password@123`

---

## 7) Cách chạy Frontend (Flutter)

### Bước 1: Di chuyển vào thư mục Flutter
```powershell
cd frontend
```

### Bước 2: Cài dependencies
```powershell
flutter pub get
```

### Bước 3: Chạy app
```powershell
flutter run
```

Nếu backend không chạy ở default `http://localhost:8081/api`, truyền base URL:
```powershell
flutter run --dart-define HANGO_API_BASE_URL="http://localhost:8081/api"
```

Lưu ý (theo TODO hiện có):
- **Chạy lệnh Flutter từ thư mục `frontend/`** (vì `lib/main.dart` nằm trong `frontend`).

---

## 8) Tham chiếu API endpoints (backend)

Danh sách endpoint chính (tóm tắt) nằm trong `backend/README.md`. Một số endpoint quan trọng:
- `POST /api/auth/register`
- `POST /api/auth/login`
- `POST /api/auth/forgot-password`
- `POST /api/auth/verify-otp`
- `POST /api/auth/reset-password`
- Admin endpoints (ví dụ):
  - `GET /api/admin/accounts`
  - `POST /api/admin/accounts`
  - `PUT /api/admin/accounts/{id}`
  - `PATCH /api/admin/accounts/{id}/status`
  - `DELETE /api/admin/accounts/{id}`

---

## 9)Khởi động bằng docker Docker (hiện trạng)

docker run --name hang_2.0 -e MYSQL_ROOT_PASSWORD=123456 -p 3306:3306 -d mysql:8.0

---

## 10) Build & test nhanh

### Backend
- Biên dịch/run: dùng `mvn spring-boot:run`
- Test: có thể chạy `mvn test` trong `backend/` (nếu dự án có test JUnit)

### Frontend
- Phụ thuộc dự án Flutter:
  - `flutter pub get`
  - `flutter analyze`
  - `flutter test`

---

## 11) Ghi chú cấu hình CORS

Backend dùng cấu hình CORS từ `app.cors.allowed-origins` trong `application.yml`:
- mặc định cho phép:
  - `http://localhost:*`
  - `http://127.0.0.1:*`

