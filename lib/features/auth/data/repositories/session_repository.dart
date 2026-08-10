import '../../domain/entities/user.dart';

class SessionData {
  final String token;
  final User user;
  const SessionData({required this.token, required this.user});
}

abstract class SessionRepository {
  Future<void> save({required String token, required User user});
  Future<SessionData?> read();
  Future<void> clear();
}
