import 'package:flutter/material.dart';
import 'package:hango/screens/learner/dashboard_screen.dart';
import 'package:hango/screens/learner/my_courses_screen.dart';
import 'package:hango/screens/learner/explore_screen.dart';
import 'package:hango/screens/learner/exams_screen.dart';
import 'package:hango/screens/learner/learning_path_screen.dart';
import 'package:hango/screens/learner/progress_screen.dart';
import 'package:hango/theme/app_colors.dart';
import 'package:hango/widgets/app_sidebar.dart';

class LearnerLayout extends StatefulWidget {
  const LearnerLayout({super.key});

  @override
  State<LearnerLayout> createState() => _LearnerLayoutState();
}

class _LearnerLayoutState extends State<LearnerLayout> {
  int _selectedIndex = 0;

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
      body: Row(
        children: [
          AppSidebar(
            portalLabel: 'Learner Portal',
            items: [
              SidebarItem(icon: Icons.dashboard_rounded, label: 'Dashboard'),
              SidebarItem(icon: Icons.menu_book_rounded, label: 'My Courses'),
              SidebarItem(icon: Icons.explore_rounded, label: 'Explore'),
              SidebarItem(icon: Icons.route_rounded, label: 'Learning Path'),
              SidebarItem(icon: Icons.quiz_rounded, label: 'Exams'),
              SidebarItem(icon: Icons.insights_rounded, label: 'Progress'),
            ],
            selectedIndex: _selectedIndex,
            onItemTapped: (i) => setState(() => _selectedIndex = i),
          ),
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
}
