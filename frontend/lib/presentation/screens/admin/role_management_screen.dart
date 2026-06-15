import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../theme/app_colors.dart';
import '../../widgets/shared_widgets.dart';

class RoleManagementScreen extends StatelessWidget {
  const RoleManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PageHeader(
            title: 'Role Management',
            subtitle: 'Configure system access levels and permissions',
            actions: [
              TealButton(
                label: 'Create Role',
                icon: Icons.security,
                onPressed: () {},
              ),
            ],
          ).animate().fadeIn(duration: 400.ms),
          const SizedBox(height: 32),
          Expanded(
            child: ListView(
              children: [
                _buildRoleItem(
                  'Admin',
                  'Full access to all system features and configuration.',
                  ['Manage Users', 'Manage Roles', 'System Settings'],
                ),
                _buildRoleItem(
                  'Trainer',
                  'Manage courses, lessons, quizzes, and monitor students.',
                  ['Create Course', 'Create Quiz', 'Grade Student'],
                ),
                _buildRoleItem(
                  'Learner',
                  'Access assigned courses, take quizzes, view personal progress.',
                  ['View Course', 'Take Exam', 'View Progress'],
                ),
              ].animate(interval: 100.ms).fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoleItem(String title, String desc, List<String> perms) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.shield_outlined,
                    color: AppColors.primaryDark,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        desc,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                TealButton(
                  label: 'Edit',
                  icon: Icons.edit_outlined,
                  outlined: true,
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 16),
            const SectionLabel('Permissions Overview'),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: perms
                  .map(
                    (p) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        border: Border.all(color: AppColors.border),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.check_circle,
                            size: 14,
                            color: AppColors.success,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            p,
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
