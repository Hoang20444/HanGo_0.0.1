import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hango/screens/learner/learner_ui.dart';
import 'package:hango/theme/app_colors.dart';

class MyCoursesScreen extends StatefulWidget {
  const MyCoursesScreen({super.key});
  @override
  State<MyCoursesScreen> createState() => _MyCoursesScreenState();
}

class _MyCoursesScreenState extends State<MyCoursesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, dynamic>> _courses = [
    {
      'title': 'Advanced English Grammar',
      'trainer': 'Pham Minh Duc',
      'progress': 0.72,
      'lessons': 24,
      'done': 17,
      'cat': 'Grammar',
      'level': 'Advanced',
      'color': AppColors.primary,
    },
    {
      'title': 'IELTS Reading Mastery',
      'trainer': 'Luong Thi Thanh Thao',
      'progress': 0.45,
      'lessons': 20,
      'done': 9,
      'cat': 'Reading',
      'level': 'Intermediate',
      'color': AppColors.info,
    },
    {
      'title': 'Basic Vocabulary',
      'trainer': 'Nguyen Viet Hoang',
      'progress': 0.20,
      'lessons': 30,
      'done': 6,
      'cat': 'Vocabulary',
      'level': 'Beginner',
      'color': const Color(0xFF6366F1),
    },
    {
      'title': 'English Pronunciation',
      'trainer': 'Pham Minh Duc',
      'progress': 1.0,
      'lessons': 15,
      'done': 15,
      'cat': 'Speaking',
      'level': 'Beginner',
      'color': AppColors.success,
    },
    {
      'title': 'Writing Skills - Part 1',
      'trainer': 'Luong Thi Thanh Thao',
      'progress': 1.0,
      'lessons': 18,
      'done': 18,
      'cat': 'Writing',
      'level': 'Intermediate',
      'color': const Color(0xFFEC4899),
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> _filter(String f) {
    if (f == 'All') return _courses;
    if (f == 'IP') return _courses.where((c) => c['progress'] < 1.0).toList();
    return _courses.where((c) => c['progress'] >= 1.0).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(LearnerUi.pagePadding),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: LearnerUi.maxContentWidth,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const LearnerSectionHeader(
                title: 'My Courses',
                subtitle: 'Track your enrolled courses and continue learning',
              ).animate().fadeIn(duration: 400.ms),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(LearnerUi.cardRadius),
                  border: Border.all(color: AppColors.border),
                ),
                padding: const EdgeInsets.all(4),
                child: TabBar(
                  controller: _tabController,
                  labelColor: AppColors.primary,
                  unselectedLabelColor: AppColors.textSecondary,
                  indicator: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(LearnerUi.cardRadius),
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  dividerColor: Colors.transparent,
                  isScrollable: true,
                  tabAlignment: TabAlignment.start,
                  labelStyle: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                  unselectedLabelStyle: GoogleFonts.inter(
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                  ),
                  tabs: const [
                    Tab(text: 'All Courses'),
                    Tab(text: 'In Progress'),
                    Tab(text: 'Completed'),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _grid(_filter('All')),
                    _grid(_filter('IP')),
                    _grid(_filter('Done')),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _grid(List<Map<String, dynamic>> list) {
    return LayoutBuilder(
      builder: (ctx, c) {
        final cols = learnerGridColumns(c.maxWidth);
        return GridView.builder(
          padding: EdgeInsets.zero,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: cols,
            crossAxisSpacing: LearnerUi.cardSpacing,
            mainAxisSpacing: LearnerUi.cardSpacing,
            childAspectRatio: cols == 1 ? 1.35 : 1.18,
          ),
          itemCount: list.length,
          itemBuilder: (_, i) => _card(list[i])
              .animate()
              .fadeIn(delay: (i * 60).ms, duration: 350.ms)
              .slideY(begin: 0.04, end: 0),
        );
      },
    );
  }

  Widget _card(Map<String, dynamic> c) {
    final Color clr = c['color'];
    final double p = c['progress'];
    final bool done = p >= 1.0;

    return Container(
      decoration: LearnerUi.cardDecoration(),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 64,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  clr.withValues(alpha: 0.85),
                  clr.withValues(alpha: 0.5),
                ],
              ),
            ),
            child: Row(
              children: [
                LearnerChip(label: c['cat'] as String, color: Colors.white),
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(LearnerUi.cardRadius),
                  ),
                  child: Text(
                    c['level'] as String,
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
                const Spacer(),
                if (done)
                  const Icon(
                    Icons.verified_rounded,
                    color: Colors.white,
                    size: 20,
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
                    c['title'] as String,
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
                    'by ${c['trainer']}',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const Spacer(),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: p,
                      backgroundColor: clr.withValues(alpha: 0.12),
                      valueColor: AlwaysStoppedAnimation<Color>(clr),
                      minHeight: 6,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${c['done']}/${c['lessons']} lessons',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      Text(
                        '${(p * 100).toInt()}%',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: clr,
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
}
