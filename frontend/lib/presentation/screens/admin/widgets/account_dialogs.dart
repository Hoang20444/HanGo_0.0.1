import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../data/services/account_service.dart';
import '../../../theme/app_colors.dart';
import '../../../widgets/shared_widgets.dart';

const _roles = ['ADMIN', 'TRAINER', 'LEARNER'];

class CreateAccountDialog extends StatefulWidget {
  const CreateAccountDialog({super.key});

  @override
  State<CreateAccountDialog> createState() => _CreateAccountDialogState();
}

class _CreateAccountDialogState extends State<CreateAccountDialog> {
  final _fullNameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController(text: 'Password@123');
  final _dateOfBirthCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  String _role = 'LEARNER';
  String _gender = 'Male';
  bool _active = true;
  String? _errorMessage;

  @override
  void dispose() {
    _fullNameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _dateOfBirthCtrl.dispose();
    _addressCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  bool _isValidPhone(String raw) {
    final v = raw.trim();
    if (v.isEmpty) return true; // optional
    // E.164 basic: optional +, then 8-15 digits
    final regExp = RegExp(r'^\+?[1-9]\d{7,14}$');
    return regExp.hasMatch(v);
  }

  void _submit() {
    if (_fullNameCtrl.text.trim().isEmpty) {
      setState(() => _errorMessage = 'Please enter full name');
      return;
    }
    if (!_emailCtrl.text.contains('@')) {
      setState(() => _errorMessage = 'Please enter a valid email');
      return;
    }
    if (_passwordCtrl.text.length < 8) {
      setState(
        () => _errorMessage = 'Password must have at least 8 characters',
      );
      return;
    }
    if (!_isValidPhone(_phoneCtrl.text)) {
      setState(
        () => _errorMessage =
            'Phone number must be valid (E.164), e.g. +84912345678',
      );
      return;
    }

    Navigator.pop(context, {
      'fullName': _fullNameCtrl.text.trim(),
      'email': _emailCtrl.text.trim(),
      'password': _passwordCtrl.text,
      'role': _role,
      'active': _active,
      'dateOfBirth': _emptyToNull(_dateOfBirthCtrl.text),
      'gender': _gender,
      'address': _emptyToNull(_addressCtrl.text),
      'phoneNumber': _emptyToNull(_phoneCtrl.text),
    });
  }

  @override
  Widget build(BuildContext context) {
    return _AccountDialogShell(
      title: 'Create New Account',
      actions: [
        OutlinedButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Back'),
        ),
        TealButton(label: 'Create', onPressed: _submit),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ErrorMessage(message: _errorMessage),
          Row(
            children: [
              Expanded(child: _textField('Full Name', _fullNameCtrl)),
              const SizedBox(width: 20),
              Expanded(child: _textField('Email', _emailCtrl)),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(child: _textField('Password', _passwordCtrl)),
              const SizedBox(width: 20),
              Expanded(child: _roleDropdown()),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _textField(
                  'Date of Birth',
                  _dateOfBirthCtrl,
                  hint: 'yyyy-mm-dd',
                ),
              ),
              const SizedBox(width: 20),
              Expanded(child: _genderDropdown()),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(child: _textField('Address', _addressCtrl)),
              const SizedBox(width: 20),
              Expanded(child: _textField('Phone Number', _phoneCtrl)),
            ],
          ),
          const SizedBox(height: 20),
          SwitchListTile(
            value: _active,
            onChanged: (value) => setState(() => _active = value),
            contentPadding: EdgeInsets.zero,
            title: const Text('Active account'),
          ),
        ],
      ),
    );
  }

  Widget _roleDropdown() {
    return _labeled(
      'Role',
      DropdownButtonFormField<String>(
        initialValue: _role,
        decoration: _inputDecoration(),
        items: _roles
            .map(
              (role) =>
                  DropdownMenuItem(value: role, child: Text(_roleLabel(role))),
            )
            .toList(),
        onChanged: (value) => setState(() => _role = value ?? _role),
      ),
    );
  }

  Widget _genderDropdown() {
    return _labeled(
      'Gender',
      DropdownButtonFormField<String>(
        initialValue: _gender,
        decoration: _inputDecoration(),
        items: const [
          DropdownMenuItem(value: 'Male', child: Text('Male')),
          DropdownMenuItem(value: 'Female', child: Text('Female')),
          DropdownMenuItem(value: 'Other', child: Text('Other')),
        ],
        onChanged: (value) => setState(() => _gender = value ?? _gender),
      ),
    );
  }
}

class AccountDetailDialog extends StatefulWidget {
  final Account user;

  const AccountDetailDialog({required this.user, super.key});

  @override
  State<AccountDetailDialog> createState() => _AccountDetailDialogState();
}

class _AccountDetailDialogState extends State<AccountDetailDialog> {
  late final TextEditingController _fullNameCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _passwordCtrl;
  late final TextEditingController _dateOfBirthCtrl;
  late final TextEditingController _addressCtrl;
  late final TextEditingController _phoneCtrl;
  late String _role;
  late String _gender;
  late bool _active;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fullNameCtrl = TextEditingController(text: widget.user.fullName);
    _emailCtrl = TextEditingController(text: widget.user.email);
    _passwordCtrl = TextEditingController();
    _dateOfBirthCtrl = TextEditingController(
      text: widget.user.dateOfBirth ?? '',
    );
    _addressCtrl = TextEditingController(text: widget.user.address ?? '');
    _phoneCtrl = TextEditingController(text: widget.user.phoneNumber ?? '');
    _role = widget.user.role;
    _gender = widget.user.gender ?? 'Male';
    _active = widget.user.active;
  }

  @override
  void dispose() {
    _fullNameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _dateOfBirthCtrl.dispose();
    _addressCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  bool _isValidPhone(String raw) {
    final v = raw.trim();
    if (v.isEmpty) return true; // optional
    final regExp = RegExp(r'^\+?[1-9]\d{7,14}$');
    return regExp.hasMatch(v);
  }

  void _update() {
    if (_fullNameCtrl.text.trim().isEmpty) {
      setState(() => _errorMessage = 'Please enter full name');
      return;
    }
    if (!_emailCtrl.text.contains('@')) {
      setState(() => _errorMessage = 'Please enter a valid email');
      return;
    }
    if (_passwordCtrl.text.isNotEmpty && _passwordCtrl.text.length < 8) {
      setState(
        () => _errorMessage = 'New password must have at least 8 characters',
      );
      return;
    }
    if (!_isValidPhone(_phoneCtrl.text)) {
      setState(
        () => _errorMessage =
            'Phone number must be valid (E.164), e.g. +84912345678',
      );
      return;
    }

    Navigator.pop(context, {
      'action': 'update',
      'payload': {
        'fullName': _fullNameCtrl.text.trim(),
        'email': _emailCtrl.text.trim(),
        'password': _emptyToNull(_passwordCtrl.text),
        'role': _role,
        'active': _active,
        'dateOfBirth': _emptyToNull(_dateOfBirthCtrl.text),
        'gender': _gender,
        'address': _emptyToNull(_addressCtrl.text),
        'phoneNumber': _emptyToNull(_phoneCtrl.text),
      },
    });
  }

  Future<void> _confirmDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete account?'),
        content: Text('This will permanently delete ${widget.user.email}.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Delete',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      Navigator.pop(context, {'action': 'delete'});
    }
  }

  @override
  Widget build(BuildContext context) {
    return _AccountDialogShell(
      title: '${_roleLabel(widget.user.role)} Account Detail',
      actions: [
        TextButton.icon(
          onPressed: _confirmDelete,
          icon: const Icon(Icons.delete_outline, color: AppColors.error),
          label: const Text('Delete', style: TextStyle(color: AppColors.error)),
        ),
        const Spacer(),
        OutlinedButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Back'),
        ),
        TealButton(label: 'Update', onPressed: _update),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ErrorMessage(message: _errorMessage),
          Row(
            children: [
              CircleAvatar(
                radius: 34,
                backgroundColor: const Color(0xFF1E293B),
                child: Text(
                  widget.user.fullName.substring(0, 1).toUpperCase(),
                  style: const TextStyle(fontSize: 28, color: Colors.white),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.user.fullName,
                      style: GoogleFonts.inter(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      'ID: ${widget.user.id}',
                      style: GoogleFonts.inter(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(child: _textField('Full Name', _fullNameCtrl)),
              const SizedBox(width: 20),
              Expanded(child: _textField('Email', _emailCtrl)),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _textField(
                  'New Password',
                  _passwordCtrl,
                  hint: 'Leave blank to keep current password',
                ),
              ),
              const SizedBox(width: 20),
              Expanded(child: _roleDropdown()),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _textField(
                  'Date of Birth',
                  _dateOfBirthCtrl,
                  hint: 'yyyy-mm-dd',
                ),
              ),
              const SizedBox(width: 20),
              Expanded(child: _genderDropdown()),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(child: _textField('Address', _addressCtrl)),
              const SizedBox(width: 20),
              Expanded(child: _textField('Phone Number', _phoneCtrl)),
            ],
          ),
          const SizedBox(height: 20),
          SwitchListTile(
            value: _active,
            onChanged: (value) => setState(() => _active = value),
            contentPadding: EdgeInsets.zero,
            title: const Text('Active account'),
          ),
        ],
      ),
    );
  }

  Widget _roleDropdown() {
    return _labeled(
      'Role',
      DropdownButtonFormField<String>(
        initialValue: _role,
        decoration: _inputDecoration(),
        items: _roles
            .map(
              (role) =>
                  DropdownMenuItem(value: role, child: Text(_roleLabel(role))),
            )
            .toList(),
        onChanged: (value) => setState(() => _role = value ?? _role),
      ),
    );
  }

  Widget _genderDropdown() {
    return _labeled(
      'Gender',
      DropdownButtonFormField<String>(
        initialValue: _gender,
        decoration: _inputDecoration(),
        items: const [
          DropdownMenuItem(value: 'Male', child: Text('Male')),
          DropdownMenuItem(value: 'Female', child: Text('Female')),
          DropdownMenuItem(value: 'Other', child: Text('Other')),
        ],
        onChanged: (value) => setState(() => _gender = value ?? _gender),
      ),
    );
  }
}

class _AccountDialogShell extends StatelessWidget {
  final String title;
  final Widget child;
  final List<Widget> actions;

  const _AccountDialogShell({
    required this.title,
    required this.child,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 820),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 24, 28, 16),
              child: Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            const Divider(height: 1, color: AppColors.border),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(28),
                child: child,
              ),
            ),
            const Divider(height: 1, color: AppColors.border),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: actions
                    .map(
                      (action) => Padding(
                        padding: const EdgeInsets.only(left: 12),
                        child: action,
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorMessage extends StatelessWidget {
  final String? message;

  const _ErrorMessage({this.message});

  @override
  Widget build(BuildContext context) {
    if (message == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.error.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.error.withOpacity(0.3)),
        ),
        child: Text(
          message!,
          style: GoogleFonts.inter(fontSize: 13, color: AppColors.error),
        ),
      ),
    );
  }
}

Widget _textField(
  String label,
  TextEditingController controller, {
  String? hint,
}) {
  return _labeled(
    label,
    TextField(controller: controller, decoration: _inputDecoration(hint)),
  );
}

Widget _labeled(String label, Widget child) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppColors.textSecondary,
        ),
      ),
      const SizedBox(height: 8),
      child,
    ],
  );
}

InputDecoration _inputDecoration([String? hint]) {
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
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
  );
}

String _roleLabel(String role) => switch (role) {
  'ADMIN' => 'Admin',
  'TRAINER' => 'Trainer',
  _ => 'Learner',
};

String? _emptyToNull(String value) {
  final trimmed = value.trim();
  return trimmed.isEmpty ? null : trimmed;
}
