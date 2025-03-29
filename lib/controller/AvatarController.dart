import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

class SaveAvatarController extends GetxController {
  RxList<List<String>> listAvatar = <List<String>>[].obs;
  SharedPreferences? _prefs;
  final RxBool isLoading = false.obs;

  // Untuk menyimpan avatar yang sedang diedit
  RxList<String> currentEditingAvatar = <String>[].obs;
  RxInt editingIndex = RxInt(-1);

  @override
  void onInit() {
    super.onInit();
    loadDataFromSharedPreferences();
  }

  Future<void> loadDataFromSharedPreferences() async {
    try {
      isLoading.value = true;
      _prefs = await SharedPreferences.getInstance();
      final avatarData = _prefs!.getStringList('avatar_data');
      print("Load preferences successful");

      if (avatarData != null) {
        listAvatar.value = avatarData.map((item) => item.split(',')).toList();
        update();
      }
    } catch (error) {
      print("Error in loadDataFromSharedPreferences: $error");
      Get.snackbar(
        "Error Loading Data",
        "There was a problem loading your saved avatars.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> saveAvatar(List<String> avatar) async {
    try {
      // Log all asset paths for debugging
      avatar.forEach((element) {
        print("Asset path: $element");
      });

      // Add new avatar to the list
      listAvatar.add(avatar);
      update();

      print("Total avatars: ${listAvatar.length}");

      // Convert list to format suitable for SharedPreferences
      final avatarData = listAvatar.map((item) => item.join(',')).toList();

      // Store in SharedPreferences
      _prefs ??= await SharedPreferences.getInstance();
      await _prefs!.setStringList('avatar_data', avatarData);

      Get.snackbar(
        "Avatar Saved",
        "Your avatar has been saved successfully!",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green[100],
        colorText: Colors.green[800],
        duration: Duration(seconds: 2),
      );
    } catch (error) {
      print("Error in saveAvatar: $error");
      Get.snackbar(
        "Save Failed",
        "There was a problem saving your avatar.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
      );
    }
  }

  Future<void> deleteAvatar(int index) async {
    try {
      if (index >= 0 && index < listAvatar.length) {
        listAvatar.removeAt(index);
        update();

        final avatarData = listAvatar.map((item) => item.join(',')).toList();
        _prefs ??= await SharedPreferences.getInstance();
        await _prefs!.setStringList('avatar_data', avatarData);

        Get.snackbar(
          "Avatar Deleted",
          "Your avatar has been deleted successfully!",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.blue[100],
          colorText: Colors.blue[800],
          duration: Duration(seconds: 2),
        );
      }
    } catch (error) {
      print("Error in deleteAvatar: $error");
      Get.snackbar(
        "Delete Failed",
        "There was a problem deleting your avatar.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
      );
    }
  }

  // Fungsi untuk update avatar yang sedang diedit
  Future<void> updateAvatarAtIndex(
      int index, List<String> updatedAvatar) async {
    try {
      if (index >= 0 && index < listAvatar.length) {
        listAvatar[index] = updatedAvatar;
        update();

        final avatarData = listAvatar.map((item) => item.join(',')).toList();
        _prefs ??= await SharedPreferences.getInstance();
        await _prefs!.setStringList('avatar_data', avatarData);

        Get.snackbar(
          "Avatar Updated",
          "Your avatar has been updated successfully!",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.blue[100],
          colorText: Colors.blue[800],
          duration: Duration(seconds: 2),
        );
      }
    } catch (error) {
      print("Error in updateAvatarAtIndex: $error");
      Get.snackbar(
        "Update Failed",
        "There was a problem updating your avatar.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
      );
    }
  }

  // Fungsi untuk memuat avatar untuk diedit
  void loadAvatarForEditing(int index) {
    if (index >= 0 && index < listAvatar.length) {
      currentEditingAvatar.value = List<String>.from(listAvatar[index]);
      editingIndex.value = index;
      update();
    }
  }

  // Fungsi untuk membatalkan pengeditan
  void cancelEditing() {
    currentEditingAvatar.clear();
    editingIndex.value = -1;
    update();
  }
}
