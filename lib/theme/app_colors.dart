import 'package:flutter/material.dart';

class AppColors {
  // Primary teal/emerald palette
  static const Color primary = Color(0xFF0D9488);       // Teal-600
  static const Color primaryDark = Color(0xFF0F766E);   // Teal-700
  static const Color primaryLight = Color(0xFF5EEAD4);  // Teal-300
  static const Color primarySurface = Color(0xFFF0FDFA); // Teal-50

  // Neutral palette
  static const Color background = Color(0xFFF8FAFC);    // Slate-50
  static const Color surface = Colors.white;
  static const Color textPrimary = Color(0xFF0F172A);   // Slate-900
  static const Color textSecondary = Color(0xFF64748B); // Slate-500
  static const Color textMuted = Color(0xFF94A3B8);     // Slate-400
  static const Color border = Color(0xFFE2E8F0);        // Slate-200
  static const Color borderDark = Color(0xFFCBD5E1);    // Slate-300

  // Sidebar
  static const Color sidebarBg = Colors.white;
  static const Color sidebarItemText = Color(0xFF64748B); // Slate-500
  static const Color sidebarItemSelected = Color(0xFF3B82F6); // Blue-500

  // Status
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);
  static const Color success = Color(0xFF22C55E);
  static const Color info = Color(0xFF3B82F6);

  // Quiz/Exam specific
  static const Color correct = Color(0xFF16A34A);
  static const Color incorrect = Color(0xFFDC2626);
  static const Color quizAccent = Color(0xFF8B5CF6);
  static const Color examAccent = Color(0xFFEC4899);
}
