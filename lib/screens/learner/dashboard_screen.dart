import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hango/theme/app_colors.dart';
import 'package:hango/widgets/shared_widgets.dart';

class LearnerDashboardScreen extends StatelessWidget {
  const LearnerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Hero Banner
          _buildHeroBanner().animate().fadeIn(duration: 400.ms),
          
          // Statistics
          Padding(
            padding: const EdgeInsets.fromLTRB(32, 28, 32, 0),
            child: _buildStatsRow()
                .animate()
                .fadeIn(delay: 100.ms, duration: 400.ms)
                .slideY(begin: 0.05, end: 0),
          ),
          
          // Main Content
          Padding(
            padding: const EdgeInsets.fromLTRB(32, 28, 32, 32),
            child: Column(
              children: [
                // Featured Courses Section
                _buildFeaturedCoursesSection()
                    .animate()
                    .fadeIn(delay: 200.ms, duration: 400.ms)
                    .slideY(begin: 0.05, end: 0),
                
                const SizedBox(height: 36),
                
                // Available Exams Section
                _buildExamsSection()
                    .animate()
                    .fadeIn(delay: 300.ms, duration: 400.ms)
                    .slideY(begin: 0.05, end: 0),
                
                const SizedBox(height: 36),
                
                // All Courses Grid
                _buildAllCoursesSection()
                    .animate()
                    .fadeIn(delay: 400.ms, duration: 400.ms)
                    .slideY(begin: 0.05, end: 0),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroBanner() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0D9488), Color(0xFF0F766E)],
        ),
        image: DecorationImage(
          image: const AssetImage('assets/images/banner-pattern.png'),
          opacity: 0.1,
          fit: BoxFit.cover,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome back, Hoang! 👋',
                    style: GoogleFonts.inter(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Continue your learning journey and explore new courses. You\'re making great progress!',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.9),
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        icon: const Icon(Icons.play_arrow_rounded),
                        label: Text(
                          'Continue Learning',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      OutlinedButton.icon(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Colors.white),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        icon: const Icon(Icons.explore_rounded),
                        label: Text(
                          'Explore New',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 32),
            Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Icon(
                  Icons.auto_awesome_rounded,
                  size: 80,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsRow() {
    final stats = [
      ('6', 'Courses\nEnrolled', Icons.menu_book_rounded, AppColors.primary),
      ('3', 'Completed\nCourses', Icons.check_circle_rounded, AppColors.success),
      ('12', 'Exams\nTaken', Icons.quiz_rounded, AppColors.info),
      ('82%', 'Avg\nScore', Icons.trending_up_rounded, const Color(0xFF8B5CF6)),
    ];

    return LayoutBuilder(
      builder: (ctx, constraints) {
        final isWide = constraints.maxWidth > 900;
        return Wrap(
          spacing: 16,
          runSpacing: 16,
          children: stats.map((stat) {
            return SizedBox(
              width: isWide ? (constraints.maxWidth - 48) / 4 : (constraints.maxWidth - 32) / 2,
              child: _buildStatCard(stat.$2, stat.$1, stat.$3, stat.$4),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return AppCard(
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedCoursesSection() {
    final courses = [
      {
        'title': 'Advanced English Grammar',
        'trainer': 'Pham Minh Duc',
        'progress': 0.72,
        'lessons': 24,
        'done': 17,
        'color': AppColors.primary,
      },
      {
        'title': 'IELTS Reading Mastery',
        'trainer': 'Luong Thi Thanh Thao',
        'progress': 0.45,
        'lessons': 20,
        'done': 9,
        'color': AppColors.info,
      },
      {
        'title': 'Basic Vocabulary',
        'trainer': 'Nguyen Viet Hoang',
        'progress': 0.20,
        'lessons': 30,
        'done': 6,
        'color': const Color(0xFF8B5CF6),
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Continue Learning',
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Pick up where you left off',
          style: GoogleFonts.inter(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (ctx, constraints) {
            final cols = constraints.maxWidth > 900 ? 3 : (constraints.maxWidth > 550 ? 2 : 1);
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: cols,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.3,
              ),
              itemCount: courses.length,
              itemBuilder: (_, i) => _buildCourseCard(courses[i]),
            );
          },
        ),
      ],
    );
  }

  Widget _buildCourseCard(Map<String, dynamic> course) {
    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 6,
            decoration: BoxDecoration(
              color: course['color'],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course['title'],
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'by ${course['trainer']}',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const Spacer(),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: course['progress'],
                      backgroundColor: course['color'].withOpacity(0.1),
                      valueColor: AlwaysStoppedAnimation<Color>(course['color']),
                      minHeight: 6,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${course['done']}/${course['lessons']} lessons',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      Text(
                        '${(course['progress'] * 100).toInt()}%',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: course['color'],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExamsSection() {
    final exams = [
      {
        'title': 'Grammar Final Test',
        'date': 'Dec 15, 2025',
        'questions': 50,
        'duration': '90 mins',
        'color': AppColors.error,
      },
      {
        'title': 'IELTS Practice #3',
        'date': 'Dec 20, 2025',
        'questions': 40,
        'duration': '120 mins',
        'color': AppColors.warning,
      },
      {
        'title': 'Vocabulary Quiz',
        'date': 'Dec 22, 2025',
        'questions': 30,
        'duration': '45 mins',
        'color': AppColors.info,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Upcoming Exams',
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Prepare for and take your exams',
          style: GoogleFonts.inter(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (ctx, constraints) {
            final cols = constraints.maxWidth > 900 ? 3 : (constraints.maxWidth > 550 ? 2 : 1);
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: cols,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.2,
              ),
              itemCount: exams.length,
              itemBuilder: (_, i) => _buildExamCard(exams[i]),
            );
          },
        ),
      ],
    );
  }

  Widget _buildExamCard(Map<String, dynamic> exam) {
    return AppCard(
      padding: EdgeInsets.zero,
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(color: exam['color'], width: 4),
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.quiz_rounded,
                    color: exam['color'],
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      exam['title'],
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                exam['date'],
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: exam['color'],
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _examInfoBadge(
                    '${exam['questions']}',
                    'Questions',
                    Icons.format_list_numbered_rounded,
                  ),
                  _examInfoBadge(
                    exam['duration'],
                    'Duration',
                    Icons.timer_rounded,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 36,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: exam['color'].withOpacity(0.1),
                    foregroundColor: exam['color'],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Take Exam',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _examInfoBadge(String value, String label, IconData icon) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: AppColors.textSecondary),
        const SizedBox(height: 2),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 9,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildAllCoursesSection() {
    final allCourses = [
      {
        'title': 'Advanced English Grammar',
        'trainer': 'Pham Minh Duc',
        'level': 'Advanced',
        'students': 1250,
        'rating': 4.8,
        'color': AppColors.primary,
        'enrolled': true,
      },
      {
        'title': 'IELTS Reading Mastery',
        'trainer': 'Luong Thi Thanh Thao',
        'level': 'Intermediate',
        'students': 890,
        'rating': 4.7,
        'color': AppColors.info,
        'enrolled': true,
      },
      {
        'title': 'Business English',
        'trainer': 'Pham Minh Duc',
        'level': 'Advanced',
        'students': 650,
        'rating': 4.9,
        'color': const Color(0xFFEC4899),
        'enrolled': false,
      },
      {
        'title': 'Conversational English',
        'trainer': 'Nguyen Viet Hoang',
        'level': 'Beginner',
        'students': 2100,
        'rating': 4.6,
        'color': AppColors.success,
        'enrolled': false,
      },
      {
        'title': 'English Pronunciation',
        'trainer': 'Pham Minh Duc',
        'level': 'Beginner',
        'students': 1560,
        'rating': 4.8,
        'color': const Color(0xFF8B5CF6),
        'enrolled': false,
      },
      {
        'title': 'Writing Skills - Part 1',
        'trainer': 'Luong Thi Thanh Thao',
        'level': 'Intermediate',
        'students': 920,
        'rating': 4.7,
        'color': const Color(0xFFF97316),
        'enrolled': false,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Browse All Courses',
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Explore and enroll in available courses',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.primarySurface,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'View All →',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (ctx, constraints) {
            final cols = constraints.maxWidth > 900 ? 3 : (constraints.maxWidth > 550 ? 2 : 1);
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: cols,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.35,
              ),
              itemCount: allCourses.length,
              itemBuilder: (_, i) => _buildBrowseCourseCard(allCourses[i]),
            );
          },
        ),
      ],
    );
  }

  Widget _buildBrowseCourseCard(Map<String, dynamic> course) {
    final bool enrolled = course['enrolled'] ?? false;
    
    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 8,
            decoration: BoxDecoration(
              color: course['color'],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          course['title'],
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (enrolled)
                        const Icon(
                          Icons.verified_rounded,
                          color: AppColors.success,
                          size: 18,
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'by ${course['trainer']}',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.star_rounded,
                                  size: 14,
                                  color: Color(0xFFF97316),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${course['rating']}',
                                  style: GoogleFonts.inter(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '(${course['students']})',
                                  style: GoogleFonts.inter(
                                    fontSize: 10,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: course['color'].withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                course['level'],
                                style: GoogleFonts.inter(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                  color: course['color'],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 32,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: enrolled ? AppColors.success.withOpacity(0.1) : course['color'],
                        foregroundColor: enrolled ? AppColors.success : Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      child: Text(
                        enrolled ? 'Enrolled' : 'Enroll Now',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
