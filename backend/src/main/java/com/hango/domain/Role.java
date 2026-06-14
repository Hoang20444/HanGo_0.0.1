package com.hango.domain;

import jakarta.persistence.*;
import java.util.HashSet;
import java.util.Set;

@Entity
@Table(name = "roles", indexes = @Index(name = "idx_roles_name", columnList = "role_name", unique = true))
public class Role {
  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  private Long id;

  @Enumerated(EnumType.STRING)
  @Column(name = "role_name", nullable = false, unique = true, length = 50)
  private UserRole roleName;

  public Long getId() {
    return id;
  }

  public UserRole getRoleName() {
    return roleName;
  }

  public void setRoleName(UserRole roleName) {
    this.roleName = roleName;
  }
}

