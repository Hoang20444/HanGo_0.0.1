import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../theme/app_colors.dart';
import '../../widgets/shared_widgets.dart';

class TrainerDashboardScreen extends StatelessWidget {
  const TrainerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const PageHeader(
            title: 'Trainer Dashboard',
            subtitle: 'Overview of your courses and students.',
          ).animate().fadeIn(),
          const SizedBox(height: 32),
          Row(
            children: [
              _statCard(
                'My Courses',
                '12',
                Icons.play_lesson,
                AppColors.primary,
              ),
              const SizedBox(width: 24),
              _statCard('Total Students', '840', Icons.people, AppColors.info),
              const SizedBox(width: 24),
              _statCard(
                'Pending Exams',
                '5',
                Icons.pending_actions,
                AppColors.warning,
              ),
            ].animate(interval: 100.ms).fadeIn().slideY(begin: 0.1, end: 0),
          ),
          const SizedBox(height: 32),
          Expanded(
            child: AppCard(
              child: const Center(
                child: Text(
                  'Recent Activity Placeholder',
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
