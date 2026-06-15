package com.hango.controller;

import com.hango.dto.TrainerDashboardDtos.TrainerDashboardResponse;
import com.hango.service.TrainerDashboardService;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/trainer/dashboard")
public class TrainerDashboardController {
  private final TrainerDashboardService dashboardService;

  public TrainerDashboardController(TrainerDashboardService dashboardService) {
    this.dashboardService = dashboardService;
  }

  @GetMapping("/stats")
  public TrainerDashboardResponse getStats(
      @RequestParam(required = false) String email,
      @RequestParam(required = false) Long id) {
    return dashboardService.getStats(email, id);
  }
}
