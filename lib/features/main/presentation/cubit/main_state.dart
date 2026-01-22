import 'package:equatable/equatable.dart';

abstract class MainState extends Equatable {
  const MainState();

  @override
  List<Object?> get props => [];
}

class MainInitial extends MainState {
  const MainInitial();
}

class MainTabChanged extends MainState {
  final int index;
  const MainTabChanged({required this.index});

  @override
  List<Object?> get props => [index];
}

class MainError extends MainState {
  final String message;
  const MainError({required this.message});

  @override
  List<Object?> get props => [message];
}

