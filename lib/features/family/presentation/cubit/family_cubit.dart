import 'package:flutter_bloc/flutter_bloc.dart';
import 'family_state.dart';

class FamilyCubit extends Cubit<FamilyState> {
  FamilyCubit() : super(const FamilyInitial());

  Future<void> loadFamilies() async {
    emit(const FamilyLoading());
    try {
      await Future.delayed(const Duration(seconds: 1));
      emit(const FamilyLoaded(families: [
        {'id': 'f1', 'name': 'Family A'},
        {'id': 'f2', 'name': 'Family B'},
      ]));
    } catch (e) {
      emit(FamilyError(message: e.toString()));
    }
  }
}
