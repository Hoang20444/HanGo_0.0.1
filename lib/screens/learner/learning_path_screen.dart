import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hango/theme/app_colors.dart';
import 'package:hango/widgets/shared_widgets.dart';

class LearningPathScreen extends StatefulWidget {
  const LearningPathScreen({super.key});

  @override
  State<LearningPathScreen> createState() => _LearningPathScreenState();
}

class _LearningPathScreenState extends State<LearningPathScreen> {
  bool _isRecommendedPath = true; // true = Recommended, false = Self-Study (Personal)

  final List<Map<String, dynamic>> _recommendedNodes = [
    {
      'title': 'Pronunciation & Phonics',
      'description': 'Master the basic English sound system and IPA.',
      'status': 'completed', // completed, active, locked
      'type': 'theory',
    },
    {
      'title': 'Basic Sentence Structures',
      'description': 'Understand Subject-Verb-Object pattern and auxiliary verbs.',
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
    final activeNodes = _isRecommendedPath ? _recommendedNodes : _selfStudyNodes;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const PageHeader(
                title: 'Learning Path',
                subtitle: 'Choose between proposed learning flow or self-guided study',
              ),
              _buildModeToggle(),
            ],
          ).animate().fadeIn(duration: 400.ms),
          const SizedBox(height: 32),
          Text(
            _isRecommendedPath
                ? 'AI Recommended Roadmap'
                : 'My Personal Study List',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ).animate().fadeIn(delay: 100.ms),
          const SizedBox(height: 24),
          _buildPathTimeline(activeNodes),
        ],
      ),
    );
  }

  Widget _buildModeToggle() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.border.withOpacity(0.5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _toggleBtn('Proposed Path', _isRecommendedPath, () {
            setState(() => _isRecommendedPath = true);
          }),
          _toggleBtn('Self-Study Mode', !_isRecommendedPath, () {
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
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: active ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          boxShadow: active
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  )
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
        return _buildTimelineNode(node, index + 1, isLast);
      },
    );
  }

  Widget _buildTimelineNode(Map<String, dynamic> node, int step, bool isLast) {
    final status = node['status'] as String;
    final type = node['type'] as String;

    Color stepColor = AppColors.border;
    IconData stepIcon = Icons.lock_outline;

    if (status == 'completed') {
      stepColor = AppColors.success;
      stepIcon = Icons.check;
    } else if (status == 'active') {
      stepColor = AppColors.primary;
      if (type == 'exam') {
        stepIcon = Icons.quiz_outlined;
      } else if (type == 'vocabulary') {
        stepIcon = Icons.translate_rounded;
      } else {
        stepIcon = Icons.menu_book_rounded;
      }
    } else {
      stepColor = AppColors.textSecondary.withOpacity(0.4);
      stepIcon = Icons.lock_outline;
    }

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Timeline indicator column
          Column(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: status == 'active' ? stepColor : stepColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                  border: Border.all(color: stepColor, width: 2),
                ),
                child: Icon(
                  stepIcon,
                  color: status == 'active' ? Colors.white : stepColor,
                  size: 20,
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: status == 'completed' ? AppColors.success : AppColors.border,
                  ),
                ),
            ],
          ),
          const SizedBox(width: 20),
          // Content Card column
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Opacity(
                opacity: status == 'locked' ? 0.6 : 1.0,
                child: AppCard(
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Step $step: ${node['title']}',
                                  style: GoogleFonts.inter(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                _buildBadge(type),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              node['description'] as String,
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      if (status == 'active')
                        TealButton(
                          label: 'Start Now',
                          icon: Icons.play_arrow_rounded,
                          onPressed: () {},
                        )
                      else if (status == 'completed')
                        const StatusBadge(label: 'Completed', color: AppColors.success)
                      else
                        const Icon(Icons.lock_rounded, color: AppColors.textSecondary, size: 20),
                    ],
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
    Color badgeColor = AppColors.primary;
    if (type == 'exam') {
      badgeColor = AppColors.error;
    } else if (type == 'vocabulary') {
      badgeColor = const Color(0xFF8B5CF6);
    }
    return StatusBadge(
      label: type.toUpperCase(),
      color: badgeColor,
    );
  }
}
