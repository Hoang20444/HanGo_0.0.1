import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hango/services/account_service.dart';
import 'package:hango/services/api_client.dart';
import 'package:hango/theme/app_colors.dart';
import 'package:hango/theme/app_design_system.dart';
import 'package:hango/widgets/shared_widgets.dart';
import 'package:hango/screens/admin/widgets/account_dialogs.dart';

class AccountManagementScreen extends StatefulWidget {
  const AccountManagementScreen({super.key});

  @override
  State<AccountManagementScreen> createState() =>
      _AccountManagementScreenState();
}

class _AccountManagementScreenState extends State<AccountManagementScreen> {
  final _accountService = const AccountService();

  final _searchCtrl = TextEditingController();
  final _roleCtrl =
      TextEditingController(); // not used; keeps layout stable if needed later

  Timer? _debounce;

  String? _selectedRole; // null = ALL
  List<Account> _accounts = [];
  bool _isLoading = false;
  String? _errorMessage;

  static const _roles = ['ALL', 'ADMIN', 'TRAINER', 'LEARNER'];

  @override
  void initState() {
    super.initState();
    _searchCtrl.addListener(_onSearchChanged);
    _loadAccounts(); // initial load (ALL)
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchCtrl.dispose();
    _roleCtrl.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () {
      _loadAccounts();
    });
  }

  Future<void> _loadAccounts() async {
    final query = _searchCtrl.text.trim();
    final role = _selectedRole;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final accounts = await _accountService.list(role: role, query: query);
      if (mounted) {
        setState(() => _accounts = accounts);
      }
    } on ApiException catch (error) {
      if (mounted) {
        setState(() => _errorMessage = error.message);
      }
    } catch (_) {
      if (mounted) {
        setState(() => _errorMessage = 'Cannot connect to the backend server');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _showUserDetailsDialog(Account user) async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => AccountDetailDialog(user: user),
    );
    if (result == null) return;

    try {
      if (result['action'] == 'delete') {
        await _accountService.delete(user.id);
      } else {
        await _accountService.update(user.id, result['payload']);
      }
      await _loadAccounts();
    } on ApiException catch (error) {
      _showError(error.message);
    } catch (_) {
      _showError('Cannot connect to the backend server');
    }
  }

  Future<void> _showCreateAccountDialog() async {
    final payload = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => const CreateAccountDialog(),
    );
    if (payload == null) return;

    try {
      await _accountService.create(payload);
      await _loadAccounts();
    } on ApiException catch (error) {
      _showError(error.message);
    } catch (_) {
      _showError('Cannot connect to the backend server');
    }
  }

  Future<void> _toggleStatus(Account user, bool active) async {
    try {
      await _accountService.updateStatus(user.id, active);
      await _loadAccounts();
    } on ApiException catch (error) {
      _showError(error.message);
    } catch (_) {
      _showError('Cannot connect to the backend server');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppColors.error),
    );
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
          ).animate().fadeIn(duration: 400.ms),
          const SizedBox(height: 24),
          // Single toolbar (filter + search + create)
          Container(
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColors.border)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Row(
                children: [
                  SizedBox(
                    width: 220,
                    height: 44,
                    child: DropdownButtonFormField<String>(
                      value: _selectedRole ?? 'ALL',
                      decoration: InputDecoration(
                        labelText: 'Role',
                        labelStyle: TextStyle(
                          color: AppColors.textSecondary.withOpacity(0.85),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppRadius.sm),
                          borderSide: const BorderSide(color: AppColors.border),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppRadius.sm),
                          borderSide: const BorderSide(color: AppColors.border),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppRadius.sm),
                          borderSide: const BorderSide(
                            color: AppColors.primary,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 0,
                        ),
                      ),
                      items: _roles
                          .map(
                            (r) => DropdownMenuItem(
                              value: r,
                              child: Text(r == 'ALL' ? 'All Roles' : r),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        final v = value == null ? 'ALL' : value;
                        _selectedRole = v == 'ALL' ? null : v;
                        _loadAccounts();
                      },
                    ),
                  ),
                  const SizedBox(width: AppSpacing.lg),
                  Expanded(
                    child: SizedBox(
                      height: 44,
                      child: TextField(
                        controller: _searchCtrl,
                        decoration: InputDecoration(
                          hintText: 'Search by name or email...',
                          hintStyle: TextStyle(
                            color: AppColors.textSecondary.withOpacity(0.7),
                          ),
                          prefixIcon: const Icon(
                            Icons.search,
                            color: AppColors.textSecondary,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppRadius.sm),
                            borderSide: const BorderSide(
                              color: AppColors.border,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppRadius.sm),
                            borderSide: const BorderSide(
                              color: AppColors.border,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppRadius.sm),
                            borderSide: const BorderSide(
                              color: AppColors.primary,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.lg),
                  TealButton(
                    label: 'Create',
                    icon: Icons.add,
                    onPressed: _showCreateAccountDialog,
                  ),
                ],
              ),
            ),
          ).animate().fadeIn(delay: 50.ms, duration: 400.ms),
          const SizedBox(height: 16),
          Expanded(
                child: AppCard(
                  padding: EdgeInsets.zero,
                  child: _buildTableArea(),
                ),
              )
              .animate()
              .fadeIn(delay: 100.ms, duration: 400.ms)
              .slideY(begin: 0.05, end: 0),
        ],
      ),
    );
  }

  Widget _buildTableArea() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Divider(height: 1, color: AppColors.border),
        Expanded(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _errorMessage != null
              ? Center(child: Text(_errorMessage!))
              : _buildTable(_accounts),
        ),
        PaginationRow(total: _accounts.length, showing: _accounts.length),
      ],
    );
  }

  Widget _buildTable(List<Account> users) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minWidth: constraints.maxWidth),
                    child: DataTable(
                      headingRowColor: WidgetStateProperty.all(
                        const Color(0xFFF0FDF4),
                      ), // light mint green
                      dataRowMaxHeight: 64,
                      dataRowMinHeight: 64,
                      headingTextStyle: GoogleFonts.inter(
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                        letterSpacing: 0.5,
                        color: AppColors.textPrimary,
                      ),
                      columns: const [
                        DataColumn(label: Text('NAME')),
                        DataColumn(label: Text('EMAIL')),
                        DataColumn(label: Text('ROLE')),
                        DataColumn(label: Text('ACTIVITY')),
                        DataColumn(label: Text('ACTION')),
                      ],
                      rows: users.map((u) {
                        return DataRow(
                          cells: [
                            DataCell(
                              Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: const Color(
                                      0xFFDBEAFE,
                                    ), // light blue
                                    child: Text(
                                      u.fullName
                                          .split(' ')
                                          .map((e) => e.toString()[0])
                                          .take(2)
                                          .join()
                                          .toUpperCase(),
                                      style: const TextStyle(
                                        color: Color(0xFF1E40AF), // dark blue
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    u.fullName,
                                    style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            DataCell(
                              Text(
                                u.email,
                                style: GoogleFonts.inter(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                            DataCell(
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(
                                    0xFFEDE9FE,
                                  ), // light purple
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Text(
                                  _roleLabel(u.role),
                                  style: GoogleFonts.inter(
                                    color: const Color(0xFF6D28D9), // purple
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            DataCell(
                              Switch(
                                value: u.active,
                                onChanged: (val) => _toggleStatus(u, val),
                                activeThumbColor: AppColors.surface,
                                activeTrackColor: AppColors.primary,
                                inactiveThumbColor: AppColors.surface,
                                inactiveTrackColor: AppColors.borderDark,
                              ),
                            ),
                            DataCell(
                              IconButton(
                                icon: const Icon(Icons.edit, size: 20),
                                color: AppColors.primary,
                                onPressed: () => _showUserDetailsDialog(u),
                                tooltip: 'Edit User',
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  String _roleLabel(String role) => switch (role) {
    'ADMIN' => 'Admin',
    'TRAINER' => 'Trainer',
    _ => 'Learner',
  };
}
