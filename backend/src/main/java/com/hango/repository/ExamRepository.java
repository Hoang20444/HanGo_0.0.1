package com.hango.repository;

import com.hango.domain.Exam;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ExamRepository extends JpaRepository<Exam, Long> {
  long countByTrainerId(Long trainerId);

  long countByTrainerEmailIgnoreCase(String email);
}
