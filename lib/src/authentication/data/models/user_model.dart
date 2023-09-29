import 'dart:convert';
import 'package:tdd_tutorial/src/authentication/domain/entities/user.dart';
import 'package:tdd_tutorial/src/core/utils/typedef.dart';

class UserModel extends User {
  const UserModel(
      {required super.email, required super.name, required super.password});

  const UserModel.empty()
      : this(email: 'email@gmail.com', name: 'name', password: 'password');

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(jsonDecode(source) as DataMap);


  UserModel.fromMap(DataMap map)
      : this(
            name: map['data']['Name'] as String,
            email: map['data']["Email"] as String,
            password: 'password');

  DataMap toMap() => {'data':{'Name': name, "Email": email}, 'password': password};
  String toJson() => jsonEncode(toMap());

  UserModel copyWith({String? name, String? email, String? password}) =>
      UserModel(
          name: name ?? this.name,
          email: email ?? this.email,
          password: password ?? this.password);
}
