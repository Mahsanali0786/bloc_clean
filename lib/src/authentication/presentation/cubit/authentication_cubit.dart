import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecase/cache_user_usecase.dart';
import '../../domain/usecase/get_cached_user_usecase.dart';
import '../../domain/usecase/login_user_usecase.dart';
import '../../domain/usecase/logout_user_usecase.dart';

part 'authentication_state.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  final GetCachedUserUsecase getUser;
  final CacheUserUsecase cacheUser;
  final LoginUserUsecase login;
  final LogoutUserUsecase logout;
  AuthenticationCubit({
    required this.getUser,
    required this.cacheUser,
    required this.login,
    required this.logout,
  }) : super(AuthenticationInitial());


  // Future<void> createUser(
  //     {required String name,
  //     required String createdAt,
  //     required String avatar}) async {
  //   emit(CreatingUserState());
  //
  //   final result = await _createUser(
  //       Params(name: name, createdAt: createdAt, avatar: avatar));
  //
  //   result.fold(
  //       (failure) => emit(AuthenticationErrorState(failure.getErrorMessage)),
  //       (_) => emit(UserCreatedState()));
  // }
  //
  // Future<void> getUser() async {
  //   emit(GettingUserState());
  //
  //   final result = await _getUser();
  //
  //   result.fold(
  //       (failure) =>
  //           emit(GettingUserErrorState(message: failure.getErrorMessage)),
  //       (users) => emit(UserLoadedState(users)));
  // }
}
