import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hango/theme/app_colors.dart';
import 'package:hango/theme/app_design_system.dart';
import 'package:hango/widgets/shared_widgets.dart';

class AccountManagementScreen extends StatefulWidget {
  const AccountManagementScreen({super.key});

  @override
  State<AccountManagementScreen> createState() =>
      _AccountManagementScreenState();
}

class _AccountManagementScreenState extends State<AccountManagementScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, dynamic>> _trainers = [
    {
      'name': 'John Doe',
      'email': 'john.trainer@hango.com',
      'role': 'Trainer',
      'active': true,
    },
    {
      'name': 'Sarah Smith',
      'email': 'sarah.s@hango.com',
      'role': 'Trainer',
      'active': true,
    },
  ];

  final List<Map<String, dynamic>> _trainees = [
    {
      'name': 'Mike Johnson',
      'email': 'mike.j@example.com',
      'role': 'Learner',
      'active': true,
    },
    {
      'name': 'Emma Wilson',
      'email': 'emma.w@example.com',
      'role': 'Learner',
      'active': false,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showUserDetailsDialog() {
    // Premium dialog implementation...
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PageHeader(
            title: 'Account Management',
            subtitle: 'Manage all users across the platform',
            actions: [
              TealButton(
                label: 'Create User',
                icon: Icons.add,
                onPressed: () {},
              ),
            ],
          ).animate().fadeIn(duration: 400.ms),
          const SizedBox(height: 32),
          Expanded(
                child: AppCard(
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: [
                      // Tabs
                      Container(
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: AppColors.border),
                          ),
                        ),
                        child: TabBar(
                          controller: _tabController,
                          labelColor: AppColors.primary,
                          unselectedLabelColor: AppColors.textSecondary,
                          indicatorColor: AppColors.primary,
                          indicatorWeight: 3,
                          labelStyle: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                          ),
                          tabs: const [
                            Tab(text: 'Trainers'),
                            Tab(text: 'Trainees (Learners)'),
                          ],
                        ),
                      ),
                      // Tab Views
                      Expanded(
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            _buildTable(_trainers),
                            _buildTable(_trainees),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
              .animate()
              .fadeIn(delay: 100.ms, duration: 400.ms)
              .slideY(begin: 0.05, end: 0),
        ],
      ),
    );
  }

  Widget _buildTable(List<Map<String, dynamic>> users) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: DataTable(
              headingRowColor: WidgetStateProperty.all(AppColors.background),
              dataRowMaxHeight: 64,
              dataRowMinHeight: 64,
              headingTextStyle: GoogleFonts.inter(
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
              columns: const [
                DataColumn(label: Text('User')),
                DataColumn(label: Text('Email')),
                DataColumn(label: Text('Role')),
                DataColumn(label: Text('Status')),
                DataColumn(label: Text('Actions')),
              ],
              rows: users.map((u) {
                return DataRow(
                  cells: [
                    DataCell(
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: AppColors.primaryLight.withOpacity(
                              0.2,
                            ),
                            child: Text(
                              u['name'][0],
                              style: const TextStyle(
                                color: AppColors.primaryDark,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            u['name'],
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w500,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    DataCell(
                      Text(
                        u['email'],
                        style: GoogleFonts.inter(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                    DataCell(
                      StatusBadge(label: u['role'], color: AppColors.info),
                    ),
                    DataCell(
                      StatusBadge(
                        label: u['active'] ? 'Active' : 'Inactive',
                        color: u['active']
                            ? AppColors.success
                            : AppColors.error,
                      ),
                    ),
                    DataCell(
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit_outlined, size: 18),
                            color: AppColors.textSecondary,
                            onPressed: _showUserDetailsDialog,
                            tooltip: 'Edit User',
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline, size: 18),
                            color: AppColors.error,
                            onPressed: () {},
                            tooltip: 'Delete User',
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
        PaginationRow(total: users.length, showing: users.length),
      ],
    );
  }
}
