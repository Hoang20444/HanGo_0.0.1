package com.hango.service;

import com.hango.domain.Course;
import com.hango.domain.UserAccount;
import com.hango.dto.TrainerDashboardDtos.*;
import com.hango.exception.ApiException;
import com.hango.repository.CourseRepository;
import com.hango.repository.ExamRepository;
import com.hango.repository.UserAccountRepository;
import java.time.LocalDate;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.util.List;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class TrainerDashboardService {
  private final CourseRepository courseRepository;
  private final ExamRepository examRepository;
  private final UserAccountRepository userRepository;

  public TrainerDashboardService(
      CourseRepository courseRepository,
      ExamRepository examRepository,
      UserAccountRepository userRepository) {
    this.courseRepository = courseRepository;
    this.examRepository = examRepository;
    this.userRepository = userRepository;
  }

  @Transactional(readOnly = true)
  public TrainerDashboardResponse getStats(String email, Long id) {
    UserAccount trainer = null;
    if (email != null && !email.trim().isEmpty()) {
      trainer = userRepository.findByEmailIgnoreCase(email.trim())
          .orElseThrow(() -> new ApiException(HttpStatus.NOT_FOUND, "Trainer not found for email: " + email));
    } else if (id != null) {
      trainer = userRepository.findById(id)
          .orElseThrow(() -> new ApiException(HttpStatus.NOT_FOUND, "Trainer not found for id: " + id));
    } else {
      trainer = userRepository.findByEmailIgnoreCase("trainer@hango.local")
          .orElseThrow(() -> new ApiException(HttpStatus.BAD_REQUEST, "No trainer email or id provided, and default trainer was not found"));
    }

    long coursesCount = courseRepository.countByTrainerId(trainer.getId());
    long learnersCount = courseRepository.sumLearnersCountByTrainerId(trainer.getId());
    long examsCount = examRepository.countByTrainerId(trainer.getId());

    List<Course> courses = courseRepository.findByTrainerIdOrderByCreatedAtDesc(trainer.getId());

    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
    List<CourseDto> courseDtos = courses.stream()
        .map(c -> new CourseDto(
            c.getId(),
            c.getTitle(),
            c.getCategory(),
            c.getLevel(),
            c.getStatus(),
            c.getLessonsCount(),
            c.getLearnersCount(),
            c.getCreatedAt() != null 
                ? LocalDate.ofInstant(c.getCreatedAt(), ZoneId.systemDefault()).format(formatter)
                : LocalDate.now().format(formatter)
        ))
        .toList();

    return new TrainerDashboardResponse(coursesCount, learnersCount, examsCount, courseDtos);
  }
}
