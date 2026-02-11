import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:smartcamp_gazarecovery/features/assistance/presentation/cubit/assistance_cubit.dart';
import '../../../dashboard/data/models/dashboard_model.dart';
import 'dashboard_state.dart';
import 'package:smartcamp_gazarecovery/core/http_client.dart';
import 'package:smartcamp_gazarecovery/core/api_settings.dart';
import 'package:smartcamp_gazarecovery/core/prefs.dart';

class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit() : super(DashboardInitial());

  // Added: keep the last fetched DashboardModel inside the cubit so callers
  // can access it directly (e.g. `context.read<DashboardCubit>().currentDashboard`).
  DashboardModel? _dashboard;

  // Public getter to access the cached DashboardModel (nullable).
  DashboardModel? get currentDashboard => _dashboard;

  // Optional helper to clear cached dashboard data
  void clearDashboard() {
    _dashboard = null;
    emit(DashboardInitial());
  }

  Future<void> fetchDashboard() async {
    emit(DashboardLoading());
    try {
      final user = await Prefs.getUser();
      if (user?.token != null && user!.token.isNotEmpty) {
        HttpClient.setAuthToken(user.token);
      }

      final resp = await HttpClient.get(ApiSettings.home);
      final status = resp.statusCode ?? 0;
      if (status >= 200 && status < 300) {
        final body = resp.data;
        final Map<String, dynamic> jsonBody = (body is Map) ? Map<String, dynamic>.from(body) : {};
        final model = DashboardModel.fromJson(jsonBody);
        // store model in cubit so it can be accessed directly
        _dashboard = model;
        // NOTE: don't create other cubits here (outside the widget tree).
        // The Assistance screen should read DashboardCubit and call
        // `context.read<AssistanceCubit>().loadAssistance(...)` when it's ready.
        debugPrint('DashboardCubit: dashboard loaded, camp id=${_dashboard?.data?.id}');
        emit(DashboardLoaded(model));
      } else {
        String message = 'فشل جلب بيانات الداشبورد';
        if (resp.data is Map && resp.data['message'] != null) message = resp.data['message'].toString();
        emit(DashboardError(message));
      }
    } on DioException catch (e) {
      String message = 'خطأ في الشبكة';
      if (e.response != null && e.response?.data != null) {
        final respData = e.response!.data;
        if (respData is Map && respData['message'] != null) message = respData['message'].toString();
      } else if (e.message != null) {
        message = e.message!;
      }
      emit(DashboardError(message));
    } catch (e) {
      emit(DashboardError(e.toString()));
    }
  }
}
