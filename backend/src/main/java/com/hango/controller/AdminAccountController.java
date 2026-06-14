package com.hango.controller;

import com.hango.domain.UserRole;
import com.hango.dto.AccountDtos.*;
import com.hango.service.AccountService;
import jakarta.validation.Valid;
import java.util.List;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/admin/accounts")
public class AdminAccountController {
  private final AccountService accountService;

  public AdminAccountController(AccountService accountService) {
    this.accountService = accountService;
  }

  @GetMapping
  List<AccountResponse> list(
      @RequestParam(required = false) UserRole role, @RequestParam(required = false) String q) {
    return accountService.list(role, q);
  }

  @PostMapping
  @ResponseStatus(HttpStatus.CREATED)
  AccountResponse create(@Valid @RequestBody UpsertAccountRequest request) {
    return accountService.create(request);
  }

  @PutMapping("/{id}")
  AccountResponse update(@PathVariable Long id, @Valid @RequestBody UpdateAccountRequest request) {
    return accountService.update(id, request);
  }

  @PatchMapping("/{id}/status")
  AccountResponse updateStatus(@PathVariable Long id, @Valid @RequestBody StatusRequest request) {
    return accountService.updateStatus(id, request);
  }

  @DeleteMapping("/{id}")
  @ResponseStatus(HttpStatus.NO_CONTENT)
  void delete(@PathVariable Long id) {
    accountService.delete(id);
  }
}
