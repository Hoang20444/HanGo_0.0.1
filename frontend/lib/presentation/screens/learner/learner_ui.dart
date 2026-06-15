import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';

/// Shared layout tokens & widgets for the learner experience.
class LearnerUi {
  LearnerUi._();

  static const double pagePadding = 24;
  static const double compactPagePadding = 16;
  static const double maxContentWidth = 1200;
  static const double sectionGap = 28;
  static const double cardRadius = 8;
  static const double cardSpacing = 16;

  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0F766E), Color(0xFF2563EB)],
  );

  static const LinearGradient softSurfaceGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFF8FAFC), Color(0xFFF1F5F9)],
  );

  static BoxDecoration cardDecoration({Color? accent, bool elevated = true}) {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(cardRadius),
      border: Border.all(color: AppColors.border.withValues(alpha: 0.8)),
      boxShadow: elevated
          ? [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.035),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ]
          : null,
    );
  }

  static EdgeInsets pageInsetsFor(double width) {
    final horizontal = width < 560 ? compactPagePadding : pagePadding;
    return EdgeInsets.all(horizontal);
  }

  static TextStyle sectionTitleStyle = GoogleFonts.inter(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static TextStyle sectionSubtitleStyle = GoogleFonts.inter(
    fontSize: 13,
    color: AppColors.textSecondary,
    height: 1.4,
  );
}

class LearnerPageWrapper extends StatelessWidget {
  final Widget child;
  final bool scrollable;
  final EdgeInsets? padding;

  const LearnerPageWrapper({
    super.key,
    required this.child,
    this.scrollable = true,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final content = Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: LearnerUi.maxContentWidth),
        child: Padding(
          padding: padding ?? LearnerUi.pageInsetsFor(width),
          child: child,
        ),
      ),
    );

    if (!scrollable) return content;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: content,
    );
  }
}

class LearnerSectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? action;

  const LearnerSectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final headerText = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: LearnerUi.sectionTitleStyle),
            if (subtitle != null) ...[
              const SizedBox(height: 4),
              Text(subtitle!, style: LearnerUi.sectionSubtitleStyle),
            ],
          ],
        );

        if (action == null) return headerText;

        if (constraints.maxWidth < 520) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [headerText, const SizedBox(height: 10), action!],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: headerText),
            action!,
          ],
        );
      },
    );
  }
}

class LearnerSurfaceIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  final double size;

  const LearnerSurfaceIcon({
    super.key,
    required this.icon,
    required this.color,
    this.size = 44,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(LearnerUi.cardRadius),
        border: Border.all(color: color.withValues(alpha: 0.16)),
      ),
      child: Icon(icon, color: color, size: size * 0.5),
    );
  }
}

class LearnerPrimaryButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final bool filled;

  const LearnerPrimaryButton({
    super.key,
    required this.label,
    this.icon,
    this.onPressed,
    this.filled = true,
  });

  @override
  Widget build(BuildContext context) {
    final foreground = filled ? Colors.white : AppColors.primary;
    return SizedBox(
      height: 40,
      child: TextButton.icon(
        onPressed: onPressed,
        icon: icon == null ? const SizedBox.shrink() : Icon(icon, size: 16),
        label: Text(label, overflow: TextOverflow.ellipsis),
        style: TextButton.styleFrom(
          backgroundColor: filled
              ? AppColors.primary
              : AppColors.primarySurface,
          foregroundColor: foreground,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(LearnerUi.cardRadius),
            side: filled
                ? BorderSide.none
                : const BorderSide(color: AppColors.border),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class LearnerTextLink extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;

  const LearnerTextLink({super.key, required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
        ),
      ),
    );
  }
}

class LearnerStatCard extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  final Color color;

  const LearnerStatCard({
    super.key,
    required this.value,
    required this.label,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: LearnerUi.cardDecoration(),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  color.withValues(alpha: 0.15),
                  color.withValues(alpha: 0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(LearnerUi.cardRadius),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: GoogleFonts.inter(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class LearnerChip extends StatelessWidget {
  final String label;
  final Color color;

  const LearnerChip({super.key, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.16)),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}

/// Responsive column count helper.
int learnerGridColumns(
  double width, {
  int wide = 3,
  int medium = 2,
  int narrow = 1,
}) {
  if (width > 900) return wide;
  if (width > 560) return medium;
  return narrow;
}
