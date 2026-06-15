import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';
import '../theme/app_design_system.dart';
import '../screens/login/login_screen.dart';

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
      decoration: const BoxDecoration(
        color: AppColors.sidebarBg,
        border: Border(right: BorderSide(color: AppColors.border)),
      ),
      child: Column(
        children: [
          // Logo area
          Container(
            padding: EdgeInsets.fromLTRB(
              isCompact ? AppSpacing.sm : AppSpacing.xl,
              AppSpacing.sm,
              isCompact ? AppSpacing.sm : AppSpacing.xl,
              AppSpacing.sm,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: isCompact
                      ? MainAxisAlignment.center
                      : MainAxisAlignment.start,
                  children: [
                    Image.asset(
                      'assets/images/logo.png',
                      width: isCompact ? 34 : 140,
                      fit: BoxFit.contain,
                    ),
                  ],
                ),
                if (!isCompact) ...[
                  const SizedBox(height: 6),
                  Text(
                    portalLabel,
                    style: GoogleFonts.inter(
                      color: AppColors.textSecondary,
                      fontSize: AppFontSize.sm,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ],
            ),
          ),
          Container(height: 1, color: AppColors.border),
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
          Container(height: 1, color: AppColors.border),
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
              ? const Color.fromARGB(255, 255, 255, 255)
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
                ? const Color.fromARGB(146, 11, 186, 165).withOpacity(1)
                : (_hovered
                      ? const Color.fromARGB(255, 1, 204, 72).withOpacity(0.08)
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
                            ? const Color.fromARGB(
                                255,
                                130,
                                207,
                                183,
                              ).withOpacity(0.18)
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
                            color: Color.fromARGB(255, 153, 240, 205),
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
