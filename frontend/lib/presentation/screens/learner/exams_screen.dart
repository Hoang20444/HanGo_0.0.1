import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'learner_ui.dart';
import '../../theme/app_colors.dart';
import '../../widgets/shared_widgets.dart';

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
    return LearnerPageWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const LearnerSectionHeader(
            title: 'Exams & Quizzes',
            subtitle: 'Take assessments and view past academic results',
          ).animate().fadeIn(duration: 400.ms),
          const SizedBox(height: LearnerUi.sectionGap),
          Text(
            'Available Assessments',
            style: LearnerUi.sectionTitleStyle,
          ).animate().fadeIn(delay: 80.ms),
          const SizedBox(height: 14),
          LayoutBuilder(
            builder: (context, constraints) {
              final cols = learnerGridColumns(constraints.maxWidth);
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: cols,
                  crossAxisSpacing: LearnerUi.cardSpacing,
                  mainAxisSpacing: LearnerUi.cardSpacing,
                  childAspectRatio: cols == 1 ? 1.2 : 1.05,
                ),
                itemCount: _activeExams.length,
                itemBuilder: (_, i) => _buildActiveExamCard(
                  _activeExams[i],
                ).animate().fadeIn(delay: (100 + i * 60).ms, duration: 350.ms),
              );
            },
          ).animate().fadeIn(delay: 100.ms, duration: 400.ms),
          const SizedBox(height: LearnerUi.sectionGap),
          Text(
            'Attempt History',
            style: LearnerUi.sectionTitleStyle,
          ).animate().fadeIn(delay: 180.ms),
          const SizedBox(height: 14),
          Container(
                decoration: LearnerUi.cardDecoration(elevated: false),
                clipBehavior: Clip.antiAlias,
                child: _buildHistoryTable(),
              )
              .animate()
              .fadeIn(delay: 220.ms, duration: 400.ms)
              .slideY(begin: 0.03, end: 0),
        ],
      ),
    );
  }

  Widget _buildActiveExamCard(Map<String, dynamic> ex) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: LearnerUi.cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  ex['code'] as String,
                  style: GoogleFonts.ibmPlexMono(
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                    fontSize: 11,
                  ),
                ),
              ),
              StatusBadge(
                label: '${ex['questions']} Qs',
                color: AppColors.info,
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            ex['title'] as String,
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: AppColors.textPrimary,
              height: 1.35,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const Spacer(),
          Row(
            children: [
              Expanded(
                child: _metaChip(
                  Icons.timer_outlined,
                  ex['duration'] as String,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _metaChip(
                  Icons.refresh_rounded,
                  'Attempts: ${ex['attempts']}',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: TealButton(label: 'Start Exam', onPressed: () {}),
          ),
        ],
      ),
    );
  }

  Widget _metaChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(LearnerUi.cardRadius),
      ),
      child: Row(
        children: [
          Icon(icon, size: 13, color: AppColors.textSecondary),
          const SizedBox(width: 5),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.inter(
                fontSize: 11,
                color: AppColors.textSecondary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
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
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: constraints.maxWidth),
            child: DataTable(
              headingRowColor: WidgetStateProperty.all(const Color(0xFFF8FAFC)),
              dataRowMaxHeight: 56,
              dataRowMinHeight: 56,
              headingTextStyle: GoogleFonts.inter(
                fontWeight: FontWeight.w600,
                fontSize: 11,
                color: AppColors.textSecondary,
              ),
              columns: const [
                DataColumn(label: Text('CODE')),
                DataColumn(label: Text('EXAM TITLE')),
                DataColumn(label: Text('SCORE')),
                DataColumn(label: Text('PERCENTAGE')),
                DataColumn(label: Text('DATE')),
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
                          fontSize: 12,
                        ),
                      ),
                    ),
                    DataCell(
                      Text(
                        h['title'] as String,
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    DataCell(Text(h['score'] as String)),
                    DataCell(
                      Text(
                        h['percentage'] as String,
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w700,
                          color: isPassed ? AppColors.success : AppColors.error,
                        ),
                      ),
                    ),
                    DataCell(
                      Text(
                        h['date'] as String,
                        style: GoogleFonts.inter(
                          color: AppColors.textSecondary,
                          fontSize: 13,
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
        );
      },
    );
  }
}
