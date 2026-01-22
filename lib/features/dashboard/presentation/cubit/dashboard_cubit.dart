import 'package:flutter_bloc/flutter_bloc.dart';
import 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit() : super(const DashboardInitial());

  Future<void> loadDashboard() async {
    emit(const DashboardLoading());
    try {
      await Future.delayed(const Duration(seconds: 1));
      emit(const DashboardLoaded(stats: {'users': 120, 'tents': 35}));
    } catch (e) {
      emit(DashboardError(message: e.toString()));
    }
  }
}

