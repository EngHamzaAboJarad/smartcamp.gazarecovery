import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartcamp_gazarecovery/features/login/data/models/data_user_model.dart';

class Prefs {
  static const _kUser = 'user_data';
  static const _kIsLogin = 'is_login';

  static Future<void> saveUser(DataUserModel user) async {
    final sp = await SharedPreferences.getInstance();
    try {
      await sp.setString(_kUser, jsonEncode(user.toJson()));
    } catch (_) {
      // ignore write errors
    }
  }

  static Future<DataUserModel?> getUser() async {
    final sp = await SharedPreferences.getInstance();
    final s = sp.getString(_kUser);
    if (s == null) return null;
    try {
      final Map<String, dynamic> json = jsonDecode(s) as Map<String, dynamic>;
      return DataUserModel.fromJson(json);
    } catch (_) {
      return null;
    }
  }

  static Future<void> setIsLogin(bool value) async {
    final sp = await SharedPreferences.getInstance();
    try {
      await sp.setBool(_kIsLogin, value);
    } catch (_) {}
  }

  static Future<bool> isLoggedIn() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getBool(_kIsLogin) ?? false;
  }

  static Future<void> clear() async {
    final sp = await SharedPreferences.getInstance();
    await sp.remove(_kUser);
    await sp.remove(_kIsLogin);
  }
}

