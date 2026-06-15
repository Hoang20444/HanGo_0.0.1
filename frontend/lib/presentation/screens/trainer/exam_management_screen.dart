import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_design_system.dart';
import '../../widgets/shared_widgets.dart';

class ExamManagementScreen extends StatelessWidget {
  const ExamManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PageHeader(
            title: 'Official Exams',
            subtitle: 'Manage full-length exams with time limits',
            actions: [
              TealButton(
                label: 'Create Exam',
                icon: Icons.add,
                onPressed: () => _showCreateExamDialog(context),
              ),
            ],
          ).animate().fadeIn(),
          const SizedBox(height: 32),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                // Calculate responsive grid columns
                final crossAxisCount =
                    constraints.maxWidth > AppDimensions.screenLarge
                    ? 3
                    : (constraints.maxWidth > AppDimensions.screenMedium
                          ? 2
                          : 1);

                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: AppSpacing.xl,
                    mainAxisSpacing: AppSpacing.xl,
                    childAspectRatio: 1.5,
                  ),
                  itemCount: 4,
                  itemBuilder: (context, index) {
                    return _buildExamCard(index)
                        .animate()
                        .fadeIn(delay: Duration(milliseconds: 100 * index))
                        .slideY(begin: 0.1, end: 0);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExamCard(int index) {
    final titles = [
      'National High School Exam 2025',
      'IELTS Mock Test 1',
      'Mid-term Assessment',
      'Final Year Exam 2025',
    ];
    final times = ['60 mins', '120 mins', '45 mins', '90 mins'];

    return AppCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.examAccent.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.assignment_rounded,
                  color: AppColors.examAccent,
                ),
              ),
              IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
            ],
          ),
          const Spacer(),
          Text(
            titles[index],
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w700,
              fontSize: 18,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(
                Icons.timer_outlined,
                size: 16,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 4),
              Text(
                times[index],
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
              const Spacer(),
              const StatusBadge(label: 'Published', color: AppColors.success),
            ],
          ),
        ],
      ),
    );
  }

  void _showCreateExamDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Create New Exam',
          style: GoogleFonts.inter(fontWeight: FontWeight.w700),
        ),
        content: SizedBox(
          width: 500,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const TextField(
                decoration: InputDecoration(labelText: 'Exam Title'),
              ),
              const SizedBox(height: 16),
              const TextField(
                maxLines: 3,
                decoration: InputDecoration(labelText: 'Description'),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: 'Passing Score (%)',
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: 'Time Limit (minutes)',
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TealButton(
            label: 'Save & Open Builder',
            onPressed: () {
              Navigator.pop(context);
              // Navigates to a builder similar to CreateQuizScreen
            },
          ),
        ],
      ),
    );
  }
}
