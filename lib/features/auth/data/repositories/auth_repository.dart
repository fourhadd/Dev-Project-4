// features/auth/data/repositories/auth_repository.dart
import '../../domain/entities/user.dart';

class AuthResult {
  final String token;
  final User user;
  const AuthResult({required this.token, required this.user});
}

abstract class AuthRepository {
  Future<AuthResult> login({required String email, required String password});

  Future<AuthResult> register({
    required String name,
    required String email,
    required String password,
  });

  Future<void> logout();
}
