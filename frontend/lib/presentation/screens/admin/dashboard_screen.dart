import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../theme/app_colors.dart';
import '../../widgets/shared_widgets.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const PageHeader(
            title: 'Dashboard Overview',
            subtitle: 'Welcome back! Here is what is happening today.',
          ).animate().fadeIn(),
          const SizedBox(height: 32),
          Row(
            children: [
              _statCard(
                'Total Users',
                '1,245',
                Icons.people_alt,
                AppColors.primary,
              ),
              const SizedBox(width: 24),
              _statCard(
                'Active Courses',
                '42',
                Icons.play_lesson,
                AppColors.info,
              ),
              const SizedBox(width: 24),
              _statCard(
                'Completed Exams',
                '8,930',
                Icons.assignment_turned_in,
                AppColors.success,
              ),
            ].animate(interval: 100.ms).fadeIn().slideY(begin: 0.1, end: 0),
          ),
          const SizedBox(height: 32),
          Expanded(
            child: AppCard(
              child: const Center(
                child: Text(
                  'Chart Placeholder',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              ),
            ).animate().fadeIn(delay: 300.ms),
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
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
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
}
