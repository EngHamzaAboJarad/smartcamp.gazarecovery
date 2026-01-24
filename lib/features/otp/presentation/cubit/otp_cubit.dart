import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'otp_state.dart';
import 'package:smartcamp_gazarecovery/core/http_client.dart';
import 'package:smartcamp_gazarecovery/core/api_settings.dart';
import 'package:smartcamp_gazarecovery/features/login/data/models/data_user_model.dart';
import 'package:smartcamp_gazarecovery/core/prefs.dart';

class OtpCubit extends Cubit<OtpState> {
  OtpCubit() : super(const OtpInitial());
  DataUserModel? _dataUser;

  DataUserModel? get dataUser => _dataUser;

  Future<void> verifyOtp(String credential, String otp) async {
    emit(const OtpLoading());
    try {
      final response = await HttpClient.post(ApiSettings.verify_otp,
          data: {'credential': credential, 'otp': otp});
      final status = response.statusCode ?? 0;
      if (status >= 200 && status < 300) {
        // If server returned a token on verify, set it so profile call can use auth header
        String? token;
        if (response.data is Map) {
          token = response.data['token']?.toString() ?? response.data['access_token']?.toString();
        }
        if (token != null && token.isNotEmpty) {
          HttpClient.setAuthToken(token);
        }

        // Fetch profile from manager/profile
        try {
          final profileResp = await HttpClient.get(ApiSettings.profile);
          final pStatus = profileResp.statusCode ?? 0;
          if (pStatus >= 200 && pStatus < 300) {
            // Profile body usually under 'data'
            final profileBody = profileResp.data;
            Map<String, dynamic> userJson = {};
            if (profileBody is Map && profileBody['data'] != null) {
              final dyn = profileBody['data'];
              if (dyn is Map<String, dynamic>) userJson = dyn;
              else if (dyn is Map) userJson = Map<String, dynamic>.from(dyn);
            } else if (profileBody is Map) {
              userJson = Map<String, dynamic>.from(profileBody);
            }
            log('Profile User JSON: $userJson');
            // Build DataUserModel JSON compatible shape
            final dataUserJson = {
              'user': userJson,
              'token': token ?? '',
            };
            final dataUser = DataUserModel.fromJson(dataUserJson);
            log('dataUserdataUser:${dataUser.user.username}');
            // keep in-memory reference
            _dataUser = dataUser;

            // Persist user and mark as logged in
            try {
              await Prefs.saveUser(dataUser);
              await Prefs.setIsLogin(true);
            } catch (_) {
              // ignore persistence errors but continue
            }

             emit(OtpSuccess(data: {
              'message':  jsonEncode(response.data['message']),
             }));
            return;
          } else {
            String message = 'فشل جلب بيانات المستخدم';
            final pb = profileResp.data;
            if (pb is Map && pb['message'] != null) message = pb['message'].toString();
            emit(OtpError(message));
            return;
          }
        } on DioException catch (e) {
          String message = 'خطأ في جلب الملف الشخصي';
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
          emit(OtpError(message));
          return;
        }
      } else {
        String message = 'فشل التحقق';
        final data = response.data;
        if (data is Map && data['message'] != null) {
          message = data['message'].toString();
        }
        emit(OtpError(message));
      }
    } on DioException catch (e) {
      String message = 'خطأ في الشبكة';
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
      emit(OtpError(message));
    } catch (e) {
      emit(OtpError(e.toString()));
    }
  }

  Future<void> resendOtp(String credential) async {
    emit(const OtpLoading());
    try {
      final response = await HttpClient.post(ApiSettings.send_otp,
          data: {'credential': credential});
      final status = response.statusCode ?? 0;
      if (status >= 200 && status < 300) {
        emit(const OtpResendSuccess());
      } else {
        String message = 'فشل إعادة الإرسال';
        final data = response.data;
        if (data is Map && data['message'] != null) {
          message = data['message'].toString();
        }
        emit(OtpError(message));
      }
    } on DioException catch (e) {
      String message = 'خطأ في الشبكة';
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
      emit(OtpError(message));
    } catch (e) {
      emit(OtpError(e.toString()));
    }
  }
}
