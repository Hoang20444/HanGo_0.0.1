import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hango/screens/learner/learner_ui.dart';
import 'package:hango/theme/app_colors.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  final List<Map<String, dynamic>> _badges = const [
    {
      'title': 'Grammar Pro',
      'description': 'Scored 100% in 5 Grammar tests',
      'icon': Icons.verified_user_rounded,
      'color': Color(0xFF3B82F6),
      'unlocked': true,
    },
    {
      'title': 'Vocabulary Master',
      'description': 'Learn over 500 vocabulary items',
      'icon': Icons.translate_rounded,
      'color': Color(0xFF6366F1),
      'unlocked': true,
    },
    {
      'title': 'Early Bird',
      'description': 'Study before 7:00 AM on 3 consecutive days',
      'icon': Icons.wb_sunny_rounded,
      'color': Color(0xFFF59E0B),
      'unlocked': true,
    },
    {
      'title': 'Streak Champion',
      'description': 'Keep a 10-day streak going',
      'icon': Icons.local_fire_department_rounded,
      'color': Color(0xFFEF4444),
      'unlocked': false,
    },
    {
      'title': 'Mock Expert',
      'description': 'Complete 5 high school national graduation mock tests',
      'icon': Icons.assignment_rounded,
      'color': Color(0xFF10B981),
      'unlocked': false,
    },
  ];

  final List<Map<String, dynamic>> _skills = const [
    {'name': 'Grammar', 'score': 0.85, 'color': Color(0xFF3B82F6)},
    {'name': 'Vocabulary', 'score': 0.72, 'color': Color(0xFF6366F1)},
    {
      'name': 'Reading Comprehension',
      'score': 0.90,
      'color': Color(0xFF10B981),
    },
    {'name': 'Listening', 'score': 0.65, 'color': Color(0xFFF59E0B)},
  ];

  @override
  Widget build(BuildContext context) {
    return LearnerPageWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const LearnerSectionHeader(
            title: 'My Progress',
            subtitle: 'Analyze your current skills and achievements',
          ).animate().fadeIn(duration: 400.ms),
          const SizedBox(height: LearnerUi.sectionGap),
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 720;
              final skillsCard = _buildSkillsCard();
              final statsColumn = _buildStatsColumn();

              if (isWide) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 3, child: skillsCard),
                    const SizedBox(width: 20),
                    Expanded(flex: 2, child: statsColumn),
                  ],
                );
              }
              return Column(
                children: [skillsCard, const SizedBox(height: 16), statsColumn],
              );
            },
          ).animate().fadeIn(delay: 80.ms, duration: 400.ms),
          const SizedBox(height: LearnerUi.sectionGap),
          Text(
            'Badge Showcase',
            style: LearnerUi.sectionTitleStyle,
          ).animate().fadeIn(delay: 140.ms),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, constraints) {
              final cols = learnerGridColumns(
                constraints.maxWidth,
                wide: 5,
                medium: 3,
                narrow: 2,
              );
              final gap = LearnerUi.cardSpacing.toDouble();
              final itemWidth =
                  (constraints.maxWidth - gap * (cols - 1)) / cols;

              return Wrap(
                spacing: gap,
                runSpacing: gap,
                children: _badges.asMap().entries.map((e) {
                  return SizedBox(
                    width: itemWidth,
                    child: _buildBadgeCard(e.value).animate().fadeIn(
                      delay: (160 + e.key * 50).ms,
                      duration: 350.ms,
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSkillsCard() {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: LearnerUi.cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Skill Breakdown', style: LearnerUi.sectionTitleStyle),
          const SizedBox(height: 22),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _skills.length,
            separatorBuilder: (_, _) => const SizedBox(height: 18),
            itemBuilder: (context, idx) => _buildSkillBar(_skills[idx]),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsColumn() {
    return Column(
      children: [
        _buildMiniStat(
          'Total Practice Time',
          '32.5 hrs',
          Icons.timer_rounded,
          AppColors.primary,
        ),
        const SizedBox(height: 14),
        _buildMiniStat(
          'Lessons Completed',
          '42 lessons',
          Icons.book_rounded,
          AppColors.success,
        ),
        const SizedBox(height: 14),
        _buildMiniStat(
          'Current Streak',
          '7 days',
          Icons.local_fire_department_rounded,
          const Color(0xFFF59E0B),
        ),
      ],
    );
  }

  Widget _buildSkillBar(Map<String, dynamic> skill) {
    final double score = skill['score'] as double;
    final Color color = skill['color'] as Color;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              skill['name'] as String,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              '${(score * 100).toInt()}%',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: score,
            backgroundColor: color.withValues(alpha: 0.1),
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 8,
          ),
        ),
      ],
    );
  }

  Widget _buildMiniStat(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: LearnerUi.cardDecoration(elevated: false),
      child: Row(
        children: [
          LearnerSurfaceIcon(icon: icon, color: color),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadgeCard(Map<String, dynamic> badge) {
    final unlocked = badge['unlocked'] as bool;
    final Color color = badge['color'] as Color;

    return Opacity(
      opacity: unlocked ? 1.0 : 0.4,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: LearnerUi.cardDecoration(elevated: unlocked),
        child: Column(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(badge['icon'] as IconData, color: color, size: 26),
            ),
            const SizedBox(height: 12),
            Text(
              badge['title'] as String,
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w700,
                fontSize: 13,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              badge['description'] as String,
              style: GoogleFonts.inter(
                fontSize: 11,
                color: AppColors.textSecondary,
                height: 1.35,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
