import 'package:equatable/equatable.dart';

abstract class TentsState extends Equatable {
  const TentsState();

  @override
  List<Object?> get props => [];
}

class TentsInitial extends TentsState {
  const TentsInitial();
}

class TentsLoading extends TentsState {
  const TentsLoading();
}

class TentsLoaded extends TentsState {
  final List<Map<String, dynamic>> tents;
  const TentsLoaded({required this.tents});

  @override
  List<Object?> get props => [tents];
}

class TentsError extends TentsState {
  final String message;
  const TentsError({required this.message});

  @override
  List<Object?> get props => [message];
}
