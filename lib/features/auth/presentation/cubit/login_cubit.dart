// features/auth/presentation/cubit/login_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/session_repository.dart';
import '../../domain/exceptions/auth_exception.dart';
import 'auth_cubit.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepository _authRepository;
  final SessionRepository _sessionRepository;
  final AuthCubit _authCubit;

  LoginCubit({
    required AuthRepository authRepository,
    required SessionRepository sessionRepository,
    required AuthCubit authCubit,
  })  : _authRepository = authRepository,
        _sessionRepository = sessionRepository,
        _authCubit = authCubit,
        super(const LoginInitial());

  Future<void> submit({required String email, required String password}) async {
    emit(const LoginLoading());
    try {
      final result = await _authRepository.login(email: email, password: password);
      await _sessionRepository.save(token: result.token, user: result.user);
      _authCubit.setAuthenticated(user: result.user, token: result.token);
      emit(const LoginSuccess());
    } on AuthException catch (e) {
      emit(LoginFailure(e.message));
    } catch (_) {
      emit(const LoginFailure('Something went wrong. Please try again.'));
    }
  }
}
