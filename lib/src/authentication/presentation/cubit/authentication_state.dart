part of 'authentication_cubit.dart';


abstract class AuthenticationState extends Equatable {
  const AuthenticationState();
  @override
  List<Object> get props => [];
}

class AuthenticationInitial extends AuthenticationState {
  @override
  List<Object> get props => [];
}

class CachingUserState extends AuthenticationState {}

class GettingUserState extends AuthenticationState {}

class LoginState extends AuthenticationState {}

class UserLoggingState extends AuthenticationState {}

class UserLoadedState extends AuthenticationState {
  const UserLoadedState(this.user);

  final User user;

  @override
  List<Object> get props => [user];
}

class AuthenticationErrorState extends AuthenticationState {
  const AuthenticationErrorState({required this.message});
  final String message;
  @override
  List<Object> get props => [message];
}

class GettingUserErrorState extends AuthenticationState {
  const GettingUserErrorState({required this.message});
  final String message;
  @override
  List<Object> get props => [message];
}