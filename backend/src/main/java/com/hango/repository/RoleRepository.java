package com.hango.repository;

import com.hango.domain.Role;
import com.hango.domain.UserRole;
import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;

public interface RoleRepository extends JpaRepository<Role, Long> {
  Optional<Role> findByRoleName(UserRole roleName);
}

