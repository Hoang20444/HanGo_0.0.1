import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hango/theme/app_colors.dart';
import 'package:hango/widgets/shared_widgets.dart';

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
      'color': const Color(0xFF8B5CF6),
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
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const PageHeader(
            title: 'My Courses',
            subtitle: 'Track your enrolled courses and continue learning',
          ).animate().fadeIn(duration: 400.ms),
          const SizedBox(height: 24),
          Container(
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColors.border)),
            ),
            child: TabBar(
              controller: _tabController,
              labelColor: AppColors.primary,
              unselectedLabelColor: AppColors.textSecondary,
              indicatorColor: AppColors.primary,
              indicatorWeight: 3,
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              labelStyle: GoogleFonts.inter(fontWeight: FontWeight.w600),
              tabs: const [
                Tab(text: 'All Courses'),
                Tab(text: 'In Progress'),
                Tab(text: 'Completed'),
              ],
            ),
          ),
          const SizedBox(height: 24),
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
    );
  }

  Widget _grid(List<Map<String, dynamic>> list) {
    return LayoutBuilder(
      builder: (ctx, c) {
        final cols = c.maxWidth > 900 ? 3 : (c.maxWidth > 550 ? 2 : 1);
        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: cols,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            childAspectRatio: 1.4,
          ),
          itemCount: list.length,
          itemBuilder: (_, i) => _card(list[i])
              .animate()
              .fadeIn(delay: (i * 80).ms, duration: 400.ms)
              .slideY(begin: 0.06, end: 0),
        );
      },
    );
  }

  Widget _card(Map<String, dynamic> c) {
    final Color clr = c['color'];
    final double p = c['progress'];
    final bool done = p >= 1.0;
    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 6,
            decoration: BoxDecoration(
              color: clr,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      StatusBadge(label: c['cat'], color: clr),
                      const SizedBox(width: 6),
                      StatusBadge(
                        label: c['level'],
                        color: AppColors.textSecondary,
                      ),
                      const Spacer(),
                      if (done)
                        const Icon(
                          Icons.verified_rounded,
                          color: AppColors.success,
                          size: 20,
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    c['title'],
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'by ${c['trainer']}',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: p,
                            backgroundColor: clr.withOpacity(0.1),
                            valueColor: AlwaysStoppedAnimation<Color>(clr),
                            minHeight: 6,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        '${c['done']}/${c['lessons']}',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
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
