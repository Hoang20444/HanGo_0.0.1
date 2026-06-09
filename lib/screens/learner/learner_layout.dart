import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hango/screens/learner/dashboard_screen.dart';
import 'package:hango/screens/learner/my_courses_screen.dart';
import 'package:hango/screens/learner/explore_screen.dart';
import 'package:hango/screens/learner/exams_screen.dart';
import 'package:hango/screens/learner/learning_path_screen.dart';
import 'package:hango/screens/learner/progress_screen.dart';
import 'package:hango/theme/app_colors.dart';

class LearnerLayout extends StatefulWidget {
  const LearnerLayout({super.key});

  @override
  State<LearnerLayout> createState() => _LearnerLayoutState();
}

class _LearnerLayoutState extends State<LearnerLayout> {
  int _selectedIndex = 0;

  final List<String> _navItems = [
    'Home',
    'My Courses',
    'Explore',
    'Learning Path',
    'Exams',
    'Progress',
  ];

  final List<IconData> _navIcons = [
    Icons.home_rounded,
    Icons.menu_book_rounded,
    Icons.explore_rounded,
    Icons.route_rounded,
    Icons.quiz_rounded,
    Icons.insights_rounded,
  ];

  final List<Widget> _screens = [
    const LearnerDashboardScreen(),
    const MyCoursesScreen(),
    const ExploreScreen(),
    const LearningPathScreen(),
    const ExamsScreen(),
    const ProgressScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // Horizontal Navigation Bar
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              border: const Border(bottom: BorderSide(color: AppColors.border)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 2,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
              child: Row(
                children: [
                  // Logo/Brand
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      'HanGo',
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 32),
                  // Navigation Items
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(
                          _navItems.length,
                          (index) => Padding(
                            padding: const EdgeInsets.only(right: 4),
                            child: _buildNavItem(index),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // User Profile
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primarySurface,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Center(
                            child: Text(
                              'H',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hoang',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            Text(
                              'Learner',
                              style: GoogleFonts.inter(
                                fontSize: 10,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Content
          Expanded(
            child: Container(
              color: AppColors.background,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (child, animation) => FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0.02, 0),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  ),
                ),
                child: KeyedSubtree(
                  key: ValueKey<int>(_selectedIndex),
                  child: _screens[_selectedIndex],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index) {
    final bool isSelected = _selectedIndex == index;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => setState(() => _selectedIndex = index),
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _navIcons[index],
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
                size: 20,
              ),
              const SizedBox(height: 4),
              Text(
                _navItems[index],
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected ? AppColors.primary : AppColors.textSecondary,
                ),
              ),
              if (isSelected)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Container(
                    width: 24,
                    height: 2,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(1),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    ).animate(onPlay: (controller) {}).fadeIn(duration: 200.ms);
  }
}
