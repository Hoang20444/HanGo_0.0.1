import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hango/theme/app_colors.dart';
import 'package:hango/widgets/shared_widgets.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = [
      {'name': 'Grammar', 'icon': Icons.spellcheck, 'count': 12, 'color': AppColors.primary},
      {'name': 'Reading', 'icon': Icons.auto_stories, 'count': 8, 'color': AppColors.info},
      {'name': 'Writing', 'icon': Icons.edit_note, 'count': 6, 'color': const Color(0xFFEC4899)},
      {'name': 'Vocabulary', 'icon': Icons.abc, 'count': 15, 'color': const Color(0xFF8B5CF6)},
      {'name': 'Listening', 'icon': Icons.headphones, 'count': 5, 'color': const Color(0xFFF97316)},
      {'name': 'Speaking', 'icon': Icons.mic, 'count': 4, 'color': AppColors.success},
    ];

    final recommended = [
      {'title': 'TOEIC Preparation', 'trainer': 'Nguyen Viet Hoang', 'students': 234, 'rating': 4.8, 'cat': 'Grammar', 'color': AppColors.primary},
      {'title': 'Academic Writing', 'trainer': 'Luong Thi Thanh Thao', 'students': 156, 'rating': 4.6, 'cat': 'Writing', 'color': const Color(0xFFEC4899)},
      {'title': 'Listening for IELTS', 'trainer': 'Pham Minh Duc', 'students': 189, 'rating': 4.7, 'cat': 'Listening', 'color': const Color(0xFFF97316)},
      {'title': 'Business English', 'trainer': 'Nguyen Thanh Tung', 'students': 98, 'rating': 4.5, 'cat': 'Vocabulary', 'color': const Color(0xFF8B5CF6)},
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const PageHeader(title: 'Explore Courses', subtitle: 'Discover new courses to boost your English skills').animate().fadeIn(duration: 400.ms),
          const SizedBox(height: 24),
          // Search
          AppCard(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search courses, topics, trainers...',
                prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.border)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.border)),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.primary)),
              ),
            ),
          ).animate().fadeIn(delay: 50.ms),
          const SizedBox(height: 28),
          // Categories
          Text('Categories', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
          const SizedBox(height: 16),
          Wrap(
            spacing: 16, runSpacing: 16,
            children: categories.asMap().entries.map((e) {
              final c = e.value;
              return _categoryChip(c['name'] as String, c['icon'] as IconData, c['count'] as int, c['color'] as Color)
                  .animate().fadeIn(delay: (e.key * 60).ms, duration: 300.ms).scale(begin: const Offset(0.9, 0.9), end: const Offset(1, 1));
            }).toList(),
          ),
          const SizedBox(height: 32),
          // Recommended
          Text('Recommended for You', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
          const SizedBox(height: 16),
          LayoutBuilder(builder: (ctx, c) {
            final cols = c.maxWidth > 800 ? 2 : 1;
            return Wrap(
              spacing: 20, runSpacing: 20,
              children: recommended.asMap().entries.map((e) {
                final r = e.value;
                return SizedBox(
                  width: (c.maxWidth - 20 * (cols - 1)) / cols,
                  child: _recommendedCard(r).animate().fadeIn(delay: (e.key * 100).ms, duration: 400.ms).slideY(begin: 0.05, end: 0),
                );
              }).toList(),
            );
          }),
        ],
      ),
    );
  }

  Widget _categoryChip(String name, IconData icon, int count, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(width: 10),
          Text(name, style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 14, color: color)),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(10)),
            child: Text('$count', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: color)),
          ),
        ],
      ),
    );
  }

  Widget _recommendedCard(Map<String, dynamic> r) {
    final Color color = r['color'] as Color;
    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          height: 8,
          decoration: BoxDecoration(color: color, borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12))),
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              StatusBadge(label: r['cat'] as String, color: color),
              const Spacer(),
              Row(children: [
                const Icon(Icons.star_rounded, size: 16, color: Color(0xFFF59E0B)),
                const SizedBox(width: 4),
                Text('${r['rating']}', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
              ]),
            ]),
            const SizedBox(height: 12),
            Text(r['title'] as String, style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
            const SizedBox(height: 6),
            Text('by ${r['trainer']}', style: GoogleFonts.inter(fontSize: 13, color: AppColors.textSecondary)),
            const SizedBox(height: 14),
            Row(children: [
              Icon(Icons.people_outline, size: 16, color: AppColors.textSecondary),
              const SizedBox(width: 4),
              Text('${r['students']} students', style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary)),
              const Spacer(),
              TealButton(label: 'Enroll', icon: Icons.add, onPressed: () {}),
            ]),
          ]),
        ),
      ]),
    );
  }
}
