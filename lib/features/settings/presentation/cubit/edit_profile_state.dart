import 'package:equatable/equatable.dart';
import 'package:smartcamp_gazarecovery/features/login/data/models/data_user_model.dart';

abstract class EditProfileState extends Equatable {
  const EditProfileState();
  @override
  List<Object?> get props => [];
}

class EditProfileInitial extends EditProfileState {
  const EditProfileInitial();
}

class EditProfileLoading extends EditProfileState {
  const EditProfileLoading();
}

class EditProfileSuccess extends EditProfileState {
  final DataUserModel dataUser;
  final String? message;
  const EditProfileSuccess({required this.dataUser, this.message});

  @override
  List<Object?> get props => [dataUser, message];
}

class EditProfileError extends EditProfileState {
  final String message;
  const EditProfileError(this.message);

  @override
  List<Object?> get props => [message];
}

