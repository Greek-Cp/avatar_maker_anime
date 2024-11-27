import 'dart:convert';

import 'package:avatar_maker/model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static const _keyUser = 'user';

  Future<void> saveUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    final userData = user.toJson();
    prefs.setString(_keyUser, json.encode(userData));
  }

  Future<UserModel?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString(_keyUser);
    if (userData == null) return null;

    return UserModel.fromJson(json.decode(userData));
  }

  Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(_keyUser);
  }
}
