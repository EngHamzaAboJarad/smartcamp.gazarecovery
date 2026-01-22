import 'package:flutter_bloc/flutter_bloc.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(const HomeInitial());

  Future<void> loadItems() async {
    emit(const HomeLoading());
    try {
      await Future.delayed(const Duration(seconds: 1));
      // return sample data
      emit(const HomeLoaded(items: ['Tent A', 'Tent B', 'Tent C']));
    } catch (e) {
      emit(HomeError(message: e.toString()));
    }
  }
}

