package com.hango.service;

import com.hango.domain.UserAccount;
import com.hango.domain.UserRole;
import com.hango.dto.AccountDtos.AccountResponse;
import com.hango.dto.AuthDtos.AuthResponse;

public final class AccountMapper {
  private AccountMapper() {}

  public static AccountResponse toAccountResponse(
      UserAccount user, UserRole role, boolean active) {
    return new AccountResponse(
        user.getId(),
        user.getFullName(),
        user.getEmail(),
        role,
        active,
        user.getDateOfBirth(),
        user.getGender(),
        user.getAddress(),
        user.getPhoneNumber(),
        user.getCreatedAt(),
        user.getUpdatedAt());
  }

  public static AuthResponse toAuthResponse(UserAccount user, UserRole role, boolean active) {
    return new AuthResponse(user.getId(), user.getFullName(), user.getEmail(), role, active);
  }
}

