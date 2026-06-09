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
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Greeting
          _buildGreeting().animate().fadeIn(duration: 400.ms),
          const SizedBox(height: 28),

          // Stats Row
          Row(
                children: [
                  _statCard(
                    'Courses Enrolled',
                    '6',
                    Icons.menu_book_rounded,
                    AppColors.primary,
                  ),
                  const SizedBox(width: 20),
                  _statCard(
                    'Completed',
                    '3',
                    Icons.check_circle_rounded,
                    AppColors.success,
                  ),
                  const SizedBox(width: 20),
                  _statCard(
                    'Exams Taken',
                    '12',
                    Icons.quiz_rounded,
                    AppColors.info,
                  ),
                  const SizedBox(width: 20),
                  _statCard(
                    'Avg. Score',
                    '82%',
                    Icons.trending_up_rounded,
                    const Color(0xFF8B5CF6),
                  ),
                ],
              )
              .animate()
              .fadeIn(delay: 100.ms, duration: 400.ms)
              .slideY(begin: 0.05, end: 0),
          const SizedBox(height: 28),

          // Two-column section
          Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Continue Learning
                  Expanded(flex: 3, child: _buildContinueLearning()),
                  const SizedBox(width: 20),
                  // Upcoming & Streaks
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        _buildStudyStreak(),
                        const SizedBox(height: 20),
                        _buildUpcomingExams(),
                      ],
                    ),
                  ),
                ],
              )
              .animate()
              .fadeIn(delay: 200.ms, duration: 400.ms)
              .slideY(begin: 0.05, end: 0),
          const SizedBox(height: 28),

          // Recent Activity
          _buildRecentActivity().animate().fadeIn(
            delay: 300.ms,
            duration: 400.ms,
          ),
        ],
      ),
    );
  }

  Widget _buildGreeting() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0D9488), Color(0xFF0F766E)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Good afternoon, Hoang! 👋',
                  style: GoogleFonts.inter(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'You have 2 lessons left in "Advanced English Grammar". Keep going!',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.85),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Continue Learning →',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.school_rounded,
              size: 56,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _statCard(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: AppCard(
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 14),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w700,
                    fontSize: 22,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContinueLearning() {
    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
            child: Text(
              'Continue Learning',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          const Divider(height: 1, color: AppColors.border),
          _courseProgressItem(
            'Advanced English Grammar',
            'Section 3: Relative Clauses',
            0.72,
            AppColors.primary,
          ),
          _courseProgressItem(
            'IELTS Reading Mastery',
            'Lesson 5: Matching Headings',
            0.45,
            AppColors.info,
          ),
          _courseProgressItem(
            'Basic Vocabulary',
            'Chapter 2: Daily Life',
            0.20,
            const Color(0xFF8B5CF6),
          ),
        ],
      ),
    );
  }

  Widget _courseProgressItem(
    String title,
    String lesson,
    double progress,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.play_circle_fill_rounded, color: color, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  lesson,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: progress,
                          backgroundColor: color.withOpacity(0.1),
                          valueColor: AlwaysStoppedAnimation<Color>(color),
                          minHeight: 6,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      '${(progress * 100).toInt()}%',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: color,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStudyStreak() {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.local_fire_department_rounded,
                color: Color(0xFFF97316),
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                'Study Streak',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _dayBubble('Mo', true),
              _dayBubble('Tu', true),
              _dayBubble('We', true),
              _dayBubble('Th', true),
              _dayBubble('Fr', false),
              _dayBubble('Sa', false),
              _dayBubble('Su', false),
            ],
          ),
          const SizedBox(height: 12),
          Center(
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '4 days',
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFFF97316),
                    ),
                  ),
                  TextSpan(
                    text: '  streak 🔥',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: AppColors.textSecondary,
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

  Widget _dayBubble(String day, bool done) {
    return Column(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: done ? const Color(0xFFF97316) : AppColors.background,
            shape: BoxShape.circle,
            border: done ? null : Border.all(color: AppColors.border),
          ),
          child: Center(
            child: done
                ? const Icon(Icons.check, size: 18, color: Colors.white)
                : null,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          day,
          style: GoogleFonts.inter(
            fontSize: 11,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildUpcomingExams() {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Upcoming Exams',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 14),
          _examItem('Grammar Final Test', 'Dec 15, 2025', AppColors.error),
          const SizedBox(height: 10),
          _examItem('IELTS Practice #3', 'Dec 20, 2025', AppColors.warning),
          const SizedBox(height: 10),
          _examItem('Vocabulary Quiz', 'Dec 22, 2025', AppColors.info),
        ],
      ),
    );
  }

  Widget _examItem(String name, String date, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.06),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.15)),
      ),
      child: Row(
        children: [
          Icon(Icons.event_note_rounded, size: 18, color: color),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  date,
                  style: GoogleFonts.inter(
                    fontSize: 11,
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

  Widget _buildRecentActivity() {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recent Activity',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          _activityItem(
            Icons.check_circle,
            'Completed "Relative Clauses" lesson',
            '2 hours ago',
            AppColors.success,
          ),
          _activityItem(
            Icons.quiz_rounded,
            'Scored 85% on Vocabulary Quiz #4',
            'Yesterday',
            AppColors.info,
          ),
          _activityItem(
            Icons.play_circle_fill,
            'Started "IELTS Reading Mastery"',
            '2 days ago',
            AppColors.primary,
          ),
          _activityItem(
            Icons.emoji_events,
            'Earned "Grammar Pro" badge',
            '3 days ago',
            const Color(0xFFF97316),
          ),
        ],
      ),
    );
  }

  Widget _activityItem(IconData icon, String text, String time, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 18, color: color),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          Text(
            time,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
