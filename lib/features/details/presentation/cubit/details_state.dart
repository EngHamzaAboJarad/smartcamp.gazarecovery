import 'package:equatable/equatable.dart';

abstract class DetailsState extends Equatable {
  const DetailsState();

  @override
  List<Object?> get props => [];
}

class DetailsInitial extends DetailsState {
  const DetailsInitial();
}

class DetailsLoading extends DetailsState {
  const DetailsLoading();
}

class DetailsLoaded extends DetailsState {
  final Map<String, dynamic> detail;
  const DetailsLoaded({required this.detail});

  @override
  List<Object?> get props => [detail];
}

class DetailsError extends DetailsState {
  final String message;
  const DetailsError({required this.message});

  @override
  List<Object?> get props => [message];
}

