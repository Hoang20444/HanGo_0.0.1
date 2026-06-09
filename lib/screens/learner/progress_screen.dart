import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hango/theme/app_colors.dart';
import 'package:hango/widgets/shared_widgets.dart';

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
      'color': Color(0xFF8B5CF6),
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
    {'name': 'Vocabulary', 'score': 0.72, 'color': Color(0xFF8B5CF6)},
    {'name': 'Reading Comprehension', 'score': 0.90, 'color': Color(0xFF10B981)},
    {'name': 'Listening', 'score': 0.65, 'color': Color(0xFFF59E0B)},
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const PageHeader(
            title: 'My Progress',
            subtitle: 'Analyze your current skills and achievements',
          ).animate().fadeIn(duration: 400.ms),
          const SizedBox(height: 32),
          // Skill breakdown
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Skill Breakdown',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 24),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _skills.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 20),
                        itemBuilder: (context, idx) {
                          final sk = _skills[idx];
                          return _buildSkillBar(sk);
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 24),
              // Mini stats
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    _buildMiniStat('Total Practice Time', '32.5 hrs', Icons.timer_rounded, AppColors.primary),
                    const SizedBox(height: 20),
                    _buildMiniStat('Lessons Completed', '42 lessons', Icons.book_rounded, AppColors.success),
                  ],
                ),
              ),
            ],
          ).animate().fadeIn(delay: 100.ms, duration: 400.ms),
          const SizedBox(height: 40),
          // Badge Showcase
          Text(
            'Badge Showcase',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ).animate().fadeIn(delay: 150.ms),
          const SizedBox(height: 20),
          LayoutBuilder(
            builder: (context, constraints) {
              final cols = constraints.maxWidth > 900 ? 5 : (constraints.maxWidth > 600 ? 3 : 2);
              return Wrap(
                spacing: 20,
                runSpacing: 20,
                children: _badges.asMap().entries.map((e) {
                  final badge = e.value;
                  return SizedBox(
                    width: (constraints.maxWidth - 20 * (cols - 1)) / cols,
                    child: _buildBadgeCard(badge),
                  );
                }).toList(),
              );
            },
          ).animate().fadeIn(delay: 200.ms, duration: 400.ms),
        ],
      ),
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
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: score,
            backgroundColor: color.withOpacity(0.1),
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 10,
          ),
        ),
      ],
    );
  }

  Widget _buildMiniStat(String label, String value, IconData icon, Color color) {
    return AppCard(
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBadgeCard(Map<String, dynamic> badge) {
    final unlocked = badge['unlocked'] as bool;
    final Color color = badge['color'] as Color;

    return Opacity(
      opacity: unlocked ? 1.0 : 0.45,
      child: AppCard(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                badge['icon'] as IconData,
                color: color,
                size: 32,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              badge['title'] as String,
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w700,
                fontSize: 14,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              badge['description'] as String,
              style: GoogleFonts.inter(
                fontSize: 11,
                color: AppColors.textSecondary,
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
