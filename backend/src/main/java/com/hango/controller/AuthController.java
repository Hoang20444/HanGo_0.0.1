package com.hango.controller;

import com.hango.dto.ApiMessage;
import com.hango.dto.AuthDtos.*;
import com.hango.service.AuthService;
import jakarta.validation.Valid;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/auth")
public class AuthController {
  private final AuthService authService;

  public AuthController(AuthService authService) {
    this.authService = authService;
  }

  @PostMapping("/register")
  AuthResponse register(@Valid @RequestBody RegisterRequest request) {
    return authService.register(request);
  }

  @PostMapping("/login")
  AuthResponse login(@Valid @RequestBody LoginRequest request) {
    return authService.login(request);
  }

  @PostMapping("/google-login")
  AuthResponse googleLogin(@Valid @RequestBody GoogleLoginRequest request) {
    return authService.googleLogin(request);
  }

  @PostMapping("/forgot-password")
  ApiMessage forgotPassword(@Valid @RequestBody ForgotPasswordRequest request) {
    return authService.sendForgotPasswordOtp(request);
  }

  @PostMapping("/verify-otp")
  ApiMessage verifyOtp(@Valid @RequestBody VerifyOtpRequest request) {
    return authService.verifyOtp(request);
  }

  @PostMapping("/reset-password")
  ApiMessage resetPassword(@Valid @RequestBody ResetPasswordRequest request) {
    return authService.resetPassword(request);
  }
}
