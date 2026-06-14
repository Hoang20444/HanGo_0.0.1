# HanGo Backend

Spring Boot API for authentication, forgot password OTP by email, password hashing, and admin account management.

## Requirements

- Java 21
- Maven 3.9+
- MySQL 8+

## Run

Create a MySQL database or let the app create it via `createDatabaseIfNotExist=true`.

```powershell
$env:DB_USERNAME="root"
$env:DB_PASSWORD="your_mysql_password"
$env:MAIL_USERNAME="your_email@gmail.com"
$env:MAIL_PASSWORD="your_app_password"
$env:MAIL_FROM="your_email@gmail.com"
mvn spring-boot:run
```

Default API base URL: `http://localhost:8081/api`.

If email credentials are empty, the OTP is logged to the backend console instead of being sent.

## Main endpoints

- `POST /api/auth/register`
- `POST /api/auth/login`
- `POST /api/auth/forgot-password`
- `POST /api/auth/verify-otp`
- `POST /api/auth/reset-password`
- `GET /api/admin/accounts`
- `POST /api/admin/accounts`
- `PUT /api/admin/accounts/{id}`
- `PATCH /api/admin/accounts/{id}/status`
- `DELETE /api/admin/accounts/{id}`
