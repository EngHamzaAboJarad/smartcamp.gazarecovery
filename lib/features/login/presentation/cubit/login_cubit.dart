import 'package:flutter_bloc/flutter_bloc.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(const LoginInitial());

  Future<void> submitLogin({required String username, required String password}) async {
    emit(const LoginLoading());
    try {
      await Future.delayed(const Duration(seconds: 1));
      if (username == 'user' && password == 'password') {
        emit(const LoginSuccess(userId: 'user-1'));
      } else {
        emit(const LoginError(message: 'Invalid credentials'));
      }
    } catch (e) {
      emit(LoginError(message: e.toString()));
    }
  }
}
