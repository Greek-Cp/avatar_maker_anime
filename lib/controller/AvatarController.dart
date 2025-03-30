import 'dart:convert';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SaveAvatarController extends GetxController {
  // List of saved avatars
  RxList<List<String>> listAvatar = <List<String>>[].obs;

  // Current editing state
  RxInt editingIndex = (-1).obs;
  RxList<String> currentEditingAvatar = <String>[].obs;

  // Storage key
  final String _storageKey = 'saved_avatars';

  @override
  void onInit() {
    super.onInit();
    loadAvatarsFromStorage();
  }

  // Load avatars from SharedPreferences
  Future<void> loadAvatarsFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedAvatarsJson = prefs.getString(_storageKey);

      if (savedAvatarsJson != null) {
        final List<dynamic> decoded = jsonDecode(savedAvatarsJson);

        // Convert the dynamic list to the correct format
        listAvatar.value = decoded.map((item) {
          return List<String>.from(item);
        }).toList();

        print("Loaded ${listAvatar.length} avatars from storage");
      }
    } catch (e) {
      print('Error loading avatars: $e');
    }
  }

  // Save avatars to SharedPreferences
  Future<void> saveAvatarsToStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final encodedData = jsonEncode(listAvatar.toList());
      await prefs.setString(_storageKey, encodedData);
      print("Saved ${listAvatar.length} avatars to storage");
    } catch (e) {
      print('Error saving avatars: $e');
    }
  }

  // Save a new avatar
  Future<void> saveAvatar(List<String> avatarLayers) async {
    // Add the new avatar to the list
    listAvatar.add(List<String>.from(avatarLayers));
    print("New avatar saved, total count: ${listAvatar.length}");

    // Save to storage
    await saveAvatarsToStorage();
  }

  // Update an existing avatar
  Future<void> updateAvatarAtIndex(
      int index, List<String> updatedLayers) async {
    if (index >= 0 && index < listAvatar.length) {
      print("Updating avatar at index $index");
      listAvatar[index] = List<String>.from(updatedLayers);

      // Reset editing state
      editingIndex.value = -1;
      currentEditingAvatar.clear();

      // Save to storage
      await saveAvatarsToStorage();
    } else {
      print(
          "Error: Cannot update avatar at index $index, only ${listAvatar.length} avatars exist");
    }
  }

  // Prepare avatar for editing
  void loadAvatarForEditing(int index) {
    if (index >= 0 && index < listAvatar.length) {
      print("Setting up avatar at index $index for editing");

      // Set the editing index
      editingIndex.value = index;

      // Make a copy of the avatar to edit
      currentEditingAvatar.value = List<String>.from(listAvatar[index]);

      print("Editing avatar with ${currentEditingAvatar.length} layers");
    } else {
      print(
          "Error: Cannot edit avatar at index $index, only ${listAvatar.length} avatars exist");
    }
  }

  // Delete an avatar
  Future<void> deleteAvatar(int index) async {
    if (index >= 0 && index < listAvatar.length) {
      print("Deleting avatar at index $index");
      listAvatar.removeAt(index);

      // If we were editing this avatar, reset editing state
      if (editingIndex.value == index) {
        editingIndex.value = -1;
        currentEditingAvatar.clear();
      } else if (editingIndex.value > index) {
        // Adjust the editing index if we deleted an avatar before it
        editingIndex.value--;
      }

      // Save to storage
      await saveAvatarsToStorage();
    } else {
      print(
          "Error: Cannot delete avatar at index $index, only ${listAvatar.length} avatars exist");
    }
  }

  // Clear editing state
  void clearEditingState() {
    editingIndex.value = -1;
    currentEditingAvatar.clear();
    print("Cleared editing state");
  }
}
