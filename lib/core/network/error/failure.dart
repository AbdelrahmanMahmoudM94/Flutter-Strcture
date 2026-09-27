import 'package:equatable/equatable.dart';

import 'network_constant.dart';

class CacheFailure extends Failure {
  @override
  List<Object?> get props => <Object?>[];
}

abstract class Failure extends Equatable {
  const Failure();
}

class FailureToMassage {
  String mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return (failure as ServerFailure).message ??
            NetworkString.serverFailureMessage;
      case CacheFailure:
        return NetworkString.cacheFailureMessage;
      case NetworkFailure:
        return NetworkString.networkFailureMessage;
      default:
        return 'Unexpected error';
    }
  }
}

class NetworkFailure extends Failure {
  @override
  List<Object?> get props => <Object?>[];
}

class ServerFailure extends Failure {
  const ServerFailure({this.message});
  final String? message;
  @override
  List<Object?> get props => <Object?>[message];
}
