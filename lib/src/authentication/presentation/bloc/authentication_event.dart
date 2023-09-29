part of 'authentication_bloc.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object?> get props => [];
}

class CheckLoginEvent extends AuthenticationEvent {}

class NavigateToLogInScreenEvent extends AuthenticationEvent {}

class LoginUserEvent extends AuthenticationEvent {
  const LoginUserEvent({required this.email, required this.password});
  final String email;
  final String password;
}

class GetCachedUserEvent extends AuthenticationEvent {}

class CacheUserEvent extends AuthenticationEvent {
  const CacheUserEvent({required this.name, required this.email});

  final String name;
  final String email;
}


class LogoutUserEvent extends AuthenticationEvent {}
