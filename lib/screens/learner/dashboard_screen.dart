import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hango/screens/learner/learner_ui.dart';
import 'package:hango/theme/app_colors.dart';

class LearnerDashboardScreen extends StatelessWidget {
  const LearnerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          _buildHeroBanner(),
          Transform.translate(
            offset: const Offset(0, -20),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: LearnerUi.maxContentWidth,
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.sizeOf(context).width < 560
                        ? LearnerUi.compactPagePadding
                        : LearnerUi.pagePadding,
                  ),
                  child: _buildStatsRow()
                      .animate()
                      .fadeIn(delay: 80.ms, duration: 400.ms)
                      .slideY(begin: 0.06, end: 0),
                ),
              ),
            ),
          ),
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: LearnerUi.maxContentWidth,
              ),
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  MediaQuery.sizeOf(context).width < 560
                      ? LearnerUi.compactPagePadding
                      : LearnerUi.pagePadding,
                  0,
                  MediaQuery.sizeOf(context).width < 560
                      ? LearnerUi.compactPagePadding
                      : LearnerUi.pagePadding,
                  LearnerUi.pagePadding,
                ),
                child: Column(
                  children: [
                    _buildMainContent()
                        .animate()
                        .fadeIn(delay: 160.ms, duration: 400.ms)
                        .slideY(begin: 0.04, end: 0),
                    const SizedBox(height: LearnerUi.sectionGap),
                    _buildAllCoursesSection()
                        .animate()
                        .fadeIn(delay: 240.ms, duration: 400.ms)
                        .slideY(begin: 0.04, end: 0),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroBanner() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(gradient: LearnerUi.heroGradient),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: LearnerUi.maxContentWidth,
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 32, 24, 44),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isCompact = constraints.maxWidth < 720;
                if (isCompact) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _heroText(),
                      const SizedBox(height: 20),
                      _heroIllustration(compact: true),
                    ],
                  );
                }
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(child: _heroText()),
                    const SizedBox(width: 32),
                    _heroIllustration(compact: false),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    ).animate().fadeIn(duration: 400.ms);
  }

  Widget _heroText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.18),
            borderRadius: BorderRadius.circular(LearnerUi.cardRadius),
          ),
          child: Text(
            'Welcome back, Hoang',
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.white.withValues(alpha: 0.95),
            ),
          ),
        ),
        const SizedBox(height: 14),
        Text(
          'Continue your\nlearning journey',
          style: GoogleFonts.inter(
            fontSize: 30,
            fontWeight: FontWeight.w800,
            color: Colors.white,
            height: 1.15,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'You\'re making great progress. Pick up where you left off or explore something new.',
          style: GoogleFonts.inter(
            fontSize: 15,
            color: Colors.white.withValues(alpha: 0.88),
            height: 1.55,
          ),
        ),
        const SizedBox(height: 22),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            _heroButton(
              label: 'Continue Learning',
              icon: Icons.play_arrow_rounded,
              filled: true,
            ),
            _heroButton(
              label: 'Explore Courses',
              icon: Icons.explore_rounded,
              filled: false,
            ),
          ],
        ),
      ],
    );
  }

  Widget _heroButton({
    required String label,
    required IconData icon,
    required bool filled,
  }) {
    return Material(
      color: filled ? Colors.white : Colors.white.withValues(alpha: 0.12),
      borderRadius: BorderRadius.circular(LearnerUi.cardRadius),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(LearnerUi.cardRadius),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 18,
                color: filled ? AppColors.primary : Colors.white,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: filled ? AppColors.primary : Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _heroIllustration({required bool compact}) {
    return Container(
      width: compact ? double.infinity : 240,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(LearnerUi.cardRadius),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(LearnerUi.cardRadius),
                ),
                child: const Icon(
                  Icons.auto_stories_rounded,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Today plan',
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _heroMiniRow(Icons.play_circle_outline_rounded, '2 lessons ready'),
          const SizedBox(height: 10),
          _heroMiniRow(Icons.timer_outlined, '25 min focus block'),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: 0.72,
              minHeight: 6,
              backgroundColor: Colors.white.withValues(alpha: 0.18),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _heroMiniRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.white.withValues(alpha: 0.88)),
        const SizedBox(width: 8),
        Text(
          text,
          style: GoogleFonts.inter(
            fontSize: 12,
            color: Colors.white.withValues(alpha: 0.88),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildStatsRow() {
    final stats = [
      ('6', 'Courses\nEnrolled', Icons.menu_book_rounded, AppColors.primary),
      (
        '3',
        'Completed\nCourses',
        Icons.check_circle_rounded,
        AppColors.success,
      ),
      ('12', 'Exams\nTaken', Icons.quiz_rounded, AppColors.info),
      (
        '82%',
        'Average\nScore',
        Icons.trending_up_rounded,
        const Color(0xFF6366F1),
      ),
    ];

    return LayoutBuilder(
      builder: (ctx, constraints) {
        final cols = learnerGridColumns(
          constraints.maxWidth,
          wide: 4,
          medium: 2,
        );
        final gap = LearnerUi.cardSpacing.toDouble();
        final itemWidth = (constraints.maxWidth - gap * (cols - 1)) / cols;

        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: stats.map((stat) {
            return SizedBox(
              width: itemWidth,
              child: LearnerStatCard(
                value: stat.$1,
                label: stat.$2,
                icon: stat.$3,
                color: stat.$4,
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildMainContent() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 860;
        if (isWide) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 3, child: _buildContinueLearningSection()),
              const SizedBox(width: 20),
              Expanded(flex: 2, child: _buildExamsSection()),
            ],
          );
        }
        return Column(
          children: [
            _buildContinueLearningSection(),
            const SizedBox(height: LearnerUi.sectionGap),
            _buildExamsSection(),
          ],
        );
      },
    );
  }

  Widget _buildContinueLearningSection() {
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
        'color': const Color(0xFF6366F1),
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const LearnerSectionHeader(
          title: 'Continue Learning',
          subtitle: 'Pick up where you left off',
          action: LearnerTextLink(label: 'View all >'),
        ),
        const SizedBox(height: 16),
        ...courses.map(
          (course) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _buildCourseProgressCard(course),
          ),
        ),
      ],
    );
  }

  Widget _buildCourseProgressCard(Map<String, dynamic> course) {
    final color = course['color'] as Color;
    final progress = course['progress'] as double;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(LearnerUi.cardRadius),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: LearnerUi.cardDecoration(),
          child: Row(
            children: [
              LearnerSurfaceIcon(
                icon: Icons.play_lesson_rounded,
                color: color,
                size: 48,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      course['title'] as String,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'by ${course['trainer']}',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: progress,
                        backgroundColor: color.withValues(alpha: 0.12),
                        valueColor: AlwaysStoppedAnimation<Color>(color),
                        minHeight: 6,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${course['done']}/${course['lessons']} lessons',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        Text(
                          '${(progress * 100).toInt()}%',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: color,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.chevron_right_rounded,
                color: AppColors.textMuted,
                size: 22,
              ),
            ],
          ),
        ),
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
        const LearnerSectionHeader(
          title: 'Upcoming Exams',
          subtitle: 'Prepare and take your assessments',
          action: LearnerTextLink(label: 'See all >'),
        ),
        const SizedBox(height: 16),
        ...exams.map(
          (exam) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _buildExamCard(exam),
          ),
        ),
      ],
    );
  }

  Widget _buildExamCard(Map<String, dynamic> exam) {
    final color = exam['color'] as Color;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: LearnerUi.cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.quiz_rounded, color: color, size: 18),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  exam['title'] as String,
                  style: GoogleFonts.inter(
                    fontSize: 13,
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
          Row(
            children: [
              Icon(Icons.calendar_today_rounded, size: 13, color: color),
              const SizedBox(width: 5),
              Text(
                exam['date'] as String,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _examMeta('${exam['questions']}', 'Questions'),
              const SizedBox(width: 16),
              _examMeta(exam['duration'] as String, 'Duration'),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            height: 38,
            child: TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                backgroundColor: color.withValues(alpha: 0.08),
                foregroundColor: color,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(LearnerUi.cardRadius),
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
    );
  }

  Widget _examMeta(String value, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 10,
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
        'color': const Color(0xFF6366F1),
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
        const LearnerSectionHeader(
          title: 'Browse All Courses',
          subtitle: 'Explore and enroll in available courses',
          action: LearnerTextLink(label: 'View all >'),
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (ctx, constraints) {
            final cols = learnerGridColumns(constraints.maxWidth);
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: cols,
                crossAxisSpacing: LearnerUi.cardSpacing,
                mainAxisSpacing: LearnerUi.cardSpacing,
                childAspectRatio: cols == 1 ? 1.35 : 1.15,
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
    final color = course['color'] as Color;
    final enrolled = course['enrolled'] as bool;

    return Container(
      decoration: LearnerUi.cardDecoration(),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 72,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  color.withValues(alpha: 0.85),
                  color.withValues(alpha: 0.55),
                ],
              ),
            ),
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    LearnerChip(
                      label: course['level'] as String,
                      color: Colors.white,
                    ),
                    const Spacer(),
                    if (enrolled)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(
                            LearnerUi.cardRadius,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.check_circle_rounded,
                              size: 12,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Enrolled',
                              style: GoogleFonts.inter(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                const Spacer(),
                Text(
                  course['title'] as String,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'by ${course['trainer']}',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        size: 15,
                        color: Color(0xFFF59E0B),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${course['rating']}',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '(${course['students']})',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 36,
                    child: TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        backgroundColor: enrolled
                            ? AppColors.success.withValues(alpha: 0.1)
                            : color,
                        foregroundColor: enrolled
                            ? AppColors.success
                            : Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            LearnerUi.cardRadius,
                          ),
                        ),
                      ),
                      child: Text(
                        enrolled ? 'Continue' : 'Enroll Now',
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
        ],
      ),
    );
  }
}
