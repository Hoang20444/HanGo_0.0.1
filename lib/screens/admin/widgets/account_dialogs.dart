import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hango/theme/app_colors.dart';
import 'package:hango/widgets/shared_widgets.dart';

class CreateAccountDialog extends StatefulWidget {
  const CreateAccountDialog({super.key});

  @override
  State<CreateAccountDialog> createState() => _CreateAccountDialogState();
}

class _CreateAccountDialogState extends State<CreateAccountDialog> {
  int _gender = 0; // 0 = Male, 1 = Female

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Container(
        width: 800,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              decoration: const BoxDecoration(
                color: Color(0xFFF1F5F9), // Slate-100
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Text(
                'Create New Account',
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF334155),
                ),
              ),
            ),
            const Divider(height: 1, color: AppColors.border),
            // Form
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(child: _buildTextField('First Name')),
                        const SizedBox(width: 24),
                        Expanded(child: _buildTextField('Name')),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(child: _buildTextField('Email')),
                        const SizedBox(width: 24),
                        Expanded(
                          child: _buildTextField(
                            'Date of Birth',
                            hint: 'mm/dd/yyyy',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel('Gender'),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Radio<int>(
                                    value: 0,
                                    groupValue: _gender,
                                    onChanged: (v) =>
                                        setState(() => _gender = v!),
                                    activeColor: AppColors.primary,
                                  ),
                                  const Text('Male'),
                                  const SizedBox(width: 16),
                                  Radio<int>(
                                    value: 1,
                                    groupValue: _gender,
                                    onChanged: (v) =>
                                        setState(() => _gender = v!),
                                    activeColor: AppColors.primary,
                                  ),
                                  const Text('Female'),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 24),
                        Expanded(child: _buildTextField('Address')),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(child: _buildTextField('Phone Number')),
                        const SizedBox(width: 24),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel('Role'),
                              const SizedBox(height: 8),
                              DropdownButtonFormField<String>(
                                decoration: _inputDecoration(
                                  'Select user role',
                                ),
                                items: const [],
                                onChanged: (v) {},
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Actions
            Padding(
              padding: const EdgeInsets.all(32),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                      side: const BorderSide(color: AppColors.border),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      foregroundColor: AppColors.textSecondary,
                    ),
                    child: const Text('Back'),
                  ),
                  const SizedBox(width: 16),
                  TealButton(
                    label: 'Create',
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: GoogleFonts.ibmPlexMono(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: AppColors.textSecondary,
      ),
    );
  }

  Widget _buildTextField(String label, {String? hint}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label),
        const SizedBox(height: 8),
        TextField(decoration: _inputDecoration(hint)),
      ],
    );
  }

  InputDecoration _inputDecoration(String? hint) {
    return InputDecoration(
      hintText: hint,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.primary),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }
}

class AccountDetailDialog extends StatefulWidget {
  final Map<String, dynamic> user;
  const AccountDetailDialog({required this.user, super.key});

  @override
  State<AccountDetailDialog> createState() => _AccountDetailDialogState();
}

class _AccountDetailDialogState extends State<AccountDetailDialog> {
  int _gender = 1; // 0 = Male, 1 = Female
  bool _isActive = true;

  @override
  void initState() {
    super.initState();
    _isActive = widget.user['active'] ?? true;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Container(
        width: 800,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header Title Outside Border conceptually
            Padding(
              padding: const EdgeInsets.fromLTRB(32, 32, 32, 16),
              child: Text(
                '${widget.user['role']} Account Detail',
                style: GoogleFonts.inter(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1E293B), // Slate-800
                ),
              ),
            ),
            // Bordered Card Content
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.border),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Profile Header
                      Padding(
                        padding: const EdgeInsets.all(24),
                        child: Row(
                          children: [
                            Stack(
                              children: [
                                CircleAvatar(
                                  radius: 40,
                                  backgroundColor: const Color(0xFF1E293B),
                                  child: Text(
                                    widget.user['name'].substring(0, 1),
                                    style: const TextStyle(
                                      fontSize: 32,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: const BoxDecoration(
                                      color: AppColors.primary,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.edit,
                                      size: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 20),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.user['name'],
                                  style: GoogleFonts.inter(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF0F172A),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'ID: PS-29384-CC',
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // Form
                      Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: _buildTextField(
                                    'FullName',
                                    initialValue: widget.user['name'],
                                  ),
                                ),
                                const SizedBox(width: 24),
                                Expanded(
                                  child: _buildTextField(
                                    'Username',
                                    initialValue: widget.user['email'].split(
                                      '@',
                                    )[0],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildTextField(
                                    'Email',
                                    initialValue: widget.user['email'],
                                    prefixIcon: const Icon(
                                      Icons.email_outlined,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 24),
                                Expanded(
                                  child: _buildTextField(
                                    'Role',
                                    initialValue: widget.user['role'],
                                    readOnly: true,
                                    fillColor: const Color(0xFFF8FAFC),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: _buildTextField(
                                    'Date of Birth',
                                    initialValue: '28/04/2004',
                                  ),
                                ),
                                const SizedBox(width: 24),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _buildLabel('Gender'),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          Radio<int>(
                                            value: 1,
                                            groupValue: _gender,
                                            onChanged: (v) =>
                                                setState(() => _gender = v!),
                                            activeColor: AppColors.primary,
                                          ),
                                          const Text('Female'),
                                          const SizedBox(width: 16),
                                          Radio<int>(
                                            value: 0,
                                            groupValue: _gender,
                                            onChanged: (v) =>
                                                setState(() => _gender = v!),
                                            activeColor: AppColors.primary,
                                          ),
                                          const Text('Male'),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            _buildLabel('Account Status'),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                _buildStatusButton(
                                  'Active',
                                  true,
                                  Icons.check_circle_outline,
                                ),
                                const SizedBox(width: 12),
                                _buildStatusButton(
                                  'Inactive',
                                  false,
                                  Icons.cancel_outlined,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const Divider(height: 1, color: AppColors.border),
                      // Actions inside bordered card
                      Padding(
                        padding: const EdgeInsets.all(24),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton.icon(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.delete_outline,
                                color: AppColors.error,
                              ),
                              label: Text(
                                'Deactivate account',
                                style: GoogleFonts.inter(
                                  color: AppColors.error,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                OutlinedButton(
                                  onPressed: () => Navigator.pop(context),
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24,
                                      vertical: 16,
                                    ),
                                    side: const BorderSide(
                                      color: AppColors.primary,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    foregroundColor: AppColors.primary,
                                  ),
                                  child: const Text('Update'),
                                ),
                                const SizedBox(width: 12),
                                TealButton(
                                  label: 'Back',
                                  onPressed: () => Navigator.pop(context),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: const Color(0xFF64748B),
      ),
    );
  }

  Widget _buildTextField(
    String label, {
    String? initialValue,
    bool readOnly = false,
    Color? fillColor,
    Widget? prefixIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: initialValue,
          readOnly: readOnly,
          style: GoogleFonts.inter(
            color: readOnly ? const Color(0xFF0F172A) : const Color(0xFF334155),
            fontWeight: readOnly ? FontWeight.w600 : FontWeight.w400,
          ),
          decoration: InputDecoration(
            prefixIcon: prefixIcon,
            filled: fillColor != null,
            fillColor: fillColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: fillColor != null
                    ? Colors.transparent
                    : AppColors.border,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: readOnly ? Colors.transparent : AppColors.primary,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusButton(String label, bool isActive, IconData icon) {
    final isSelected = _isActive == isActive;
    return InkWell(
      onTap: () => setState(() => _isActive = isActive),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? (isActive ? const Color(0xFFECFDF5) : const Color(0xFFEEF2F6))
              : Colors.transparent,
          border: Border.all(
            color: isSelected
                ? (isActive ? AppColors.primary : const Color(0xFFCBD5E1))
                : AppColors.border,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected
                  ? (isActive ? AppColors.primary : const Color(0xFF475569))
                  : AppColors.textSecondary,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w600,
                color: isSelected
                    ? (isActive ? AppColors.primary : const Color(0xFF475569))
                    : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
