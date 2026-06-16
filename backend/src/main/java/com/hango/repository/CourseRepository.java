package com.hango.repository;

import com.hango.domain.Course;
import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface CourseRepository extends JpaRepository<Course, Long> {
  long countByTrainerId(Long trainerId);

  long countByTrainerEmailIgnoreCase(String email);

  List<Course> findByTrainerIdOrderByCreatedAtDesc(Long trainerId);

  List<Course> findByTrainerEmailIgnoreCaseOrderByCreatedAtDesc(String email);

  @Query("SELECT COALESCE(SUM(c.learnersCount), 0) FROM Course c WHERE c.trainer.id = :trainerId")
  long sumLearnersCountByTrainerId(@Param("trainerId") Long trainerId);

  @Query("SELECT COALESCE(SUM(c.learnersCount), 0) FROM Course c WHERE LOWER(c.trainer.email) = LOWER(:email)")
  long sumLearnersCountByTrainerEmail(@Param("email") String email);
}
