import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'create_theory_lesson_screen.dart';
import 'create_quiz_screen.dart';
import '../../theme/app_colors.dart';
import '../../widgets/shared_widgets.dart';

class CreateCourseScreen extends StatefulWidget {
  const CreateCourseScreen({super.key});

  @override
  State<CreateCourseScreen> createState() => _CreateCourseScreenState();
}

class _CreateCourseScreenState extends State<CreateCourseScreen> {
  int _currentStep = 0; // 0: Info, 1: Curriculum
  double _progress = 0.0;

  final _courseNameCtrl = TextEditingController();
  final _courseDescCtrl = TextEditingController();
  String _selectedCategory = 'Grammar';
  String _selectedLevel = 'Beginner';

  final List<Map<String, dynamic>> _sections = [];

  @override
  void dispose() {
    _courseNameCtrl.dispose();
    _courseDescCtrl.dispose();
    super.dispose();
  }

  void _saveCourseInfo() {
    setState(() {
      _currentStep = 1;
      _progress = 0.33;
    });
  }

  void _addSection() {
    setState(() {
      _sections.add({'title': 'New Section', 'lessons': []});
    });
  }

  void _showAddLessonDialog(int sectionIndex) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Add Learning Material',
          style: GoogleFonts.inter(fontWeight: FontWeight.w700),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildMaterialOption(
              Icons.menu_book_rounded,
              'Theory Lesson',
              'Create a rich-text lesson with formatting.',
              AppColors.primary,
              () {
                Navigator.pop(context);
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => CreateTheoryLessonScreen(
                      onSave: (title) {
                        setState(() {
                          _sections[sectionIndex]['lessons'].add({
                            'type': 'Theory',
                            'title': title,
                          });
                        });
                      },
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            _buildMaterialOption(
              Icons.quiz_rounded,
              'Interactive Quiz',
              'Create multiple choice or reading comprehension.',
              AppColors.quizAccent,
              () {
                Navigator.pop(context);
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => CreateQuizScreen(
                      onSave: (title) {
                        setState(() {
                          _sections[sectionIndex]['lessons'].add({
                            'type': 'Quiz',
                            'title': title,
                          });
                        });
                      },
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMaterialOption(
    IconData icon,
    String title,
    String desc,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    desc,
                    style: GoogleFonts.inter(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        title: Text(
          'Course Creator Studio',
          style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 20),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: AppColors.border, height: 1),
        ),
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sidebar steps
          Container(
            width: 280,
            color: Colors.white,
            padding: const EdgeInsets.all(32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Creation Progress',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: _progress,
                    minHeight: 8,
                    backgroundColor: AppColors.background,
                    valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${(_progress * 100).toInt()}% Completed',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 48),
                _buildStep(0, 'Course Info', 'Basic details & thumbnail'),
                _buildStep(1, 'Curriculum', 'Sections, lessons & quizzes'),
                _buildStep(2, 'Publish Settings', 'Pricing & visibility'),
              ],
            ),
          ),
          Container(width: 1, color: AppColors.border),
          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(40),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 800),
                child: _currentStep == 0
                    ? _buildInfoForm()
                    : _buildCurriculumForm(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep(int stepIndex, String title, String subtitle) {
    final isActive = _currentStep == stepIndex;
    final isCompleted = _currentStep > stepIndex;
    final color = isActive
        ? AppColors.primary
        : (isCompleted ? AppColors.success : AppColors.textMuted);

    return Padding(
      padding: const EdgeInsets.only(bottom: 32),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isCompleted
                  ? AppColors.success
                  : (isActive
                        ? AppColors.primary.withOpacity(0.1)
                        : AppColors.background),
              border: Border.all(
                color: isActive
                    ? AppColors.primary
                    : (isCompleted ? AppColors.success : AppColors.border),
                width: 2,
              ),
            ),
            child: Center(
              child: isCompleted
                  ? const Icon(Icons.check, size: 16, color: Colors.white)
                  : Text(
                      '${stepIndex + 1}',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
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
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: isActive || isCompleted
                        ? AppColors.textPrimary
                        : AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PageHeader(
          title: 'Course Information',
          subtitle: 'Set up the basic details for your new course.',
        ).animate().fadeIn(),
        const SizedBox(height: 32),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionLabel('Course Title'),
              TextField(
                controller: _courseNameCtrl,
                decoration: const InputDecoration(
                  hintText: 'E.g., IELTS Academic Mastery 2024',
                ),
              ),
              const SizedBox(height: 24),
              const SectionLabel('Description'),
              TextField(
                controller: _courseDescCtrl,
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText: 'What will students learn in this course?',
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SectionLabel('Category'),
                        DropdownButtonFormField<String>(
                          initialValue: _selectedCategory,
                          decoration: const InputDecoration(),
                          items:
                              [
                                    'Grammar',
                                    'Vocabulary',
                                    'Reading',
                                    'Listening',
                                    'Speaking',
                                    'Writing',
                                  ]
                                  .map(
                                    (e) => DropdownMenuItem(
                                      value: e,
                                      child: Text(e),
                                    ),
                                  )
                                  .toList(),
                          onChanged: (v) =>
                              setState(() => _selectedCategory = v!),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SectionLabel('Academic Level'),
                        DropdownButtonFormField<String>(
                          initialValue: _selectedLevel,
                          decoration: const InputDecoration(),
                          items: ['Beginner', 'Intermediate', 'Advanced']
                              .map(
                                (e) =>
                                    DropdownMenuItem(value: e, child: Text(e)),
                              )
                              .toList(),
                          onChanged: (v) => setState(() => _selectedLevel = v!),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const SectionLabel('Course Thumbnail'),
              Container(
                width: double.infinity,
                height: 180,
                decoration: BoxDecoration(
                  color: AppColors.background,
                  border: Border.all(
                    color: AppColors.border,
                    style: BorderStyle.solid,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.cloud_upload_outlined,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Click to upload or drag and drop',
                      style: GoogleFonts.inter(fontWeight: FontWeight.w500),
                    ),
                    Text(
                      'SVG, PNG, JPG or GIF (max. 800x400px)',
                      style: GoogleFonts.inter(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ).animate().fadeIn().slideY(begin: 0.05, end: 0),
        const SizedBox(height: 32),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TealButton(
              label: 'Save & Continue',
              icon: Icons.arrow_forward,
              onPressed: _saveCourseInfo,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCurriculumForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PageHeader(
          title: 'Curriculum Builder',
          subtitle:
              'Organize your course into sections and add learning materials.',
        ).animate().fadeIn(),
        const SizedBox(height: 32),
        ..._sections.asMap().entries.map((e) {
          int index = e.key;
          var section = e.value;
          return Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: AppCard(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.drag_indicator,
                        color: AppColors.textMuted,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Section ${index + 1}: ${section['title']}',
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit_outlined, size: 20),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.delete_outline,
                          size: 20,
                          color: AppColors.error,
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (section['lessons'].isEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppColors.border,
                          style: BorderStyle.none,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'No lessons yet. Add materials to get started.',
                          style: GoogleFonts.inter(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    )
                  else
                    ...List.generate(section['lessons'].length, (lIndex) {
                      var lesson = section['lessons'][lIndex];
                      bool isQuiz = lesson['type'] == 'Quiz';
                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.border),
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white,
                        ),
                        child: ListTile(
                          leading: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color:
                                  (isQuiz
                                          ? AppColors.quizAccent
                                          : AppColors.primary)
                                      .withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Icon(
                              isQuiz
                                  ? Icons.quiz_rounded
                                  : Icons.menu_book_rounded,
                              color: isQuiz
                                  ? AppColors.quizAccent
                                  : AppColors.primary,
                              size: 20,
                            ),
                          ),
                          title: Text(
                            lesson['title'],
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit_outlined, size: 18),
                                onPressed: () {},
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete_outline,
                                  size: 18,
                                  color: AppColors.error,
                                ),
                                onPressed: () {},
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  const SizedBox(height: 16),
                  TealButton(
                    label: 'Add Material',
                    icon: Icons.add,
                    outlined: true,
                    onPressed: () => _showAddLessonDialog(index),
                  ),
                ],
              ),
            ),
          ).animate().fadeIn().slideY(begin: 0.05, end: 0);
        }),
        InkWell(
          onTap: _addSection,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 24),
            decoration: BoxDecoration(
              color: AppColors.primarySurface,
              border: Border.all(color: AppColors.primary.withOpacity(0.3)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.add_circle_outline,
                  color: AppColors.primaryDark,
                ),
                const SizedBox(width: 8),
                Text(
                  'Add New Section',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryDark,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ).animate().fadeIn(delay: 200.ms),
        const SizedBox(height: 48),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () => setState(() => _currentStep = 0),
              child: Text(
                'Back',
                style: GoogleFonts.inter(fontWeight: FontWeight.w600),
              ),
            ),
            TealButton(
              label: 'Finish & Review',
              icon: Icons.check,
              onPressed: () {
                setState(() => _progress = 1.0);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ],
    );
  }
}
