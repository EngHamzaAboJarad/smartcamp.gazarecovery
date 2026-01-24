import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:smartcamp_gazarecovery/core/api_settings.dart';
import 'package:smartcamp_gazarecovery/core/http_client.dart';
import 'package:smartcamp_gazarecovery/core/dio_helper.dart';
import 'package:smartcamp_gazarecovery/features/login/data/models/data_user_model.dart';
import 'package:smartcamp_gazarecovery/shared/widgets/top_floating_message.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(const LoginInitial());

  final TextEditingController userController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  // Stores the parsed user+token object after successful login
  DataUserModel? userData;

  /// Submit login to the API endpoint `/login`.
  /// Request body: { "login": "+972...", "password": "..." }
  Future<void> submitLogin(context) async {
    final loginValue = userController.text.trim();

    if (loginValue.isEmpty ) {
      emit(const LoginError(message: 'Please enter login and password'));
      return;
    }

    emit(const LoginLoading());

    try {
      final response = await HttpClient.post(
        ApiSettings.send_otp,
        data: {
          'credential': loginValue,
        },
      );
      log('responsdddde = $response');
      final statusCode = response.statusCode ?? 0;
      final data = response.data;

      if (statusCode >= 200 && statusCode < 300) {
        showTopFloatingMessage(context, jsonEncode(data['message']));
        // Extract a readable message from the response (fallback to a default)
        emit(LoginSuccess(userphone: loginValue ));
      } else {
        // Try to read error message from response body
        String message = 'Login failed';
        if (data is Map && data['message'] != null) {
          message = data['message'].toString();
        }
        emit(LoginError(message: message));
      }
    } on DioException catch (e) {
      // Network or server error
      String message = 'Network error';
      if (e.response != null && e.response?.data != null) {
        final respData = e.response!.data;
        if (respData is Map && respData['message'] != null) {
          message = respData['message'].toString();
        } else if (e.message != null) {
          message = e.message!;
        }
      } else if (e.message != null) {
        message = e.message!;
      }
      emit(LoginError(message: message));
    } catch (e) {
      emit(LoginError(message: e.toString()));
    }
  }

  @override
  Future<void> close() async {
    userController.dispose();
    passController.dispose();
    await super.close();
  }
}
