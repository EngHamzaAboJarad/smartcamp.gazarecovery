import 'package:equatable/equatable.dart';

abstract class AssistanceState extends Equatable {
  const AssistanceState();

  @override
  List<Object?> get props => [];
}

class AssistanceInitial extends AssistanceState {
  const AssistanceInitial();
}

class AssistanceLoading extends AssistanceState {
  const AssistanceLoading();
}

class AssistanceLoaded extends AssistanceState {
  final List<String> items;
  const AssistanceLoaded({required this.items});

  @override
  List<Object?> get props => [items];
}

class AssistanceError extends AssistanceState {
  final String message;
  const AssistanceError({required this.message});

  @override
  List<Object?> get props => [message];
}
