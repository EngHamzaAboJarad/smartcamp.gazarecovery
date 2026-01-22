import 'package:flutter_bloc/flutter_bloc.dart';
import 'assistance_state.dart';

class AssistanceCubit extends Cubit<AssistanceState> {
  AssistanceCubit() : super(const AssistanceInitial());

  Future<void> loadAssistance() async {
    emit(const AssistanceLoading());
    try {
      await Future.delayed(const Duration(seconds: 1));
      emit(const AssistanceLoaded(items: ['Aid Center A', 'Aid Center B']));
    } catch (e) {
      emit(AssistanceError(message: e.toString()));
    }
  }
}

