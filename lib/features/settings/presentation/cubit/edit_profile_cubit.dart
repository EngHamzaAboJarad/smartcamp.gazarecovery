import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:smartcamp_gazarecovery/core/http_client.dart';
import 'package:smartcamp_gazarecovery/core/api_settings.dart';
import 'package:smartcamp_gazarecovery/features/settings/presentation/cubit/edit_profile_state.dart';
import 'package:smartcamp_gazarecovery/features/login/data/models/data_user_model.dart';
import 'package:smartcamp_gazarecovery/core/prefs.dart';

class EditProfileCubit extends Cubit<EditProfileState> {
  // Expose TextEditingControllers so UI can bind directly to the cubit
  final TextEditingController nameController = TextEditingController(text: '');
  final TextEditingController emailController = TextEditingController(text: '');
  final TextEditingController phoneController = TextEditingController(text: '');
  final TextEditingController passwordController = TextEditingController(text: '');
  final TextEditingController usernameController = TextEditingController(text: '');

  // Form key moved into the cubit so UI can use it
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  EditProfileCubit() : super(const EditProfileInitial());

  Future<void> loadProfile() async {
    try {
      final user = await Prefs.getUser();
      // populate controllers with local data (if any)
      if (user != null) {
        final u = user.user;
        nameController.text = u.name.isNotEmpty ? u.name : nameController.text;
        if (u.email != null && u.email!.isNotEmpty) emailController.text = u.email!;
        phoneController.text = u.mobileNumber.isNotEmpty ? u.mobileNumber : phoneController.text;
        usernameController.text = u.username.isNotEmpty ? u.username : generateUsername(u.name);
      } else {
        usernameController.text = generateUsername(nameController.text);
      }
      emit(EditProfileLoaded(user));
    } catch (_) {
      usernameController.text = generateUsername(nameController.text);
      emit(const EditProfileLoaded(null));
    }
  }

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

        // Emit success and also update loaded state so UI can reflect saved data.
        emit(EditProfileSuccess(
          dataUser: dataUser,
          message: body['message']?.toString(),
        ));

        // Emit loaded with the latest data (consumers can react if needed)
        // update controllers with latest data before emitting loaded
        try {
          final u = dataUser.user;
          nameController.text = u.name.isNotEmpty ? u.name : nameController.text;
          if (u.email != null && u.email!.isNotEmpty) emailController.text = u.email!;
          phoneController.text = u.mobileNumber.isNotEmpty ? u.mobileNumber : phoneController.text;
          usernameController.text = u.username.isNotEmpty ? u.username : generateUsername(u.name);
        } catch (_) {}
        emit(EditProfileLoaded(dataUser));
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

  /// Helper to create a username from a name (same logic as UI used previously)
  String generateUsername(String name) {
    final n = name.trim().toLowerCase();
    if (n.isEmpty) return 'manager';
    return n.replaceAll(RegExp(r'[^a-z0-9]+'), '-');
  }

  /// Return the standard input decoration used across the edit profile screen
  InputDecoration inputDecoration() {
    return InputDecoration(
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      border: InputBorder.none,
      hintStyle: const TextStyle(color: Colors.white38),
    );
  }

  @override
  Future<void> close() {
    // Dispose controllers when cubit is closed
    try {
      nameController.dispose();
      emailController.dispose();
      phoneController.dispose();
      passwordController.dispose();
      usernameController.dispose();
    } catch (_) {}
    return super.close();
  }
}