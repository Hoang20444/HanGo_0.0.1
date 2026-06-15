package com.hango.dto;

import java.util.List;

public final class TrainerDashboardDtos {
  private TrainerDashboardDtos() {}

  public record CourseDto(
      Long id,
      String title,
      String category,
      String level,
      String status,
      int lessonsCount,
      int learnersCount,
      String createdDate
  ) {}

  public record TrainerDashboardResponse(
      long coursesCount,
      long learnersCount,
      long examsCount,
      List<CourseDto> courses
  ) {}
}
