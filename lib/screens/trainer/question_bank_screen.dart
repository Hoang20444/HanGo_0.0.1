import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hango/theme/app_colors.dart';
import 'package:hango/widgets/shared_widgets.dart';

class QuestionBankScreen extends StatelessWidget {
  const QuestionBankScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PageHeader(
            title: 'Question Bank',
            subtitle: 'Manage all questions across courses and exams',
            actions: [
              TealButton(
                label: 'Import Excel',
                icon: Icons.upload_file,
                outlined: true,
                onPressed: () {},
              ),
              const SizedBox(width: 16),
              TealButton(
                label: 'Create Question',
                icon: Icons.add,
                onPressed: () {},
              ),
            ],
          ).animate().fadeIn(),
          const SizedBox(height: 32),
          AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                // Filters
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                            labelText: 'Filter by Course',
                          ),
                          initialValue: 'All',
                          items: const [
                            DropdownMenuItem(
                              value: 'All',
                              child: Text('All Courses'),
                            ),
                          ],
                          onChanged: (v) {},
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                            labelText: 'Filter by Exam/Quiz',
                          ),
                          initialValue: 'All',
                          items: const [
                            DropdownMenuItem(
                              value: 'All',
                              child: Text('All Exams/Quizzes'),
                            ),
                          ],
                          onChanged: (v) {},
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextField(
                          decoration: const InputDecoration(
                            labelText: 'Search Questions...',
                            prefixIcon: Icon(Icons.search),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                // Table
                SizedBox(
                  height: MediaQuery.of(context).size.height - 320,
                  child: Column(
                    children: [
                      Expanded(
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            return SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: SingleChildScrollView(
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(minWidth: constraints.maxWidth),
                                  child: DataTable(
                                    headingRowColor: WidgetStateProperty.all(
                                      AppColors.background,
                                    ),
                                    headingTextStyle: GoogleFonts.inter(
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textSecondary,
                                    ),
                                    dataRowMaxHeight: 64,
                                    dataRowMinHeight: 64,
                                    columns: const [
                                      DataColumn(label: Text('Code')),
                                      DataColumn(label: Text('Content Snippet')),
                                      DataColumn(label: Text('Type')),
                                      DataColumn(label: Text('Last Updated')),
                                      DataColumn(label: Text('Actions')),
                                    ],
                                    rows: [
                                      _buildRow(
                                        'Q-1042',
                                        'What is the synonym of "Ubiquitous"?',
                                        'Single',
                                        'Oct 2, 2023',
                                      ),
                                      _buildRow(
                                        'Q-1043',
                                        'Reading Comprehension: Global Warming...',
                                        'Paragraph',
                                        'Oct 3, 2023',
                                      ),
                                      _buildRow(
                                        'Q-1044',
                                        'Fill in the blank: The cat ___ on the mat.',
                                        'Single',
                                        'Oct 5, 2023',
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const PaginationRow(total: 142, showing: 10),
                    ],
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.05, end: 0),
        ],
      ),
    );
  }

  DataRow _buildRow(String code, String snippet, String type, String date) {
    return DataRow(
      cells: [
        DataCell(
          Text(
            code,
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w600,
              color: AppColors.primaryDark,
            ),
          ),
        ),
        DataCell(
          SizedBox(
            width: 250,
            child: Text(
              snippet,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(color: AppColors.textPrimary),
            ),
          ),
        ),
        DataCell(
          StatusBadge(
            label: type,
            color: type == 'Single' ? AppColors.info : AppColors.quizAccent,
          ),
        ),
        DataCell(
          Text(date, style: GoogleFonts.inter(color: AppColors.textSecondary)),
        ),
        DataCell(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.visibility_outlined, size: 18),
                color: AppColors.info,
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.edit_outlined, size: 18),
                color: AppColors.primary,
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, size: 18),
                color: AppColors.error,
                onPressed: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }
}
