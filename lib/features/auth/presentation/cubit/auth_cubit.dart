// features/auth/presentation/cubit/auth_cubit.dart
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/session_repository.dart';
import '../../domain/entities/user.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;
  final SessionRepository _sessionRepository;

  AuthCubit(
      {required AuthRepository authRepository,
      required SessionRepository sessionRepository})
      : _authRepository = authRepository,
        _sessionRepository = sessionRepository,
        super(const AuthChecking()) {
    debugPrint(
        '[AUTH_CUBIT] created, state=AuthChecking, starting _restoreSession()');
    _restoreSession();
  }

  Future<void> _restoreSession() async {
    debugPrint('[AUTH_CUBIT] _restoreSession: reading saved session...');
    try {
      final saved = await _sessionRepository.read();
      debugPrint(
          '[AUTH_CUBIT] _restoreSession: read() returned -> ${saved == null ? 'null (no session)' : 'session found for ${saved.user.email}'}');
      if (saved != null) {
        emit(AuthAuthenticated(user: saved.user, token: saved.token));
        debugPrint('[AUTH_CUBIT] emitted AuthAuthenticated');
      } else {
        emit(const AuthUnauthenticated());
        debugPrint('[AUTH_CUBIT] emitted AuthUnauthenticated');
      }
    } catch (e, st) {
      debugPrint('[AUTH_CUBIT] _restoreSession FAILED with error: $e');
      debugPrint('$st');
      emit(const AuthUnauthenticated());
      debugPrint(
          '[AUTH_CUBIT] emitted AuthUnauthenticated (fallback after error)');
    }
  }

  void setAuthenticated({required User user, required String token}) {
    debugPrint('[AUTH_CUBIT] setAuthenticated called for ${user.email}');
    emit(AuthAuthenticated(user: user, token: token));
  }

  Future<void> logout() async {
    debugPrint('[AUTH_CUBIT] logout called');
    await _authRepository.logout();
    await _sessionRepository.clear();
    emit(const AuthUnauthenticated());
    debugPrint('[AUTH_CUBIT] emitted AuthUnauthenticated (after logout)');
  }
}
