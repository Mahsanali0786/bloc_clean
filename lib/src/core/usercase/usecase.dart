import '../utils/typedef.dart';

abstract class UsecaseWithParams<Type,Params> {
  const UsecaseWithParams();
  @override
  ResultFuture<Type> call(Params params);

}
abstract class UsecaseWithoutParams<Type>{
  const UsecaseWithoutParams();
  ResultFuture<Type> call();

}