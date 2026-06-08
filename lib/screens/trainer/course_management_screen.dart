import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hango/screens/trainer/create_course_screen.dart';
import 'package:hango/theme/app_colors.dart';
import 'package:hango/widgets/shared_widgets.dart';

class CourseManagementScreen extends StatefulWidget {
  const CourseManagementScreen({super.key});

  @override
  State<CourseManagementScreen> createState() => _CourseManagementScreenState();
}

class _CourseManagementScreenState extends State<CourseManagementScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PageHeader(
            title: 'Course Management',
            subtitle: 'Create and manage your educational content',
            actions: [
              TealButton(
                label: 'Create Course',
                icon: Icons.add,
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const CreateCourseScreen(),
                    ),
                  );
                },
              ),
            ],
          ).animate().fadeIn(),
          const SizedBox(height: 32),
          AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                // Tabs
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
                    labelStyle: GoogleFonts.inter(fontWeight: FontWeight.w600),
                    tabs: const [
                      Tab(text: 'All Courses'),
                      Tab(text: 'Drafts'),
                      Tab(text: 'Published'),
                      Tab(text: 'Hidden'),
                      Tab(text: 'Pending'),
                    ],
                  ),
                ),
                // Filters
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: TextField(
                          decoration: const InputDecoration(
                            hintText: 'Search courses...',
                            prefixIcon: Icon(Icons.search, size: 20),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          decoration: const InputDecoration(),
                          initialValue: 'Newest',
                          items: const [
                            DropdownMenuItem(
                              value: 'Newest',
                              child: Text('Sort by: Newest'),
                            ),
                            DropdownMenuItem(
                              value: 'Oldest',
                              child: Text('Sort by: Oldest'),
                            ),
                          ],
                          onChanged: (val) {},
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextField(
                          readOnly: true,
                          decoration: const InputDecoration(
                            hintText: 'Date Range',
                            prefixIcon: Icon(Icons.calendar_today, size: 18),
                          ),
                          onTap: () async {
                            await showDateRangePicker(
                              context: context,
                              firstDate: DateTime(2020),
                              lastDate: DateTime(2030),
                              builder: (context, child) {
                                return Theme(
                                  data: Theme.of(context).copyWith(
                                    colorScheme: const ColorScheme.light(
                                      primary: AppColors.primary,
                                    ),
                                  ),
                                  child: child!,
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.05, end: 0),
          const SizedBox(height: 24),
          // Course List
          Expanded(
            child: ListView(
              children: [
                _buildCourseCard(
                  'Advanced English Grammar',
                  'Grammar',
                  'Advanced',
                  'Published',
                  '2023-10-01',
                ),
                _buildCourseCard(
                  'IELTS Reading Mastery',
                  'Reading',
                  'Intermediate',
                  'Draft',
                  '2023-10-05',
                ),
                _buildCourseCard(
                  'Basic Vocabulary',
                  'Vocabulary',
                  'Beginner',
                  'Pending',
                  '2023-10-10',
                ),
              ].animate(interval: 100.ms).fadeIn().slideX(begin: 0.05, end: 0),
            ),
          ),
          const PaginationRow(total: 3, showing: 3),
        ],
      ),
    );
  }

  Widget _buildCourseCard(
    String title,
    String category,
    String level,
    String status,
    String date,
  ) {
    Color statusColor;
    switch (status) {
      case 'Published':
        statusColor = AppColors.success;
        break;
      case 'Draft':
        statusColor = AppColors.textSecondary;
        break;
      case 'Pending':
        statusColor = AppColors.warning;
        break;
      default:
        statusColor = AppColors.textSecondary;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: AppCard(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 100,
              height: 70,
              decoration: BoxDecoration(
                color: AppColors.primaryLight.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.image_outlined,
                color: AppColors.primary,
                size: 32,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _tag(category),
                      const SizedBox(width: 8),
                      _tag(level),
                      const SizedBox(width: 12),
                      Text(
                        'Created: $date',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            StatusBadge(label: status, color: statusColor),
            const SizedBox(width: 16),
            IconButton(
              icon: const Icon(Icons.more_vert),
              color: AppColors.textSecondary,
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _tag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: AppColors.border),
      ),
      child: Text(
        text,
        style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary),
      ),
    );
  }
}
