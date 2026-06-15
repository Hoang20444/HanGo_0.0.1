import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';
import '../../widgets/shared_widgets.dart';

class CreateQuizScreen extends StatefulWidget {
  final Function(String) onSave;

  const CreateQuizScreen({super.key, required this.onSave});

  @override
  State<CreateQuizScreen> createState() => _CreateQuizScreenState();
}

class _CreateQuizScreenState extends State<CreateQuizScreen> {
  final _titleCtrl = TextEditingController();
  final List<Map<String, dynamic>> _questions = [];

  @override
  void dispose() {
    _titleCtrl.dispose();
    super.dispose();
  }

  void _addQuestion(String type) {
    setState(() {
      if (type == 'Single') {
        _questions.add({
          'type': 'Single',
          'questionText': '',
          'options': ['', '', '', ''],
          'correctIndex': 0,
          'explanation': '',
        });
      } else {
        _questions.add({
          'type': 'Paragraph',
          'paragraphText': '',
          'subQuestions': [
            {
              'questionText': '',
              'options': ['', '', '', ''],
              'correctIndex': 0,
              'explanation': '',
            },
          ],
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Quiz Builder',
          style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 18),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TealButton(
              label: 'Save Quiz',
              icon: Icons.save,
              onPressed: () {
                widget.onSave(
                  _titleCtrl.text.isEmpty ? 'Untitled Quiz' : _titleCtrl.text,
                );
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sidebar Tools
          Container(
            width: 250,
            color: Colors.white,
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Add Question',
                  style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 16),
                _buildToolBtn(
                  'Single Question',
                  Icons.short_text,
                  () => _addQuestion('Single'),
                ),
                const SizedBox(height: 12),
                _buildToolBtn(
                  'Reading Comprehension',
                  Icons.article_outlined,
                  () => _addQuestion('Paragraph'),
                ),
              ],
            ),
          ),
          Container(width: 1, color: AppColors.border),
          // Builder Area
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(40),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 800),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _titleCtrl,
                      style: GoogleFonts.inter(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                      decoration: const InputDecoration(
                        hintText: 'Quiz Title (e.g. Grammar Check 1)...',
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        fillColor: Colors.transparent,
                        filled: false,
                      ),
                    ),
                    const SizedBox(height: 32),
                    if (_questions.isEmpty)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(40),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.border,
                            style: BorderStyle.solid,
                          ),
                        ),
                        child: Column(
                          children: [
                            const Icon(
                              Icons.quiz_outlined,
                              size: 48,
                              color: AppColors.textMuted,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No questions added yet.',
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            Text(
                              'Use the sidebar to add questions.',
                              style: GoogleFonts.inter(
                                color: AppColors.textMuted,
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      ..._questions.asMap().entries.map((e) {
                        int index = e.key;
                        var q = e.value;
                        if (q['type'] == 'Single') {
                          return _buildSingleQuestionCard(index, q);
                        } else {
                          return _buildParagraphQuestionCard(index, q);
                        }
                      }),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToolBtn(String label, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primary, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSingleQuestionCard(
    int index,
    Map<String, dynamic> q, {
    bool isSub = false,
    VoidCallback? onDelete,
  }) {
    return AppCard(
      padding: const EdgeInsets.all(24),
      color: isSub ? AppColors.background : Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isSub ? 'Sub-Question' : 'Question ${index + 1}',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryDark,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: AppColors.error),
                onPressed:
                    onDelete ??
                    () => setState(() => _questions.removeAt(index)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            maxLines: 2,
            decoration: const InputDecoration(
              hintText: 'Enter question text...',
            ),
            onChanged: (v) => q['questionText'] = v,
          ),
          const SizedBox(height: 24),
          const SectionLabel('Answers (Select the correct one)'),
          ...List.generate(4, (optIndex) {
            bool isCorrect = q['correctIndex'] == optIndex;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: [
                  Radio<int>(
                    value: optIndex,
                    groupValue: q['correctIndex'],
                    activeColor: AppColors.correct,
                    onChanged: (v) => setState(() => q['correctIndex'] = v!),
                  ),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Option ${optIndex + 1}',
                        focusedBorder: isCorrect
                            ? OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: AppColors.correct,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              )
                            : null,
                        enabledBorder: isCorrect
                            ? OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: AppColors.correct,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              )
                            : null,
                      ),
                      onChanged: (v) => q['options'][optIndex] = v,
                    ),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 24),
          const SectionLabel('Explanation (Shown after answering)'),
          TextField(
            maxLines: 2,
            decoration: const InputDecoration(
              hintText: 'Why is this the correct answer?',
            ),
            onChanged: (v) => q['explanation'] = v,
          ),
        ],
      ),
    );
  }

  Widget _buildParagraphQuestionCard(int index, Map<String, dynamic> q) {
    List subs = q['subQuestions'];
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: AppCard(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Reading Comprehension ${index + 1}',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                    color: AppColors.quizAccent,
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.delete_outline,
                    color: AppColors.error,
                  ),
                  onPressed: () => setState(() => _questions.removeAt(index)),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const SectionLabel('Reading Text / Paragraph'),
            TextField(
              maxLines: 6,
              decoration: const InputDecoration(
                hintText: 'Enter the long paragraph here...',
              ),
              onChanged: (v) => q['paragraphText'] = v,
            ),
            const SizedBox(height: 24),
            const SectionLabel('Related Questions'),
            ...subs.asMap().entries.map(
              (e) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _buildSingleQuestionCard(
                  e.key,
                  e.value,
                  isSub: true,
                  onDelete: () => setState(() => subs.removeAt(e.key)),
                ),
              ),
            ),
            OutlinedButton.icon(
              onPressed: () {
                setState(() {
                  subs.add({
                    'questionText': '',
                    'options': ['', '', '', ''],
                    'correctIndex': 0,
                    'explanation': '',
                  });
                });
              },
              icon: const Icon(Icons.add),
              label: const Text('Add Sub-Question'),
            ),
          ],
        ),
      ),
    );
  }
}
