part of 'splash_cubit.dart';
abstract class SplashState {}

class SplashInitialState extends SplashState {}


class SplashLoadingState extends SplashState {}

class SplashReadyState extends SplashState {}

class SplashErrorState extends SplashState {
  final String errorMessage;

  SplashErrorState(this.errorMessage);
}