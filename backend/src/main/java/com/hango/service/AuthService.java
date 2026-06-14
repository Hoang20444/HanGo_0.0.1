package com.hango.service;

import com.hango.domain.PasswordResetOtp;
import com.hango.domain.Role;
import com.hango.domain.UserAccount;
import com.hango.domain.UserRole;
import com.hango.domain.UserRoleJoin;
import com.hango.dto.ApiMessage;
import com.hango.dto.AuthDtos.*;
import com.hango.exception.ApiException;
import com.hango.repository.PasswordResetOtpRepository;
import com.hango.repository.RoleRepository;
import com.hango.repository.UserAccountRepository;
import com.hango.repository.UserRoleJoinRepository;


import java.security.SecureRandom;
import java.time.Duration;
import java.time.Instant;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class AuthService {
  private final UserAccountRepository userRepository;
  private final PasswordResetOtpRepository otpRepository;
  private final PasswordEncoder passwordEncoder;
  private final EmailService emailService;

  private final RoleRepository roleRepository;
  private final UserRoleJoinRepository userRoleJoinRepository;

  private final SecureRandom random = new SecureRandom();

  @Value("${app.otp.ttl-minutes:10}")
  private long otpTtlMinutes;

  public AuthService(
      UserAccountRepository userRepository,
      PasswordResetOtpRepository otpRepository,
      PasswordEncoder passwordEncoder,
      EmailService emailService,
      RoleRepository roleRepository,
      UserRoleJoinRepository userRoleJoinRepository) {
    this.userRepository = userRepository;
    this.otpRepository = otpRepository;
    this.passwordEncoder = passwordEncoder;
    this.emailService = emailService;
    this.roleRepository = roleRepository;
    this.userRoleJoinRepository = userRoleJoinRepository;
  }


  @Transactional
  public AuthResponse register(RegisterRequest request) {
    String email = normalizeEmail(request.email());
    if (userRepository.existsByEmailIgnoreCase(email)) {
      throw new ApiException(HttpStatus.CONFLICT, "Email is already registered");
    }

    UserAccount user = new UserAccount();
    user.setFullName(request.fullName().trim());
    user.setEmail(email);
    user.setPasswordHash(passwordEncoder.encode(request.password()));
    user.setActive(true);

    // Dữ liệu role đang không lưu vào bảng users theo entity hiện tại,
    // chỉ cần đảm bảo user được save đúng vào DB.
    return AccountMapper.toAuthResponse(userRepository.save(user), UserRole.LEARNER, true);
  }


  @Transactional(readOnly = true)
  public AuthResponse login(LoginRequest request) {
    UserAccount user =
        userRepository
            .findByEmailIgnoreCase(normalizeEmail(request.email()))
            .orElseThrow(() -> new ApiException(HttpStatus.UNAUTHORIZED, "Invalid email or password"));

    if (!user.isActive()) {
      throw new ApiException(HttpStatus.FORBIDDEN, "This account is inactive");
    }

    if (!passwordEncoder.matches(request.password(), user.getPasswordHash())) {
      throw new ApiException(HttpStatus.UNAUTHORIZED, "Invalid email or password");
    }

    // Role join table phần này hiện chưa sẵn sàng cho entity đang dùng.
    // Tạm thời default LEARNER để đảm bảo đăng ký/đăng nhập ghi DB hoạt động.
    return AccountMapper.toAuthResponse(user, UserRole.LEARNER, user.isActive());

  }

  @Transactional
  public AuthResponse googleLogin(GoogleLoginRequest request) {
    String email = normalizeEmail(request.email());
    String fullName = request.fullName() == null ? "" : request.fullName().trim();

    UserAccount user =
        userRepository
            .findByEmailIgnoreCase(email)
            .orElseGet(
                () -> {
                  UserAccount u = new UserAccount();
                  u.setEmail(email);
                  u.setFullName(fullName.isBlank() ? "Google User" : fullName);
                  u.setActive(true);

                  // Since Google is the auth method, mark password as random/unusable.
                  u.setPasswordHash(passwordEncoder.encode("%google_auth_unusable%"));
                  return userRepository.save(u);
                });

    if (!user.isActive()) {
      throw new ApiException(HttpStatus.FORBIDDEN, "This account is inactive");
    }

    // Default role for Google login: LEARNER (can be adjusted later)
    UserRole defaultRole = UserRole.LEARNER;

    Role role =
        roleRepository
            .findByRoleName(defaultRole)
            .orElseThrow(() -> new IllegalStateException("Role not found: " + defaultRole));

    boolean roleExists =
        userRoleJoinRepository.existsByIdUserIdAndIdRoleId(user.getId(), role.getId());
    if (!roleExists) {
      UserRoleJoin join = new UserRoleJoin();
      join.setUser(user);
      join.setRole(role);
      join.getId().setUserId(user.getId());
      join.getId().setRoleId(role.getId());
      userRoleJoinRepository.save(join);
    }

    return AccountMapper.toAuthResponse(user, defaultRole, user.isActive());
  }

  @Transactional
  public ApiMessage sendForgotPasswordOtp(ForgotPasswordRequest request) {
    String email = normalizeEmail(request.email());
    if (userRepository.findByEmailIgnoreCase(email).isEmpty()) {
      throw new ApiException(HttpStatus.NOT_FOUND, "No account found for this email");
    }

    String otp = "%06d".formatted(random.nextInt(1_000_000));

    PasswordResetOtp entity = new PasswordResetOtp();
    entity.setEmail(email);
    entity.setOtpHash(passwordEncoder.encode(otp));
    entity.setExpiresAt(Instant.now().plus(Duration.ofMinutes(otpTtlMinutes)));
    otpRepository.save(entity);

    // OTP thực gửi vào mail của user
    emailService.sendPasswordResetOtp(email, otp);
    return new ApiMessage("OTP has been sent");
  }

  @Transactional(readOnly = true)
  public ApiMessage verifyOtp(VerifyOtpRequest request) {
    findValidOtp(normalizeEmail(request.email()), request.otp());
    return new ApiMessage("OTP is valid");
  }

  @Transactional
  public ApiMessage resetPassword(ResetPasswordRequest request) {
    String email = normalizeEmail(request.email());
    PasswordResetOtp otp = findValidOtp(email, request.otp());

    UserAccount user =
        userRepository
            .findByEmailIgnoreCase(email)
            .orElseThrow(() -> new ApiException(HttpStatus.NOT_FOUND, "No account found for this email"));
    user.setPasswordHash(passwordEncoder.encode(request.newPassword()));
    otp.setUsed(true);

    return new ApiMessage("Password has been reset");
  }

  private PasswordResetOtp findValidOtp(String email, String otp) {
    return otpRepository
        .findTopByEmailIgnoreCaseAndUsedFalseOrderByCreatedAtDesc(email)
        .orElseThrow(() -> new ApiException(HttpStatus.BAD_REQUEST, "Invalid OTP"));
  }

  private String normalizeEmail(String email) {
    return email == null ? "" : email.trim().toLowerCase();
  }
}

