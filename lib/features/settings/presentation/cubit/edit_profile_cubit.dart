import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:smartcamp_gazarecovery/core/http_client.dart';
import 'package:smartcamp_gazarecovery/core/api_settings.dart';
import 'edit_profile_state.dart';
import 'package:smartcamp_gazarecovery/features/login/data/models/data_user_model.dart';
import 'package:smartcamp_gazarecovery/core/prefs.dart';

class EditProfileCubit extends Cubit<EditProfileState> {
  EditProfileCubit() : super(const EditProfileInitial());

  Future<void> updateProfile({
    required String name,
    required String username,
    required String mobileNumber,
  }) async {
    emit(const EditProfileLoading());

    try {
      final response = await HttpClient.put(
        ApiSettings.profile,
        data: {
          'name': name,
          'username': username,
          'mobile_number': mobileNumber,
        },
      );

      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {

        final body = response.data as Map<String, dynamic>? ?? {};

        final userJson = Map<String, dynamic>.from(
          body['data'] ?? body,
        );

        final oldUser = await Prefs.getUser();
        final dataUser = DataUserModel.fromJson({
          'user': userJson,
          'token': oldUser?.token ?? '',
        });

        await Prefs.saveUser(dataUser);

        emit(EditProfileSuccess(
          dataUser: dataUser,
          message: body['message']?.toString(),
        ));
      } else {
        emit(EditProfileError(
          response.data?['message']?.toString() ?? 'فشل التحديث',
        ));
      }
    } on DioException catch (e) {
      emit(EditProfileError(
        e.response?.data?['message']?.toString() ??
            e.message ??
            'خطأ في الشبكة',
      ));
    } catch (e) {
      emit(EditProfileError(e.toString()));
    }
  }
}


