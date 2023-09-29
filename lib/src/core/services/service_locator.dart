import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tdd_tutorial/src/authentication/data/authentication_repositories/authentication_repository_impl.dart';
import 'package:tdd_tutorial/src/authentication/data/data_source/auth_local_data_src.dart';
import 'package:tdd_tutorial/src/authentication/data/data_source/auth_remote_data_source.dart';
import 'package:tdd_tutorial/src/authentication/domain/repositories/authentication_repository.dart';
import 'package:tdd_tutorial/src/authentication/domain/usecase/cache_user_usecase.dart';
import 'package:tdd_tutorial/src/authentication/domain/usecase/get_cached_user_usecase.dart';
import 'package:tdd_tutorial/src/authentication/domain/usecase/login_user_usecase.dart';
import 'package:tdd_tutorial/src/authentication/domain/usecase/logout_user_usecase.dart';
import 'package:tdd_tutorial/src/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:tdd_tutorial/src/authentication/presentation/cubit/authentication_cubit.dart';
import 'package:http/http.dart' as http;

final sl = GetIt.instance;

Future<void> init() async {
  GetIt.instance.registerLazySingletonAsync<SharedPreferences>(
    () => SharedPreferences.getInstance(),
  );
  await GetIt.instance.isReady<SharedPreferences>();
  //bloc
  sl
    ..registerFactory(() => AuthenticationBloc(
        getUser: sl(), cacheUser: sl(), login: sl(), logout: sl()))

    //domain layer useCase
    ..registerLazySingleton(() => GetCachedUserUsecase(repository: sl()))
    ..registerLazySingleton(() => CacheUserUsecase(sl()))
    ..registerLazySingleton(() => LoginUserUsecase(repository: sl()))
    ..registerLazySingleton(() => LogoutUserUsecase(sl()))

    // data layer: Repo Implementation
    ..registerLazySingleton<AuthenticationRepository>(
        () => AuthRepoImpl(sl(), sl()))

    // Remote Data Src
    ..registerLazySingleton<AuthRemoteDataSrc>(
        () => AuthRemoteDataSrcImpl(sl()))
    ..registerLazySingleton(http.Client.new)
    ..registerLazySingleton<AuthLocalDataSrc>(() => AuthLocalDataSrcImpl(sl()))
    ..registerLazySingleton(() => SharedPreferences.getInstance());
}
