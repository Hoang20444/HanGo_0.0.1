package com.hango.domain;

import jakarta.persistence.*;
import java.time.Instant;

@Entity
@Table(name = "courses")
public class Course {
  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  private Long id;

  @Column(nullable = false, length = 255)
  private String title;

  @Column(nullable = false, length = 100)
  private String category;

  @Column(nullable = false, length = 50)
  private String level;

  @Column(nullable = false, length = 50)
  private String status;

  @Column(name = "lessons_count", nullable = false)
  private int lessonsCount = 0;

  @Column(name = "learners_count", nullable = false)
  private int learnersCount = 0;

  @ManyToOne(fetch = FetchType.LAZY)
  @JoinColumn(name = "trainer_id", nullable = false)
  private UserAccount trainer;

  @Column(name = "created_at", nullable = false, updatable = false)
  private Instant createdAt = Instant.now();

  public Long getId() {
    return id;
  }

  public void setId(Long id) {
    this.id = id;
  }

  public String getTitle() {
    return title;
  }

  public void setTitle(String title) {
    this.title = title;
  }

  public String getCategory() {
    return category;
  }

  public void setCategory(String category) {
    this.category = category;
  }

  public String getLevel() {
    return level;
  }

  public void setLevel(String level) {
    this.level = level;
  }

  public String getStatus() {
    return status;
  }

  public void setStatus(String status) {
    this.status = status;
  }

  public int getLessonsCount() {
    return lessonsCount;
  }

  public void setLessonsCount(int lessonsCount) {
    this.lessonsCount = lessonsCount;
  }

  public int getLearnersCount() {
    return learnersCount;
  }

  public void setLearnersCount(int learnersCount) {
    this.learnersCount = learnersCount;
  }

  public UserAccount getTrainer() {
    return trainer;
  }

  public void setTrainer(UserAccount trainer) {
    this.trainer = trainer;
  }

  public Instant getCreatedAt() {
    return createdAt;
  }

  public void setCreatedAt(Instant createdAt) {
    this.createdAt = createdAt;
  }
}
