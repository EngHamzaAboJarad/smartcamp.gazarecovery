import 'package:equatable/equatable.dart';
import 'package:smartcamp_gazarecovery/features/login/data/models/data_user_model.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object?> get props => [];
}

class LoginInitial extends LoginState {
  const LoginInitial();
}

class LoginLoading extends LoginState {
  const LoginLoading();
}

class LoginSuccess extends LoginState {
  final String userphone;
  const LoginSuccess({required this.userphone});

  @override
  List<Object?> get props => [userphone];
}

class LoginError extends LoginState {
  final String message;
  const LoginError({required this.message});

  @override
  List<Object?> get props => [message];
}
