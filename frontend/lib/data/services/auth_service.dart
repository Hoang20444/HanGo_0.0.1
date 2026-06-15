import 'api_client.dart';

class AuthUser {
  final int id;
  final String fullName;
  final String email;
  final String role;
  final bool active;

  const AuthUser({
    required this.id,
    required this.fullName,
    required this.email,
    required this.role,
    required this.active,
  });

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    return AuthUser(
      id: json['id'] as int,
      fullName: json['fullName'] as String,
      email: json['email'] as String,
      role: json['role'] as String,
      active: json['active'] as bool,
    );
  }
}

class AuthService {
  final ApiClient _client;

  const AuthService({ApiClient client = const ApiClient()}) : _client = client;

  Future<AuthUser> login({
    required String email,
    required String password,
  }) async {
    final json =
        await _client.post('/auth/login', {
              'email': email.trim(),
              'password': password,
            })
            as Map<String, dynamic>;
    return AuthUser.fromJson(json);
  }

  Future<AuthUser> register({
    required String fullName,
    required String email,
    required String password,
    String role = 'LEARNER',
  }) async {
    final json =
        await _client.post('/auth/register', {
              'fullName': fullName.trim(),
              'email': email.trim(),
              'password': password,
              'role': role,
            })
            as Map<String, dynamic>;
    return AuthUser.fromJson(json);
  }

  Future<AuthUser> googleLogin({
    required String email,
    required String fullName,
    required String googleId,
  }) async {
    final json =
        await _client.post('/auth/google-login', {
              'email': email.trim(),
              'fullName': fullName.trim(),
              'googleId': googleId,
            })
            as Map<String, dynamic>;
    return AuthUser.fromJson(json);
  }

  Future<void> sendForgotPasswordOtp(String email) async {
    await _client.post('/auth/forgot-password', {'email': email.trim()});
  }

  Future<void> verifyOtp({required String email, required String otp}) async {
    await _client.post('/auth/verify-otp', {
      'email': email.trim(),
      'otp': otp.trim(),
    });
  }

  Future<void> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    await _client.post('/auth/reset-password', {
      'email': email.trim(),
      'otp': otp.trim(),
      'newPassword': newPassword,
    });
  }
}
