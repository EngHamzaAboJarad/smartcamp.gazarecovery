import 'package:flutter_bloc/flutter_bloc.dart';
import 'details_state.dart';

class DetailsCubit extends Cubit<DetailsState> {
  DetailsCubit() : super(const DetailsInitial());

  Future<void> loadDetails({required String id}) async {
    emit(const DetailsLoading());
    try {
      await Future.delayed(const Duration(milliseconds: 800));
      emit(DetailsLoaded(detail: {'id': id, 'name': 'Detail $id', 'info': 'Sample info'}));
    } catch (e) {
      emit(DetailsError(message: e.toString()));
    }
  }
}

