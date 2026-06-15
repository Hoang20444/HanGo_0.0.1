import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'learner_ui.dart';
import '../../theme/app_colors.dart';
import '../../widgets/shared_widgets.dart';

class LearningPathScreen extends StatefulWidget {
  const LearningPathScreen({super.key});

  @override
  State<LearningPathScreen> createState() => _LearningPathScreenState();
}

class _LearningPathScreenState extends State<LearningPathScreen> {
  bool _isRecommendedPath = true;

  final List<Map<String, dynamic>> _recommendedNodes = [
    {
      'title': 'Pronunciation & Phonics',
      'description': 'Master the basic English sound system and IPA.',
      'status': 'completed',
      'type': 'theory',
    },
    {
      'title': 'Basic Sentence Structures',
      'description':
          'Understand Subject-Verb-Object pattern and auxiliary verbs.',
      'status': 'completed',
      'type': 'theory',
    },
    {
      'title': 'Diagnostic Mock Test 1',
      'description': 'Test your current standing with our smart AI test.',
      'status': 'active',
      'type': 'exam',
    },
    {
      'title': 'Relative Clauses Mastery',
      'description': 'Learn defining vs non-defining relative clauses.',
      'status': 'locked',
      'type': 'theory',
    },
    {
      'title': 'Vocabulary Builder: Daily Life',
      'description': 'Acquire 100+ daily life essential idioms.',
      'status': 'locked',
      'type': 'vocabulary',
    },
    {
      'title': 'Midterm Comprehensive Exam',
      'description': 'Test grammar, vocabulary and reading skills.',
      'status': 'locked',
      'type': 'exam',
    },
  ];

  final List<Map<String, dynamic>> _selfStudyNodes = [
    {
      'title': 'Relative Clauses',
      'description': 'Self-guided grammar module.',
      'status': 'active',
      'type': 'theory',
    },
    {
      'title': 'IELTS Reading practice #3',
      'description': 'Matching headings practice.',
      'status': 'active',
      'type': 'exam',
    },
    {
      'title': 'Vocabulary: Science & Tech',
      'description': 'Learn science vocabulary words.',
      'status': 'active',
      'type': 'vocabulary',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final activeNodes = _isRecommendedPath
        ? _recommendedNodes
        : _selfStudyNodes;

    return LearnerPageWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final isCompact = constraints.maxWidth < 640;
              if (isCompact) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const LearnerSectionHeader(
                      title: 'Learning Path',
                      subtitle:
                          'Choose between proposed learning flow or self-guided study',
                    ),
                    const SizedBox(height: 16),
                    _buildModeToggle(),
                  ],
                );
              }
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Expanded(
                    child: LearnerSectionHeader(
                      title: 'Learning Path',
                      subtitle:
                          'Choose between proposed learning flow or self-guided study',
                    ),
                  ),
                  _buildModeToggle(),
                ],
              );
            },
          ).animate().fadeIn(duration: 400.ms),
          const SizedBox(height: LearnerUi.sectionGap),
          Text(
            _isRecommendedPath
                ? 'AI Recommended Roadmap'
                : 'My Personal Study List',
            style: LearnerUi.sectionTitleStyle,
          ).animate().fadeIn(delay: 80.ms),
          const SizedBox(height: 20),
          _buildPathTimeline(activeNodes),
        ],
      ),
    );
  }

  Widget _buildModeToggle() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(LearnerUi.cardRadius),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _toggleBtn('Proposed Path', _isRecommendedPath, () {
            setState(() => _isRecommendedPath = true);
          }),
          _toggleBtn('Self-Study', !_isRecommendedPath, () {
            setState(() => _isRecommendedPath = false);
          }),
        ],
      ),
    );
  }

  Widget _toggleBtn(String text, bool active, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
        decoration: BoxDecoration(
          color: active ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          boxShadow: active
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: Text(
          text,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: active ? AppColors.primary : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildPathTimeline(List<Map<String, dynamic>> nodes) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: nodes.length,
      itemBuilder: (context, index) {
        final node = nodes[index];
        final isLast = index == nodes.length - 1;
        return _buildTimelineNode(node, index + 1, isLast)
            .animate()
            .fadeIn(delay: (index * 60).ms, duration: 350.ms)
            .slideX(begin: 0.02, end: 0);
      },
    );
  }

  Widget _buildTimelineNode(Map<String, dynamic> node, int step, bool isLast) {
    final status = node['status'] as String;
    final type = node['type'] as String;

    Color stepColor = AppColors.border;
    IconData stepIcon = Icons.lock_outline_rounded;

    if (status == 'completed') {
      stepColor = AppColors.success;
      stepIcon = Icons.check_rounded;
    } else if (status == 'active') {
      stepColor = AppColors.primary;
      stepIcon = switch (type) {
        'exam' => Icons.quiz_outlined,
        'vocabulary' => Icons.translate_rounded,
        _ => Icons.menu_book_rounded,
      };
    } else {
      stepColor = AppColors.textMuted;
      stepIcon = Icons.lock_outline_rounded;
    }

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: status == 'active'
                      ? stepColor
                      : stepColor.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: stepColor,
                    width: status == 'locked' ? 1.5 : 2,
                  ),
                ),
                child: Icon(
                  stepIcon,
                  color: status == 'active' ? Colors.white : stepColor,
                  size: 18,
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                      color: status == 'completed'
                          ? AppColors.success.withValues(alpha: 0.5)
                          : AppColors.border,
                      borderRadius: BorderRadius.circular(1),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 16),
              child: Opacity(
                opacity: status == 'locked' ? 0.55 : 1.0,
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: LearnerUi.cardDecoration(
                    elevated: status == 'active',
                  ),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final body = Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Wrap(
                            spacing: 8,
                            runSpacing: 6,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Text(
                                'Step $step: ${node['title']}',
                                style: GoogleFonts.inter(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              _buildBadge(type),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            node['description'] as String,
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                              height: 1.4,
                            ),
                          ),
                        ],
                      );

                      final action = switch (status) {
                        'active' => LearnerPrimaryButton(
                          label: 'Start',
                          icon: Icons.play_arrow_rounded,
                          onPressed: () {},
                        ),
                        'completed' => const StatusBadge(
                          label: 'Done',
                          color: AppColors.success,
                        ),
                        _ => Icon(
                          Icons.lock_rounded,
                          color: AppColors.textMuted,
                          size: 20,
                        ),
                      };

                      if (constraints.maxWidth < 520) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [body, const SizedBox(height: 14), action],
                        );
                      }

                      return Row(
                        children: [
                          Expanded(child: body),
                          const SizedBox(width: 12),
                          action,
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(String type) {
    final badgeColor = switch (type) {
      'exam' => AppColors.error,
      'vocabulary' => const Color(0xFF6366F1),
      _ => AppColors.primary,
    };
    return StatusBadge(label: type.toUpperCase(), color: badgeColor);
  }
}
