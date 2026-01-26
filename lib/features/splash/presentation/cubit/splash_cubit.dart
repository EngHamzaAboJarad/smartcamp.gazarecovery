import 'package:flutter_bloc/flutter_bloc.dart';
import 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(const SplashInitial());

  Future<void> navigateAfterDelay() async {
    try {
      await Future.delayed(const Duration(seconds: 2));
      emit(const SplashNavigate());
    } catch (e) {
      emit(SplashError(message: e.toString()));
    }
  }
}

