import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/repositories/auth_repository.dart';
import '../data/repositories/session_repository.dart';
import '../domain/exceptions/auth_exception.dart';
import 'auth_cubit.dart';
import 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final AuthRepository _authRepository;
  final SessionRepository _sessionRepository;
  final AuthCubit _authCubit;

  RegisterCubit({
    required AuthRepository authRepository,
    required SessionRepository sessionRepository,
    required AuthCubit authCubit,
  })  : _authRepository = authRepository,
        _sessionRepository = sessionRepository,
        _authCubit = authCubit,
        super(const RegisterInitial());

  Future<void> submit({required String name, required String email, required String password}) async {
    emit(const RegisterLoading());
    try {
      final result = await _authRepository.register(name: name, email: email, password: password);
      await _sessionRepository.save(token: result.token, user: result.user);
      _authCubit.setAuthenticated(user: result.user, token: result.token);
      emit(const RegisterSuccess());
    } on AuthException catch (e) {
      emit(RegisterFailure(e.message));
    } catch (_) {
      emit(const RegisterFailure('Something went wrong. Please try again.'));
    }
  }
}
