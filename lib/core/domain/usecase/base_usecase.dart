import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../error/failure.dart';

class NoParams extends Equatable {
  @override
  List<Object> get props => <Object>[];
}

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

abstract class UseCaseNoParam<Type> {
  Future<Either<Failure, Type>> call();
}

abstract class UseCaseWithoutEither<Type, Params> {
  Future<Type> call(Params params);
}

abstract class UseCaseWithoutEitherNoParm<Type> {
  Future<Type> call();
}

abstract class UseCaseWithoutEitherWithParm<Parm> {
  Future<void> call(Parm parms);
}
