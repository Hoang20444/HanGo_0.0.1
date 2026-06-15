import 'package:flutter/material.dart';
import 'course_management_screen.dart';
import 'dashboard_screen.dart';
import 'exam_management_screen.dart';
import 'question_bank_screen.dart';
import '../../theme/app_colors.dart';
import '../../widgets/app_sidebar.dart';

class TrainerLayout extends StatefulWidget {
  const TrainerLayout({super.key});

  @override
  State<TrainerLayout> createState() => _TrainerLayoutState();
}

class _TrainerLayoutState extends State<TrainerLayout> {
  int _selectedIndex = 1; // Default to Courses

  final List<Widget> _screens = [
    const TrainerDashboardScreen(),
    const CourseManagementScreen(),
    const ExamManagementScreen(),
    const QuestionBankScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          AppSidebar(
            portalLabel: 'Trainer Portal',
            items: [
              SidebarItem(icon: Icons.dashboard_rounded, label: 'Dashboard'),
              SidebarItem(icon: Icons.play_lesson_rounded, label: 'Courses'),
              SidebarItem(icon: Icons.assignment_rounded, label: 'Exams'),
              SidebarItem(
                icon: Icons.library_books_rounded,
                label: 'Question Bank',
              ),
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
