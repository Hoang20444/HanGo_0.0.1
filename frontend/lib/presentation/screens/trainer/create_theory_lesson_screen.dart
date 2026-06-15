import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';
import '../../widgets/shared_widgets.dart';

class CreateTheoryLessonScreen extends StatefulWidget {
  final Function(String) onSave;

  const CreateTheoryLessonScreen({super.key, required this.onSave});

  @override
  State<CreateTheoryLessonScreen> createState() =>
      _CreateTheoryLessonScreenState();
}

class _CreateTheoryLessonScreenState extends State<CreateTheoryLessonScreen> {
  final _titleCtrl = TextEditingController();

  @override
  void dispose() {
    _titleCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Create Theory Lesson',
          style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 18),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TealButton(
              label: 'Save Lesson',
              icon: Icons.save,
              onPressed: () {
                widget.onSave(
                  _titleCtrl.text.isEmpty ? 'Untitled Lesson' : _titleCtrl.text,
                );
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: _titleCtrl,
                  style: GoogleFonts.inter(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Lesson Title...',
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    fillColor: Colors.transparent,
                    filled: false,
                  ),
                ),
                const SizedBox(height: 16),
                // Premium Editor Toolbar
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: AppColors.border),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                  ),
                  child: Wrap(
                    spacing: 4,
                    runSpacing: 4,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      _formatBtn(Icons.format_bold),
                      _formatBtn(Icons.format_italic),
                      _formatBtn(Icons.format_underline),
                      const SizedBox(width: 8),
                      Container(width: 1, height: 24, color: AppColors.border),
                      const SizedBox(width: 8),
                      _formatBtn(Icons.title),
                      _formatBtn(Icons.format_size),
                      const SizedBox(width: 8),
                      Container(width: 1, height: 24, color: AppColors.border),
                      const SizedBox(width: 8),
                      _formatBtn(Icons.format_list_bulleted),
                      _formatBtn(Icons.format_list_numbered),
                      _formatBtn(Icons.format_quote),
                      const SizedBox(width: 8),
                      Container(width: 1, height: 24, color: AppColors.border),
                      const SizedBox(width: 8),
                      _formatBtn(Icons.link),
                      _formatBtn(Icons.image_outlined),
                      _formatBtn(Icons.code),
                    ],
                  ),
                ),
                // Editor Area
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: AppColors.border),
                      borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(12),
                      ),
                    ),
                    child: TextField(
                      maxLines: null,
                      expands: true,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        color: AppColors.textPrimary,
                        height: 1.6,
                      ),
                      decoration: const InputDecoration(
                        hintText: 'Start writing your lesson content here...',
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        contentPadding: EdgeInsets.all(24),
                        fillColor: Colors.transparent,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _formatBtn(IconData icon) {
    return IconButton(
      icon: Icon(icon, size: 20),
      color: AppColors.textSecondary,
      onPressed: () {},
      splashRadius: 20,
    );
  }
}
