import 'package:flutter/material.dart';
import 'package:hango/screens/admin/account_management_screen.dart';
import 'package:hango/screens/admin/dashboard_screen.dart';
import 'package:hango/screens/admin/role_management_screen.dart';
import 'package:hango/theme/app_colors.dart';
import 'package:hango/widgets/app_sidebar.dart';

class AdminLayout extends StatefulWidget {
  const AdminLayout({super.key});

  @override
  State<AdminLayout> createState() => _AdminLayoutState();
}

class _AdminLayoutState extends State<AdminLayout> {
  int _selectedIndex = 1; // Default to Account Management

  final List<Widget> _screens = [
    const AdminDashboardScreen(),
    const AccountManagementScreen(),
    const RoleManagementScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          AppSidebar(
            portalLabel: 'Admin Portal',
            items: [
              SidebarItem(icon: Icons.dashboard_rounded, label: 'Dashboard'),
              SidebarItem(icon: Icons.people_alt_rounded, label: 'Accounts'),
              SidebarItem(
                icon: Icons.security_rounded,
                label: 'Roles & Permissions',
              ),
            ],
            selectedIndex: _selectedIndex,
            onItemTapped: (i) => setState(() => _selectedIndex = i),
          ),
          Expanded(
            child: Container(
              color: AppColors.background,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (child, animation) => FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0.02, 0),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  ),
                ),
                child: KeyedSubtree(
                  key: ValueKey<int>(_selectedIndex),
                  child: _screens[_selectedIndex],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
