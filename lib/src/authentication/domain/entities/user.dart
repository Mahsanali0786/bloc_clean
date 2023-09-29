import 'package:equatable/equatable.dart';

class User extends Equatable {
  const User({required this.name, required this.email, required this.password});

  const User.emptyUser():this(name: 'name',email: 'email@gmail.com',password: 'password');

  final String name;
  final String email;
  final String password;

  @override
  List<Object?> get props => [name, email];
}
