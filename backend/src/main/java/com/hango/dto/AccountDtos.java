package com.hango.dto;

import com.hango.domain.UserRole;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import java.time.Instant;
import java.time.LocalDate;

public final class AccountDtos {
  private AccountDtos() {}

  public record AccountResponse(
      Long id,
      String fullName,
      String email,
      UserRole role,
      boolean active,
      LocalDate dateOfBirth,
      String gender,
      String address,
      String phoneNumber,
      Instant createdAt,
      Instant updatedAt) {}

  public record UpsertAccountRequest(
      @NotBlank String fullName,
      @Email @NotBlank String email,
      @Size(min = 8) String password,
      UserRole role,
      Boolean active,
      LocalDate dateOfBirth,
      String gender,
      String address,
      String phoneNumber) {}

  public record UpdateAccountRequest(
      @NotBlank String fullName,
      @Email @NotBlank String email,
      UserRole role,
      Boolean active,
      LocalDate dateOfBirth,
      String gender,
      String address,
      String phoneNumber,
      String password) {}

  public record StatusRequest(boolean active) {}
}
