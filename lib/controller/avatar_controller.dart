import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SaveAvatarController with ChangeNotifier {
  List<List<String>> listAvatar = [];
  SharedPreferences? _prefs;

  Future<void> loadDataFromSharedPreferences() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      final avatarData = _prefs!.getStringList('avatar_data');
      print("load pref berhasil");

      if (avatarData != null) {
        listAvatar = avatarData.map((item) => item.split(',')).toList();
      }
    } catch (error) {
      print("Error in loadDataFromSharedPreferences: $error");
    }
  }

  Future<void> saveAvatar(List<String> avatar) async {
    try {
      for (var element in avatar) {
        print("str : $element");
      }
      listAvatar.add(avatar);

      print("size ${listAvatar.length}");
      final avatarData = listAvatar.map((item) => item.join(',')).toList();
      await _prefs!.setStringList('avatar_data', avatarData);
    } catch (error) {
      print("Error in saveAvatar: $error");
    }
  }

  Future<void> deleteAvatar(int index) async {
    try {
      listAvatar.removeAt(index);

      final avatarData = listAvatar.map((item) => item.join(',')).toList();
      await _prefs!.setStringList('avatar_data', avatarData);
    } catch (error) {
      print("Error in deleteAvatar: $error");
    }
  }
}
