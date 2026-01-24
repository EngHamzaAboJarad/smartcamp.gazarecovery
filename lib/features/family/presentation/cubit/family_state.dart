import 'package:equatable/equatable.dart';

abstract class FamilyState extends Equatable {
  const FamilyState();

  @override
  List<Object?> get props => [];
}

class FamilyInitial extends FamilyState {
  const FamilyInitial();
}

class FamilyLoading extends FamilyState {
  const FamilyLoading();
}

class FamilyLoaded extends FamilyState {
  final List<Map<String, dynamic>> families;
  const FamilyLoaded({required this.families});

  @override
  List<Object?> get props => [families];
}

class FamilyError extends FamilyState {
  final String message;
  const FamilyError({required this.message});

  @override
  List<Object?> get props => [message];
}


