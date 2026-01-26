import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:smartcamp_gazarecovery/core/http_client.dart';
import 'package:smartcamp_gazarecovery/core/dio_helper.dart';
import 'package:smartcamp_gazarecovery/features/login/data/models/data_user_model.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(const LoginInitial());

  final TextEditingController userController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  // Stores the parsed user+token object after successful login
  DataUserModel? userData;

  /// Submit login to the API endpoint `/login`.
  /// Request body: { "login": "+972...", "password": "..." }
  Future<void> submitLogin() async {
    final loginValue = userController.text.trim();
    final passwordValue = passController.text;

    if (loginValue.isEmpty || passwordValue.isEmpty) {
      emit(const LoginError(message: 'Please enter login and password'));
      return;
    }

    emit(const LoginLoading());

    try {
      final response = await HttpClient.post(
        'login',
        data: {
          'login': loginValue,
          'password': passwordValue,
        },
      );
      log('responsdddde = $response');
      final statusCode = response.statusCode ?? 0;
      final data = response.data;

      if (statusCode >= 200 && statusCode < 300) {
        // Parse into DataUserModel when possible and persist token
        DataUserModel? parsedModel;
        if (data is Map) {
          // API sometimes wraps the payload under a `data` key
          Map<String, dynamic> payload = Map<String, dynamic>.from(data);
          if (payload['data'] is Map) {
            payload = Map<String, dynamic>.from(payload['data']);
          }

          try {
            parsedModel = DataUserModel.fromJson(payload.cast<String, dynamic>());
          } catch (_) {
            // Try to construct from nested user/token keys manually
            try {
              final manual = <String, dynamic>{
                'user': payload['user'] ?? payload,
                'token': payload['token'] ?? payload['access_token'] ?? ''
              };
              parsedModel = DataUserModel.fromJson(manual.cast<String, dynamic>());
            } catch (_) {
              parsedModel = null;
            }
          }
        }

        // If parsing failed, create a minimal fallback model so UI can still receive user data
        if (parsedModel == null) {
          // attempt fallback extraction
          Map<String, dynamic> flat = {};
          if (data is Map) {
            if (data['data'] is Map) flat = Map<String, dynamic>.from(data['data']);
            else flat = Map<String, dynamic>.from(data);
          }
          final userMap = (flat['user'] is Map) ? Map<String, dynamic>.from(flat['user']) : {
            'id': flat['id'] ?? 0,
            'name': flat['name'] ?? loginValue,
            'username': flat['username'] ?? '',
            'identity_number': flat['identity_number'] ?? flat['identityNumber'] ?? '',
            'mobile_number': flat['mobile_number'] ?? flat['mobileNumber'] ?? loginValue,
            'email': flat['email'] ?? null,
            'created_at': flat['created_at'] ?? null,
            'updated_at': flat['updated_at'] ?? null,
          };
          final token = (flat['token'] ?? flat['access_token'] ?? '')?.toString() ?? '';
          parsedModel = DataUserModel(user: UserModel.fromJson(userMap), token: token);
        }

        // store and persist token
        userData = parsedModel;
        if (parsedModel.token.isNotEmpty) {
          await DioHelper.saveToken(parsedModel.token);
        }

        emit(LoginSuccess(userData: parsedModel));
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
