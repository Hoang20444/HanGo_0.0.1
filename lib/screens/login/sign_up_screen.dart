import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hango/screens/login/login_screen.dart';
import 'package:hango/theme/app_colors.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _fullNameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _agreeToTerms = false;
  bool _isLoading = false;
  String? _errorMessage;

  // Password requirements tracking
  bool _hasMinLength = false;
  bool _hasUppercase = false;
  bool _hasLowercase = false;
  bool _hasNumber = false;
  bool _hasSpecial = false;

  @override
  void initState() {
    super.initState();
    _passwordCtrl.addListener(_checkPasswordRequirements);
  }

  void _checkPasswordRequirements() {
    setState(() {
      final pass = _passwordCtrl.text;
      _hasMinLength = pass.length >= 8;
      _hasUppercase = pass.contains(RegExp(r'[A-Z]'));
      _hasLowercase = pass.contains(RegExp(r'[a-z]'));
      _hasNumber = pass.contains(RegExp(r'[0-9]'));
      _hasSpecial = pass.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    });
  }

  bool get _allRequirementsMet =>
      _hasMinLength &&
      _hasUppercase &&
      _hasLowercase &&
      _hasNumber &&
      _hasSpecial;

  bool get _passwordsMatch =>
      _passwordCtrl.text.isNotEmpty && _passwordCtrl.text == _confirmCtrl.text;

  @override
  void dispose() {
    _fullNameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    // Validation
    if (_fullNameCtrl.text.isEmpty) {
      setState(() => _errorMessage = 'Please enter your full name');
      return;
    }

    if (_emailCtrl.text.isEmpty || !_emailCtrl.text.contains('@')) {
      setState(() => _errorMessage = 'Please enter a valid email address');
      return;
    }

    if (!_allRequirementsMet) {
      setState(() => _errorMessage = 'Password does not meet all requirements');
      return;
    }

    if (!_passwordsMatch) {
      setState(() => _errorMessage = 'Passwords do not match');
      return;
    }

    if (!_agreeToTerms) {
      setState(
        () => _errorMessage = 'You must agree to the terms and policies',
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: Text(
            'Account Created',
            style: GoogleFonts.inter(fontWeight: FontWeight.w700),
          ),
          content: Text(
            'Your account has been created successfully. Please log in with your credentials.',
            style: GoogleFonts.inter(color: AppColors.textSecondary),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                );
              },
              child: const Text('Go to Login'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isMobile = w < 800;

    return Scaffold(
      body: isMobile ? _buildMobileLayout() : _buildDesktopLayout(),
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      children: [
        Expanded(
          flex: 5,
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF0D9488),
                  Color(0xFF0F766E),
                  Color(0xFF115E59),
                ],
              ),
            ),
            child: Stack(
              children: [
                Positioned(top: -60, left: -60, child: _circle(200, 0.08)),
                Positioned(bottom: -80, right: -40, child: _circle(280, 0.06)),
                Positioned(top: 120, right: 60, child: _circle(80, 0.1)),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(48),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Icon(
                            Icons.person_add_outlined,
                            size: 44,
                            color: Colors.white,
                          ),
                        ).animate().scale(
                          duration: 600.ms,
                          curve: Curves.elasticOut,
                        ),
                        const SizedBox(height: 28),
                        Text(
                              'Join HanGo Today',
                              style: GoogleFonts.inter(
                                fontSize: 32,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            )
                            .animate()
                            .fadeIn(delay: 200.ms, duration: 500.ms)
                            .slideY(begin: 0.2, end: 0),
                        const SizedBox(height: 12),
                        Text(
                          'Start your personalized English\nlearning journey with us today.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            color: Colors.white.withOpacity(0.8),
                            height: 1.5,
                          ),
                        ).animate().fadeIn(delay: 400.ms, duration: 500.ms),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 4,
          child: Container(
            color: Colors.white,
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 56),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: _buildForm(),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, AppColors.primaryDark],
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.person_add_outlined,
                  color: Colors.white,
                  size: 30,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Create Account',
                style: GoogleFonts.inter(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 32),
              _buildForm(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Create Your Account',
          style: GoogleFonts.inter(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Join millions learning English with HanGo',
          style: GoogleFonts.inter(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 24),

        // Full Name
        _label('Full Name'),
        const SizedBox(height: 6),
        TextField(
          controller: _fullNameCtrl,
          decoration: const InputDecoration(
            hintText: 'John Doe',
            prefixIcon: Icon(Icons.person_outline, size: 20),
          ),
        ),
        const SizedBox(height: 16),

        // Email
        _label('Email Address'),
        const SizedBox(height: 6),
        TextField(
          controller: _emailCtrl,
          decoration: const InputDecoration(
            hintText: 'you@example.com',
            prefixIcon: Icon(Icons.email_outlined, size: 20),
          ),
        ),
        const SizedBox(height: 16),

        // Password
        _label('Password'),
        const SizedBox(height: 6),
        TextField(
          controller: _passwordCtrl,
          obscureText: _obscurePassword,
          decoration: InputDecoration(
            hintText: 'Enter password',
            prefixIcon: const Icon(Icons.lock_outline, size: 20),
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                size: 20,
              ),
              onPressed: () =>
                  setState(() => _obscurePassword = !_obscurePassword),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Confirm Password
        _label('Confirm Password'),
        const SizedBox(height: 6),
        TextField(
          controller: _confirmCtrl,
          obscureText: _obscureConfirm,
          decoration: InputDecoration(
            hintText: 'Confirm password',
            prefixIcon: const Icon(Icons.lock_outline, size: 20),
            suffixIcon: IconButton(
              icon: Icon(
                _obscureConfirm
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                size: 20,
              ),
              onPressed: () =>
                  setState(() => _obscureConfirm = !_obscureConfirm),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Password requirements (compact)
        if (_passwordCtrl.text.isNotEmpty)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Password Requirements:',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                _buildSmallRequirement('8+ characters', _hasMinLength),
                _buildSmallRequirement('Uppercase (A-Z)', _hasUppercase),
                _buildSmallRequirement('Lowercase (a-z)', _hasLowercase),
                _buildSmallRequirement('Number (0-9)', _hasNumber),
                _buildSmallRequirement('Special char', _hasSpecial),
              ],
            ),
          ),
        const SizedBox(height: 16),

        // Error message
        if (_errorMessage != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.error.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 18,
                    color: AppColors.error,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _errorMessage!,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: AppColors.error,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

        // Terms & Policies
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.primarySurface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.primary.withOpacity(0.2)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 24,
                height: 24,
                child: Checkbox(
                  value: _agreeToTerms,
                  onChanged: (val) =>
                      setState(() => _agreeToTerms = val ?? false),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'I agree to HanGo\'s',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Row(
                      children: [
                        TextButton(
                          onPressed: () {
                            // Show terms dialog or navigate to terms page
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Terms of Service')),
                            );
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            'Terms of Service',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                        Text(
                          ', ',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Privacy Policy')),
                            );
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            'Privacy Policy',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                        Text(
                          ', and ',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('HanGo Policy')),
                            );
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            'HanGo Policy',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Sign Up button
        SizedBox(
          height: 48,
          child: ElevatedButton(
            onPressed:
                (_allRequirementsMet &&
                    _passwordsMatch &&
                    _agreeToTerms &&
                    !_isLoading)
                ? _signUp
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              disabledBackgroundColor: AppColors.primary.withOpacity(0.5),
            ),
            child: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      strokeWidth: 2,
                    ),
                  )
                : Text(
                    'Create Account',
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 20),

        // Back to login
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Already have an account? ",
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                'Sign In',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ],
    ).animate().fadeIn(duration: 400.ms).slideX(begin: 0.05, end: 0);
  }

  Widget _buildSmallRequirement(String text, bool isMet) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(
            isMet ? Icons.check_circle : Icons.radio_button_unchecked,
            size: 14,
            color: isMet ? AppColors.success : AppColors.textMuted,
          ),
          const SizedBox(width: 6),
          Text(
            text,
            style: GoogleFonts.inter(
              fontSize: 11,
              color: isMet ? AppColors.success : AppColors.textSecondary,
              fontWeight: isMet ? FontWeight.w500 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _label(String t) => Text(
    t,
    style: GoogleFonts.inter(
      fontSize: 13,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimary,
    ),
  );

  Widget _circle(double size, double opacity) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: Colors.white.withOpacity(opacity),
    ),
  );
}
