part of 'authentication_bloc.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();
  @override
  List<Object> get props => [];
}

class AuthenticationInitial extends AuthenticationState {
  @override
  List<Object> get props => [];
}

class LoadingState extends AuthenticationState {
  const LoadingState(this.message);
  final String message;
}

class LoginState extends AuthenticationState {}

class UserLoadedState extends AuthenticationState {
  const UserLoadedState(this.user);

  final User user;

  @override
  List<Object> get props => [user];
}

class GetCachedUserErrorState extends AuthenticationState{}

class AuthenticationErrorState extends AuthenticationState {
  const AuthenticationErrorState({required this.message});
  final String message;
  @override
  List<Object> get props => [message];
}

class LogoutUserState extends AuthenticationState {
  const LogoutUserState();
}
