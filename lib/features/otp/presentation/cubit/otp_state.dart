import 'package:equatable/equatable.dart';

abstract class OtpState extends Equatable {
  const OtpState();

  @override
  List<Object?> get props => [];
}

class OtpInitial extends OtpState {
  const OtpInitial();
}

class OtpLoading extends OtpState {
  const OtpLoading();
}

class OtpSuccess extends OtpState {
  final Map<String, dynamic>? data;
  const OtpSuccess({this.data});

  @override
  List<Object?> get props => [data];
}

class OtpResendSuccess extends OtpState {
  const OtpResendSuccess();
}

class OtpError extends OtpState {
  final String message;
  const OtpError(this.message);

  @override
  List<Object?> get props => [message];
}
