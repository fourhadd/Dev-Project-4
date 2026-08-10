// features/auth/data/repositories/auth_repository_impl.dart
import 'dart:convert';
import 'dart:math';
import '../../domain/exceptions/auth_exception.dart';
import '../models/user_model.dart';
import 'auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final Map<String, _StoredUser> _db = {};

  final Random _random = Random();

  Future<void> _simulateNetwork() async {
    await Future.delayed(const Duration(milliseconds: 700));
    if (_random.nextInt(100) < 8) throw const NetworkException();
  }

  String _generateFakeJwt(String userId) {
    String encode(Map<String, dynamic> m) =>
        base64Url.encode(utf8.encode(jsonEncode(m)));
    final header = encode({'alg': 'none', 'typ': 'JWT'});
    final payload =
        encode({'sub': userId, 'iat': DateTime.now().millisecondsSinceEpoch});
    final signature =
        base64Url.encode(List<int>.generate(16, (_) => _random.nextInt(256)));
    return '$header.$payload.$signature';
  }

  @override
  Future<AuthResult> login(
      {required String email, required String password}) async {
    await _simulateNetwork();
    final stored = _db[email.trim().toLowerCase()];
    if (stored == null || stored.password != password) {
      throw const WrongCredentialsException();
    }
    final model = UserModel(
        id: stored.id, name: stored.name, email: email.trim().toLowerCase());
    return AuthResult(
        token: _generateFakeJwt(model.id), user: model.toEntity());
  }

  @override
  Future<AuthResult> register({
    required String name,
    required String email,
    required String password,
  }) async {
    await _simulateNetwork();
    final key = email.trim().toLowerCase();
    if (_db.containsKey(key)) throw const EmailAlreadyInUseException();

    final id = 'u_${DateTime.now().millisecondsSinceEpoch}';
    _db[key] = _StoredUser(id: id, name: name.trim(), password: password);

    final model = UserModel(id: id, name: name.trim(), email: key);
    return AuthResult(token: _generateFakeJwt(id), user: model.toEntity());
  }

  @override
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 200));
  }
}

class _StoredUser {
  final String id;
  final String name;
  final String password;
  _StoredUser({required this.id, required this.name, required this.password});
}
