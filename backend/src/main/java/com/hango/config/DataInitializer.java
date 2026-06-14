package com.hango.config;

import com.hango.domain.Role;
import com.hango.domain.UserAccount;
import com.hango.domain.UserRole;
import com.hango.domain.UserRoleJoin;
import com.hango.repository.RoleRepository;
import com.hango.repository.UserAccountRepository;
import com.hango.repository.UserRoleJoinRepository;
import java.util.Optional;
import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.crypto.password.PasswordEncoder;

@Configuration
public class DataInitializer {

  @Bean
  CommandLineRunner seedUsers(
      UserAccountRepository users,
      RoleRepository roles,
      UserRoleJoinRepository userRoleJoins,
      PasswordEncoder passwordEncoder) {
    return args -> {
      seedRoleIfMissing(roles, UserRole.ADMIN);
      seedRoleIfMissing(roles, UserRole.TRAINER);
      seedRoleIfMissing(roles, UserRole.LEARNER);

      seedUserWithRole(
          users,
          roles,
          userRoleJoins,
          passwordEncoder,
          "Admin HanGo",
          "admin@hango.local",
          UserRole.ADMIN);

      seedUserWithRole(
          users,
          roles,
          userRoleJoins,
          passwordEncoder,
          "Trainer HanGo",
          "trainer@hango.local",
          UserRole.TRAINER);

      seedUserWithRole(
          users,
          roles,
          userRoleJoins,
          passwordEncoder,
          "Learner HanGo",
          "learner@hango.local",
          UserRole.LEARNER);
    };
  }

  private void seedRoleIfMissing(RoleRepository roles, UserRole roleName) {
    roles.findByRoleName(roleName).orElseGet(
        () -> {
          Role r = new Role();
          r.setRoleName(roleName);
          return roles.save(r);
        });
  }

  private void seedUserWithRole(
      UserAccountRepository users,
      RoleRepository roles,
      UserRoleJoinRepository userRoleJoins,
      PasswordEncoder passwordEncoder,
      String fullName,
      String email,
      UserRole roleName) {

    String normalizedEmail = email == null ? "" : email.trim().toLowerCase();
    Optional<UserAccount> existingUserOpt = users.findByEmailIgnoreCase(normalizedEmail);

    UserAccount user =
        existingUserOpt.orElseGet(
            () -> {
              UserAccount u = new UserAccount();
              u.setFullName(fullName);
              u.setEmail(normalizedEmail);
              u.setActive(true);
              u.setPasswordHash(passwordEncoder.encode("Password@123"));
              return users.save(u);
            });

    Role role =
        roles.findByRoleName(roleName)
            .orElseThrow(() -> new IllegalStateException("Role not found: " + roleName));

    // Upsert role join (avoid findById because UserRoleJoinId doesn't implement equals/hashCode)
    boolean exists = userRoleJoins.existsByIdUserIdAndIdRoleId(user.getId(), role.getId());
    if (exists) {
      return;
    }

    UserRoleJoin join = new UserRoleJoin();
    join.setUser(user);
    join.setRole(role);
    join.getId().setUserId(user.getId());
    join.getId().setRoleId(role.getId());
    userRoleJoins.save(join);
  }
}
