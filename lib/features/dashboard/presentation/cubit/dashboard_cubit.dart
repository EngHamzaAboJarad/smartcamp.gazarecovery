import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import '../../../dashboard/data/models/dashboard_model.dart';
import 'dashboard_state.dart';
import 'package:smartcamp_gazarecovery/core/http_client.dart';
import 'package:smartcamp_gazarecovery/core/api_settings.dart';
import 'package:smartcamp_gazarecovery/core/prefs.dart';

class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit() : super(DashboardInitial());

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

