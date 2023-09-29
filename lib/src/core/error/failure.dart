import 'package:equatable/equatable.dart';
import 'package:tdd_tutorial/src/core/error/exception.dart';

abstract class Failure extends Equatable {
  final String errorMessage;
  final int statusCode;

  String get getErrorMessage => '$statusCode Error: $errorMessage';

  const Failure({required this.errorMessage, required this.statusCode});

  @override
  List<Object> get props => [errorMessage, statusCode];
}

class APIFailure extends Failure {
  const APIFailure({required super.errorMessage, required super.statusCode});

  APIFailure.fromException(ApiException exception)
      : this(errorMessage: exception.message, statusCode: exception.statusCode);
}

class LocalFailure extends Failure {
  const LocalFailure({required super.errorMessage, required super.statusCode});

  LocalFailure.fromException(LocalException exception)
      : this(errorMessage: exception.message, statusCode: exception.statusCode);
}
