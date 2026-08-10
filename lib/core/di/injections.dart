// core/di/injections.dart
import 'package:get_it/get_it.dart';
import '../network/dio_client.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../features/auth/presentation/cubit/login_cubit.dart';
import '../../features/auth/presentation/cubit/register_cubit.dart';
import '../../features/auth/data/repositories/auth_repository.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/data/repositories/session_repository.dart';
import '../../features/auth/data/repositories/session_repository_impl.dart';
import '../../features/location/presentation/cubit/location_cubit.dart';
import '../../features/location/data/repositories/location_repository.dart';
import '../../features/location/data/repositories/location_repository_impl.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupInjections() async {
  getIt.registerLazySingleton<DioClient>(() => DioClient());

  getIt.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl());
  getIt.registerLazySingleton<SessionRepository>(() => SessionRepositoryImpl());
  getIt.registerLazySingleton<LocationRepository>(
      () => LocationRepositoryImpl());

  getIt.registerLazySingleton<AuthCubit>(
    () => AuthCubit(
        authRepository: getIt<AuthRepository>(),
        sessionRepository: getIt<SessionRepository>()),
  );

  getIt.registerFactory<LoginCubit>(
    () => LoginCubit(
      authRepository: getIt<AuthRepository>(),
      sessionRepository: getIt<SessionRepository>(),
      authCubit: getIt<AuthCubit>(),
    ),
  );

  getIt.registerFactory<RegisterCubit>(
    () => RegisterCubit(
      authRepository: getIt<AuthRepository>(),
      sessionRepository: getIt<SessionRepository>(),
      authCubit: getIt<AuthCubit>(),
    ),
  );

  getIt.registerFactory<LocationCubit>(
    () => LocationCubit(locationRepository: getIt<LocationRepository>()),
  );
}
