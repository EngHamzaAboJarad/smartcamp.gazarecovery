import 'package:equatable/equatable.dart';

abstract class SplashState extends Equatable {
  const SplashState();

  @override
  List<Object?> get props => [];
}

class SplashInitial extends SplashState {
  const SplashInitial();
}

class SplashNavigate extends SplashState {
  const SplashNavigate();
}

class SplashError extends SplashState {
  final String message;
  const SplashError({required this.message});

  @override
  List<Object?> get props => [message];
}

