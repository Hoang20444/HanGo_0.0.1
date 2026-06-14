package com.hango.dto;

import com.hango.domain.UserRole;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

public final class AuthDtos {
  private AuthDtos() {}

  public record RegisterRequest(
      @NotBlank String fullName,
      @Email @NotBlank String email,
      @Size(min = 8) String password,
      UserRole role) {}

  public record LoginRequest(@Email @NotBlank String email, @NotBlank String password) {}

  public record GoogleLoginRequest(
      @Email @NotBlank String email, @NotBlank String fullName, String googleId) {}

  public record ForgotPasswordRequest(@Email @NotBlank String email) {}

  public record VerifyOtpRequest(@Email @NotBlank String email, @NotBlank String otp) {}

  public record ResetPasswordRequest(
      @Email @NotBlank String email,
      @NotBlank String otp,
      @Size(min = 8) String newPassword) {}

  public record AuthResponse(Long id, String fullName, String email, UserRole role, boolean active) {}
}
