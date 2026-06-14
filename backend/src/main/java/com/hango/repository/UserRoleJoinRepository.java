  package com.hango.repository;

import com.hango.domain.UserRole;
import com.hango.domain.UserRoleJoin;
import com.hango.domain.UserRoleJoin.UserRoleJoinId;
import java.util.List;
import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;

public interface UserRoleJoinRepository extends JpaRepository<UserRoleJoin, UserRoleJoinId> {
  Optional<UserRoleJoin> findTopByIdUserId(Long userId);

  List<UserRoleJoin> findByRole_RoleName(UserRole role);

  boolean existsByIdUserIdAndIdRoleId(Long userId, Long roleId);
}

