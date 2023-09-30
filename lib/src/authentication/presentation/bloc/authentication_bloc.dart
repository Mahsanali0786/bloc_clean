import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tdd_tutorial/src/authentication/domain/entities/user.dart';
import 'package:tdd_tutorial/src/authentication/domain/usecase/get_cached_user_usecase.dart';
import 'package:tdd_tutorial/src/authentication/domain/usecase/login_user_usecase.dart';
import 'package:tdd_tutorial/src/authentication/domain/usecase/logout_user_usecase.dart';
import '../../data/models/user_model.dart';
import '../../domain/usecase/cache_user_usecase.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final GetCachedUserUsecase getUser;
  final CacheUserUsecase cacheUser;
  final LoginUserUsecase login;
  final LogoutUserUsecase logout;
  AuthenticationBloc({
    required this.getUser,
    required this.cacheUser,
    required this.login,
    required this.logout,
  }) : super(AuthenticationInitial()) {
    on<GetCachedUserEvent>(_getCachedUserHandler);
    on<CacheUserEvent>(_cacheUserHandler);
    on<LoginUserEvent>(_loginUserHandler);
    on<LogoutUserEvent>(_logoutUserHandler);
  }

  Future<void> _getCachedUserHandler(
      GetCachedUserEvent event, Emitter<AuthenticationState> emit) async {
    emit(const LoadingState('Loading data'));

    final result = await getUser();

    //Either(failure,User)

    result.fold((failure) => emit(GetCachedUserErrorState()),
        (user) => emit(UserLoadedState(user)));
  }

  FutureOr<void> _cacheUserHandler(
      CacheUserEvent event, Emitter<AuthenticationState> emit) async {
    emit(const LoadingState('Logging In...'));

    final result =
        await cacheUser(CacheUserParams(name: event.name, email: event.email));

    result.fold(
        (failure) => emit(GetCachedUserErrorState()),
        (_) => emit(UserLoadedState(
            User(name: event.name, email: event.email, password: ''))));
  }

  FutureOr<void> _loginUserHandler(
      LoginUserEvent event, Emitter<AuthenticationState> emit) async {
    emit(const LoadingState('Logging In...'));
    final result = await login(
        LoginUserParams(email: event.email, password: event.password));

    result.fold(
        (failure) =>
            emit(AuthenticationErrorState(message: failure.getErrorMessage)),
        (user) {
      if (user == const UserModel.empty()) {
        return emit(const AuthenticationErrorState(message: 'invalid User'));
      } else {
        return emit(LoginState(user));
      }
    });
  }

  FutureOr<void> _logoutUserHandler(
      LogoutUserEvent event, Emitter<AuthenticationState> emit) async {
    emit(const LoadingState('Logout'));

    final result = await logout();

    result.fold(
        (failure) =>
            emit(AuthenticationErrorState(message: failure.getErrorMessage)),
        (_) => emit(const LogoutUserState()));
  }
}
