import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hango/theme/app_colors.dart';
import 'package:hango/widgets/shared_widgets.dart';

class ExamsScreen extends StatefulWidget {
  const ExamsScreen({super.key});

  @override
  State<ExamsScreen> createState() => _ExamsScreenState();
}

class _ExamsScreenState extends State<ExamsScreen> {
  final List<Map<String, dynamic>> _activeExams = [
    {
      'code': 'EX-092',
      'title': 'National Graduation Mock Exam #4',
      'questions': 50,
      'duration': '60 mins',
      'attempts': '1/3',
    },
    {
      'code': 'EX-093',
      'title': 'Grammar Assessment Midterm',
      'questions': 30,
      'duration': '40 mins',
      'attempts': '0/2',
    },
    {
      'code': 'EX-094',
      'title': 'Vocabulary Power-Test Level B2',
      'questions': 40,
      'duration': '45 mins',
      'attempts': '2/2',
    },
  ];

  final List<Map<String, dynamic>> _examHistory = [
    {
      'code': 'EX-089',
      'title': 'National Graduation Mock Exam #3',
      'score': '42/50',
      'percentage': '84%',
      'date': '02 Dec 2025',
      'status': 'Passed',
    },
    {
      'code': 'EX-071',
      'title': 'Grammar Assessment Midterm (Prev)',
      'score': '18/30',
      'percentage': '60%',
      'date': '18 Nov 2025',
      'status': 'Failed',
    },
    {
      'code': 'EX-055',
      'title': 'Reading Comprehension Mini-Quiz',
      'score': '9/10',
      'percentage': '90%',
      'date': '04 Nov 2025',
      'status': 'Passed',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const PageHeader(
            title: 'Exams & Quizzes',
            subtitle: 'Take assessments and view past academic results',
          ).animate().fadeIn(duration: 400.ms),
          const SizedBox(height: 32),
          // Active Exams Heading
          Text(
            'Available Assessments',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ).animate().fadeIn(delay: 100.ms),
          const SizedBox(height: 16),
          // Responsive Card list
          LayoutBuilder(
            builder: (context, constraints) {
              final cols = constraints.maxWidth > 900
                  ? 3
                  : (constraints.maxWidth > 600 ? 2 : 1);
              return Wrap(
                spacing: 20,
                runSpacing: 20,
                children: _activeExams.asMap().entries.map((e) {
                  final ex = e.value;
                  return SizedBox(
                    width: (constraints.maxWidth - 20 * (cols - 1)) / cols,
                    child: _buildActiveExamCard(ex),
                  );
                }).toList(),
              );
            },
          ).animate().fadeIn(delay: 150.ms, duration: 400.ms),
          const SizedBox(height: 40),
          // Exam history
          Text(
            'Attempt History',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ).animate().fadeIn(delay: 200.ms),
          const SizedBox(height: 16),
          AppCard(padding: EdgeInsets.zero, child: _buildHistoryTable())
              .animate()
              .fadeIn(delay: 250.ms, duration: 400.ms)
              .slideY(begin: 0.05, end: 0),
        ],
      ),
    );
  }

  Widget _buildActiveExamCard(Map<String, dynamic> ex) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                ex['code'] as String,
                style: GoogleFonts.ibmPlexMono(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                  fontSize: 12,
                ),
              ),
              StatusBadge(
                label: '${ex['questions']} Questions',
                color: AppColors.info,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            ex['title'] as String,
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w600,
              fontSize: 15,
              color: AppColors.textPrimary,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(
                Icons.timer_outlined,
                size: 16,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 6),
              Text(
                ex['duration'] as String,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
              const Spacer(),
              const Icon(
                Icons.refresh_outlined,
                size: 16,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 6),
              Text(
                'Attempts: ${ex['attempts']}',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: TealButton(label: 'Start Exam', onPressed: () {}),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryTable() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: constraints.maxWidth),
              child: DataTable(
                headingRowColor: WidgetStateProperty.all(
                  const Color(0xFFF8FAFC),
                ),
                dataRowMaxHeight: 60,
                dataRowMinHeight: 60,
                headingTextStyle: GoogleFonts.inter(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
                columns: const [
                  DataColumn(label: Text('CODE')),
                  DataColumn(label: Text('EXAM TITLE')),
                  DataColumn(label: Text('SCORE')),
                  DataColumn(label: Text('PERCENTAGE')),
                  DataColumn(label: Text('DATE TAKEN')),
                  DataColumn(label: Text('STATUS')),
                ],
                rows: _examHistory.map((h) {
                  final isPassed = h['status'] == 'Passed';
                  return DataRow(
                    cells: [
                      DataCell(
                        Text(
                          h['code'] as String,
                          style: GoogleFonts.ibmPlexMono(
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      DataCell(
                        Text(
                          h['title'] as String,
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w500,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      DataCell(
                        Text(
                          h['score'] as String,
                          style: GoogleFonts.inter(
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      DataCell(
                        Text(
                          h['percentage'] as String,
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.bold,
                            color: isPassed
                                ? AppColors.success
                                : AppColors.error,
                          ),
                        ),
                      ),
                      DataCell(
                        Text(
                          h['date'] as String,
                          style: GoogleFonts.inter(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                      DataCell(
                        StatusBadge(
                          label: h['status'] as String,
                          color: isPassed ? AppColors.success : AppColors.error,
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        );
      },
    );
  }
}
