import 'package:equatable/equatable.dart';
import '../../data/models/coming_helps_model.dart';

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
  final List<dynamic> items; // coming helps items (raw maps)
  final List<HelpTypeCount> helpTypeCounts; // aggregated types across pages
  final int totalTypes; // helpTypeCounts.length
  final int totalItems; // sum of counts across helpTypeCounts

  const AssistanceLoaded({required this.items, required this.helpTypeCounts, required this.totalTypes, required this.totalItems});

  @override
  List<Object?> get props => [items, helpTypeCounts, totalTypes, totalItems];
}

class AssistanceError extends AssistanceState {
  final String message;
  const AssistanceError({required this.message});

  @override
  List<Object?> get props => [message];
}
