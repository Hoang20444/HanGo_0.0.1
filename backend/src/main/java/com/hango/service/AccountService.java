package com.hango.service;

import com.hango.domain.Role;
import com.hango.domain.UserAccount;
import com.hango.domain.UserRole;
import com.hango.domain.UserRoleJoin;
import com.hango.dto.AccountDtos.*;
import com.hango.exception.ApiException;
import com.hango.repository.RoleRepository;
import com.hango.repository.UserAccountRepository;
import com.hango.repository.UserRoleJoinRepository;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;
import org.springframework.http.HttpStatus;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

@Service
public class AccountService {
  private final UserAccountRepository userRepository;
  private final UserRoleJoinRepository userRoleJoinRepository;
  private final RoleRepository roleRepository;
  private final PasswordEncoder passwordEncoder;

  public AccountService(
      UserAccountRepository userRepository,
      UserRoleJoinRepository userRoleJoinRepository,
      RoleRepository roleRepository,
      PasswordEncoder passwordEncoder) {
    this.userRepository = userRepository;
    this.userRoleJoinRepository = userRoleJoinRepository;
    this.roleRepository = roleRepository;
    this.passwordEncoder = passwordEncoder;
  }

  @Transactional(readOnly = true)
  public List<AccountResponse> list(UserRole role, String query) {
    List<UserAccount> baseUsers;
    if (StringUtils.hasText(query)) {
      baseUsers =
          userRepository
              .findByFullNameContainingIgnoreCaseOrEmailContainingIgnoreCaseOrderByCreatedAtDesc(
                  query.trim(), query.trim());
    } else {
      baseUsers = userRepository.findAll();
    }

    // Role mapping từ user_roles (userId -> role)
    List<UserRoleJoin> joins;
    if (role == null) {
      joins = userRoleJoinRepository.findAll();
      Map<Long, UserRole> userIdToRole =
          joins.stream()
              .collect(
                  Collectors.toMap(
                      j -> j.getId().getUserId(),
                      j -> j.getRole().getRoleName(),
                      (a, b) -> a));
      return baseUsers.stream()
          .map(
              user -> {
                UserRole resolvedRole = userIdToRole.getOrDefault(user.getId(), UserRole.LEARNER);
                return AccountMapper.toAccountResponse(user, resolvedRole, user.isActive());
              })
          .toList();
    } else {
      joins = userRoleJoinRepository.findByRole_RoleName(role);

      Set<Long> allowedUserIds =
          joins.stream().map(j -> j.getId().getUserId()).collect(Collectors.toSet());

      // chỉ giữ user trong baseUsers có thuộc role được chọn
      return baseUsers.stream()
          .filter(u -> allowedUserIds.contains(u.getId()))
          .map(
              u ->
                  AccountMapper.toAccountResponse(
                      u, role, u.isActive()))
          .toList();
    }
  }


  @Transactional
  public AccountResponse create(UpsertAccountRequest request) {
    String email = normalizeEmail(request.email());
    if (userRepository.existsByEmailIgnoreCase(email)) {
      throw new ApiException(HttpStatus.CONFLICT, "Email is already registered");
    }

    UserAccount user = new UserAccount();
    user.setEmail(email);
    user.setPasswordHash(passwordEncoder.encode(request.password()));

    // optional profile fields
    user.setFullName(request.fullName().trim());
    user.setActive(request.active() == null ? user.isActive() : request.active());
    user.setDateOfBirth(request.dateOfBirth());
    user.setGender(request.gender());

    if (StringUtils.hasText(request.address())) {
      user.setAddress(request.address().trim());
    }
    if (StringUtils.hasText(request.phoneNumber())) {
      user.setPhoneNumber(request.phoneNumber().trim());
    }

    UserAccount saved = userRepository.save(user);

    UserRole resolvedRole = request.role() == null ? UserRole.LEARNER : request.role();
    upsertUserRole(saved.getId(), resolvedRole);

    return AccountMapper.toAccountResponse(saved, resolvedRole, saved.isActive());
  }

  @Transactional
  public AccountResponse update(Long id, UpdateAccountRequest request) {
    UserAccount user = getAccount(id);
    String email = normalizeEmail(request.email());
    userRepository
        .findByEmailIgnoreCase(email)
        .filter(existing -> !existing.getId().equals(id))
        .ifPresent(
            existing -> {
              throw new ApiException(HttpStatus.CONFLICT, "Email is already registered");
            });

    user.setEmail(email);
    user.setFullName(request.fullName().trim());
    user.setActive(request.active() == null ? user.isActive() : request.active());
    user.setDateOfBirth(request.dateOfBirth());
    user.setGender(request.gender());

    if (StringUtils.hasText(request.address())) {
      user.setAddress(request.address().trim());
    }
    if (StringUtils.hasText(request.phoneNumber())) {
      user.setPhoneNumber(request.phoneNumber().trim());
    }

    if (StringUtils.hasText(request.password())) {
      user.setPasswordHash(passwordEncoder.encode(request.password()));
    }

    UserRole resolvedRole = request.role() == null ? UserRole.LEARNER : request.role();
    upsertUserRole(user.getId(), resolvedRole);

    return AccountMapper.toAccountResponse(user, resolvedRole, user.isActive());
  }

  @Transactional
  public AccountResponse updateStatus(Long id, StatusRequest request) {
    UserAccount user = getAccount(id);
    user.setActive(request.active());

    UserRoleJoin join =
        userRoleJoinRepository.findTopByIdUserId(id).orElse(null);
    UserRole resolvedRole = join == null ? UserRole.LEARNER : join.getRole().getRoleName();

    return AccountMapper.toAccountResponse(user, resolvedRole, user.isActive());
  }

  @Transactional
  public void delete(Long id) {
    UserAccount user = getAccount(id);
    userRepository.delete(user);
  }

  private UserAccount getAccount(Long id) {
    return userRepository
        .findById(id)
        .orElseThrow(() -> new ApiException(HttpStatus.NOT_FOUND, "Account not found"));
  }

  private void applyCreateFields(UserAccount user, UpsertAccountRequest request) {
    // Entity hiện tại không lưu role/address/phone theo state sửa đổi.
    user.setFullName(request.fullName().trim());
    user.setActive(request.active() == null || request.active());
    user.setDateOfBirth(request.dateOfBirth());
    user.setGender(request.gender());
    // phone/address không có setter trong UserAccount hiện tại
  }


  private void upsertUserRole(Long userId, UserRole role) {
    Role resolvedRole =
        roleRepository
            .findByRoleName(role)
            .orElseThrow(() -> new IllegalStateException("Role not found: " + role));

    boolean exists = userRoleJoinRepository.existsByIdUserIdAndIdRoleId(userId, resolvedRole.getId());
    if (exists) return;

    UserAccount user = getAccount(userId);

    UserRoleJoin join = new UserRoleJoin();
    join.setUser(user);
    join.setRole(resolvedRole);
    join.getId().setUserId(userId);
    join.getId().setRoleId(resolvedRole.getId());
    userRoleJoinRepository.save(join);
  }

  private String normalizeEmail(String email) {
    return email == null ? "" : email.trim().toLowerCase();
  }
}
