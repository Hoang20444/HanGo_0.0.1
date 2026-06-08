import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hango/theme/app_colors.dart';
import 'package:hango/theme/app_design_system.dart';
import 'package:hango/screens/login/login_screen.dart';

class AppSidebar extends StatelessWidget {
  final String portalLabel;
  final List<SidebarItem> items;
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;

  const AppSidebar({
    super.key,
    required this.portalLabel,
    required this.items,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isCompact = screenWidth < AppDimensions.screenMedium;

    return Container(
      width: isCompact
          ? AppDimensions.sidebarCollapsedWidth
          : AppDimensions.sidebarWidth,
      color: AppColors.sidebarBg,
      child: Column(
        children: [
          // Logo area
          Container(
            padding: EdgeInsets.fromLTRB(
              isCompact ? AppSpacing.sm : AppSpacing.xl,
              AppSpacing.xl,
              isCompact ? AppSpacing.sm : AppSpacing.xl,
              AppSpacing.lg,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: isCompact
                      ? MainAxisAlignment.center
                      : MainAxisAlignment.start,
                  children: [
                    Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                      ),
                      child: const Icon(
                        Icons.school_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    if (!isCompact) ...[
                      const SizedBox(width: 10),
                      Text(
                        'HanGo',
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: AppFontSize.xl,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ],
                ),
                if (!isCompact) ...[
                  const SizedBox(height: 6),
                  Text(
                    portalLabel,
                    style: GoogleFonts.inter(
                      color: AppColors.sidebarItemText,
                      fontSize: AppFontSize.sm,
                    ),
                  ),
                ],
              ],
            ),
          ),
          Container(height: 1, color: Colors.white.withOpacity(0.06)),
          SizedBox(height: AppSpacing.md),
          // Nav items
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(
                horizontal: isCompact ? AppSpacing.xs : AppSpacing.md,
              ),
              itemCount: items.length,
              itemBuilder: (ctx, i) {
                final item = items[i];
                final selected = selectedIndex == i;
                return _SidebarNavItem(
                  item: item,
                  selected: selected,
                  isCompact: isCompact,
                  onTap: () => onItemTapped(i),
                );
              },
            ),
          ),
          // Logout
          Container(height: 1, color: Colors.white.withOpacity(0.06)),
          Padding(
            padding: EdgeInsets.fromLTRB(
              isCompact ? AppSpacing.xs : AppSpacing.md,
              AppSpacing.md,
              isCompact ? AppSpacing.xs : AppSpacing.md,
              AppSpacing.lg,
            ),
            child: _SidebarNavItem(
              item: SidebarItem(icon: Icons.logout_rounded, label: 'Logout'),
              selected: false,
              isCompact: isCompact,
              isLogout: true,
              onTap: () => Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SidebarNavItem extends StatefulWidget {
  final SidebarItem item;
  final bool selected;
  final bool isCompact;
  final bool isLogout;
  final VoidCallback onTap;

  const _SidebarNavItem({
    required this.item,
    required this.selected,
    required this.isCompact,
    required this.onTap,
    this.isLogout = false,
  });

  @override
  State<_SidebarNavItem> createState() => _SidebarNavItemState();
}

class _SidebarNavItemState extends State<_SidebarNavItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final color = widget.isLogout
        ? AppColors.error
        : (widget.selected
              ? AppColors.sidebarItemSelected
              : AppColors.sidebarItemText);

    return Tooltip(
      message: widget.isCompact ? widget.item.label : '',
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: AnimatedContainer(
          duration: AppAnimationDuration.normal,
          margin: EdgeInsets.only(bottom: AppSpacing.xs),
          decoration: BoxDecoration(
            color: widget.selected
                ? AppColors.sidebarItemSelected.withOpacity(0.12)
                : (_hovered
                      ? Colors.white.withOpacity(0.06)
                      : Colors.transparent),
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: widget.onTap,
              borderRadius: BorderRadius.circular(AppRadius.sm),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
                child: Row(
                  mainAxisAlignment: widget.isCompact
                      ? MainAxisAlignment.center
                      : MainAxisAlignment.start,
                  children: [
                    AnimatedContainer(
                      duration: AppAnimationDuration.normal,
                      padding: EdgeInsets.all(AppSpacing.xs),
                      decoration: BoxDecoration(
                        color: widget.selected
                            ? AppColors.sidebarItemSelected.withOpacity(0.18)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(AppRadius.badge),
                      ),
                      child: Icon(
                        widget.item.icon,
                        size: AppDimensions.iconSizeSmall,
                        color: color,
                      ),
                    ),
                    if (!widget.isCompact) ...[
                      SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Text(
                          widget.item.label,
                          style: GoogleFonts.inter(
                            fontSize: AppFontSize.md,
                            color: color,
                            fontWeight: widget.selected
                                ? FontWeight.w600
                                : FontWeight.w400,
                          ),
                        ),
                      ),
                      if (widget.selected) ...[
                        SizedBox(width: AppSpacing.sm),
                        Container(
                          width: 4,
                          height: 4,
                          decoration: const BoxDecoration(
                            color: AppColors.sidebarItemSelected,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SidebarItem {
  final IconData icon;
  final String label;
  SidebarItem({required this.icon, required this.label});
}
