import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(const AuthInitial());

  // Simulated login flow
  Future<void> login({required String username, required String password}) async {
    emit(const AuthLoading());
    try {
      // simulate network delay
      await Future.delayed(const Duration(seconds: 1));

      // naive success condition for sample
      if (username == 'user' && password == 'password') {
        emit(const AuthSuccess(userId: 'user-1'));
      } else {
        emit(const AuthError(message: 'Invalid credentials'));
      }
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  void logout() => emit(const AuthInitial());
}

