import 'package:flutter_bloc/flutter_bloc.dart';
import 'tents_state.dart';

class TentsCubit extends Cubit<TentsState> {
  TentsCubit() : super(const TentsInitial());

  Future<void> loadTents() async {
    emit(const TentsLoading());
    try {
      await Future.delayed(const Duration(seconds: 1));
      emit(TentsLoaded(tents: [
        {'id': 't1', 'name': 'Tent 1'},
        {'id': 't2', 'name': 'Tent 2'},
      ]));
    } catch (e) {
      emit(TentsError(message: e.toString()));
    }
  }
}
