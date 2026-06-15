import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'learner_ui.dart';
import '../../theme/app_colors.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = [
      {
        'name': 'Grammar',
        'icon': Icons.spellcheck,
        'count': 12,
        'color': AppColors.primary,
      },
      {
        'name': 'Reading',
        'icon': Icons.auto_stories,
        'count': 8,
        'color': AppColors.info,
      },
      {
        'name': 'Writing',
        'icon': Icons.edit_note,
        'count': 6,
        'color': const Color(0xFFEC4899),
      },
      {
        'name': 'Vocabulary',
        'icon': Icons.abc,
        'count': 15,
        'color': const Color(0xFF6366F1),
      },
      {
        'name': 'Listening',
        'icon': Icons.headphones,
        'count': 5,
        'color': const Color(0xFFF97316),
      },
      {
        'name': 'Speaking',
        'icon': Icons.mic,
        'count': 4,
        'color': AppColors.success,
      },
    ];

    final recommended = [
      {
        'title': 'TOEIC Preparation',
        'trainer': 'Nguyen Viet Hoang',
        'students': 234,
        'rating': 4.8,
        'cat': 'Grammar',
        'color': AppColors.primary,
      },
      {
        'title': 'Academic Writing',
        'trainer': 'Luong Thi Thanh Thao',
        'students': 156,
        'rating': 4.6,
        'cat': 'Writing',
        'color': const Color(0xFFEC4899),
      },
      {
        'title': 'Listening for IELTS',
        'trainer': 'Pham Minh Duc',
        'students': 189,
        'rating': 4.7,
        'cat': 'Listening',
        'color': const Color(0xFFF97316),
      },
      {
        'title': 'Business English',
        'trainer': 'Nguyen Thanh Tung',
        'students': 98,
        'rating': 4.5,
        'cat': 'Vocabulary',
        'color': const Color(0xFF6366F1),
      },
    ];

    return LearnerPageWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const LearnerSectionHeader(
            title: 'Explore Courses',
            subtitle: 'Discover new courses to boost your English skills',
          ).animate().fadeIn(duration: 400.ms),
          const SizedBox(height: 20),
          Container(
            decoration: LearnerUi.cardDecoration(elevated: false),
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search courses, topics, trainers...',
                hintStyle: GoogleFonts.inter(
                  color: AppColors.textMuted,
                  fontSize: 14,
                ),
                prefixIcon: const Icon(
                  Icons.search_rounded,
                  color: AppColors.textSecondary,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ).animate().fadeIn(delay: 50.ms),
          const SizedBox(height: LearnerUi.sectionGap),
          Text('Categories', style: LearnerUi.sectionTitleStyle),
          const SizedBox(height: 14),
          LayoutBuilder(
            builder: (context, constraints) {
              final cols = learnerGridColumns(
                constraints.maxWidth,
                wide: 3,
                medium: 2,
              );
              final gap = LearnerUi.cardSpacing.toDouble();
              final itemWidth =
                  (constraints.maxWidth - gap * (cols - 1)) / cols;

              return Wrap(
                spacing: gap,
                runSpacing: gap,
                children: categories.asMap().entries.map((e) {
                  final c = e.value;
                  return SizedBox(
                    width: itemWidth,
                    child:
                        _categoryCard(
                          c['name'] as String,
                          c['icon'] as IconData,
                          c['count'] as int,
                          c['color'] as Color,
                        ).animate().fadeIn(
                          delay: (e.key * 50).ms,
                          duration: 300.ms,
                        ),
                  );
                }).toList(),
              );
            },
          ),
          const SizedBox(height: LearnerUi.sectionGap),
          const LearnerSectionHeader(
            title: 'Recommended for You',
            subtitle: 'Curated based on your learning progress',
          ),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (ctx, c) {
              final cols = learnerGridColumns(c.maxWidth, wide: 2, medium: 2);
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: cols,
                  crossAxisSpacing: LearnerUi.cardSpacing,
                  mainAxisSpacing: LearnerUi.cardSpacing,
                  childAspectRatio: cols == 1 ? 1.25 : 1.35,
                ),
                itemCount: recommended.length,
                itemBuilder: (_, i) => _recommendedCard(recommended[i])
                    .animate()
                    .fadeIn(delay: (i * 80).ms, duration: 350.ms)
                    .slideY(begin: 0.04, end: 0),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _categoryCard(String name, IconData icon, int count, Color color) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(LearnerUi.cardRadius),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: LearnerUi.cardDecoration(elevated: false),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(LearnerUi.cardRadius),
                ),
                child: Icon(icon, size: 20, color: color),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      '$count courses',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 14,
                color: AppColors.textMuted,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _recommendedCard(Map<String, dynamic> r) {
    final Color color = r['color'] as Color;

    return Container(
      decoration: LearnerUi.cardDecoration(),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 56,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  color.withValues(alpha: 0.85),
                  color.withValues(alpha: 0.55),
                ],
              ),
            ),
            child: Row(
              children: [
                LearnerChip(label: r['cat'] as String, color: Colors.white),
                const Spacer(),
                Row(
                  children: [
                    const Icon(
                      Icons.star_rounded,
                      size: 14,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${r['rating']}',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    r['title'] as String,
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'by ${r['trainer']}',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Icon(
                        Icons.people_outline_rounded,
                        size: 15,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          '${r['students']} students',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 10),
                      LearnerPrimaryButton(
                        label: 'Enroll',
                        icon: Icons.add_rounded,
                        onPressed: () {},
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
}
