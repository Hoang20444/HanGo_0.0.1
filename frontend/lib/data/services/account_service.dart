import 'api_client.dart';

class Account {
  final int id;
  final String fullName;
  final String email;
  final String role;
  final bool active;
  final String? dateOfBirth;
  final String? gender;
  final String? address;
  final String? phoneNumber;

  const Account({
    required this.id,
    required this.fullName,
    required this.email,
    required this.role,
    required this.active,
    this.dateOfBirth,
    this.gender,
    this.address,
    this.phoneNumber,
  });

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      id: json['id'] as int,
      fullName: json['fullName'] as String,
      email: json['email'] as String,
      role: json['role'] as String,
      active: json['active'] as bool,
      dateOfBirth: json['dateOfBirth'] as String?,
      gender: json['gender'] as String?,
      address: json['address'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
    );
  }

  Map<String, dynamic> toJson({String? password}) {
    return {
      'fullName': fullName,
      'email': email,
      'role': role,
      'active': active,
      'dateOfBirth': dateOfBirth,
      'gender': gender,
      'address': address,
      'phoneNumber': phoneNumber,
      if (password != null && password.isNotEmpty) 'password': password,
    };
  }
}

class AccountService {
  final ApiClient _client;

  const AccountService({ApiClient client = const ApiClient()})
    : _client = client;

  Future<List<Account>> list({String? role, String? query}) async {
    final json = await _client.get(
      '/admin/accounts',
      query: {
        if (role != null && role.isNotEmpty) 'role': role,
        if (query != null && query.trim().isNotEmpty) 'q': query.trim(),
      },
    ) as List<dynamic>;
    return json
        .map((item) => Account.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<Account> create(Map<String, dynamic> payload) async {
    final json =
        await _client.post('/admin/accounts', payload) as Map<String, dynamic>;
    return Account.fromJson(json);
  }

  Future<Account> update(int id, Map<String, dynamic> payload) async {
    final json =
        await _client.put('/admin/accounts/$id', payload)
            as Map<String, dynamic>;
    return Account.fromJson(json);
  }

  Future<Account> updateStatus(int id, bool active) async {
    final json =
        await _client.patch('/admin/accounts/$id/status', {
              'active': active,
            })
            as Map<String, dynamic>;
    return Account.fromJson(json);
  }

  Future<void> delete(int id) async {
    await _client.delete('/admin/accounts/$id');
  }
}
