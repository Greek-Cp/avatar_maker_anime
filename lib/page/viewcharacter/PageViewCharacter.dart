import 'dart:ui';

import 'package:avatar_maker/controller/AvatarController.dart';
import 'package:avatar_maker/page/maker/PageMakerCharacter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class AvatarHistoryPage extends StatelessWidget {
  static String routeName = "/AvatarHistoryPage";

  final SaveAvatarController saveController = Get.find<SaveAvatarController>();
  final AvatarController avatarController = Get.find<AvatarController>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFDAD7FF),
              Color(0xFFFFE0F3),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(context, size),
              SizedBox(height: 10),
              _buildHeaderText(size),
              SizedBox(height: 15),
              _buildAvatarGrid(size),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, Size size) {
    final buttonSize = size.width * 0.1;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildGlassButton(
            onTap: () => Get.back(),
            child: Icon(Icons.arrow_back_ios_rounded,
                color: Colors.white, size: buttonSize * 0.45),
            width: buttonSize,
            height: buttonSize,
          ),
          Text(
            "Avatar History",
            style: TextStyle(
              color: Colors.white,
              fontSize: size.width * 0.055,
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(
                  color: Colors.purple.withOpacity(0.3),
                  offset: Offset(1, 1),
                  blurRadius: 2,
                ),
              ],
            ),
          ),
          SizedBox(width: buttonSize), // Empty space for balance
        ],
      ),
    );
  }

  Widget _buildHeaderText(Size size) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        "Your saved avatars",
        style: TextStyle(
          color: Color(0xFF666CFF),
          fontSize: size.width * 0.045,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildAvatarGrid(Size size) {
    return Expanded(
      child: Obx(() {
        final avatars = saveController.listAvatar;

        if (avatars.isEmpty) {
          return _buildEmptyState(size);
        }

        return GridView.builder(
          padding: EdgeInsets.all(15),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.8,
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
          ),
          itemCount: avatars.length,
          itemBuilder: (context, index) {
            return _buildAvatarCard(index, size);
          },
        );
      }),
    );
  }

  Widget _buildEmptyState(Size size) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.image_not_supported_outlined,
            size: size.width * 0.2,
            color: Color(0xFF9387FF).withOpacity(0.5),
          ),
          SizedBox(height: 20),
          Text(
            "No avatars saved yet",
            style: TextStyle(
              color: Color(0xFF666CFF),
              fontSize: size.width * 0.05,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Text(
            "Create and save your first avatar!",
            style: TextStyle(
              color: Color(0xFF666CFF).withOpacity(0.7),
              fontSize: size.width * 0.04,
            ),
          ),
          SizedBox(height: 30),
          _buildGlassButton(
            onTap: () => Get.toNamed(PageMakerCharacter.routeName),
            width: size.width * 0.5,
            height: size.height * 0.06,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFFF89B3).withOpacity(0.8),
                Color(0xFFFF6CAB).withOpacity(0.6),
              ],
            ),
            child: Text(
              "Create New Avatar",
              style: TextStyle(
                color: Colors.white,
                fontSize: size.width * 0.04,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarCard(int index, Size size) {
    final avatarLayers = saveController.listAvatar[index];

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white.withOpacity(0.4),
        border: Border.all(
          color: Colors.white.withOpacity(0.5),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            spreadRadius: 0,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Column(
            children: [
              // Avatar preview
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFB0A6FF).withOpacity(0.3),
                    ),
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: avatarLayers
                          .map((layer) => Image.asset(layer))
                          .toList(),
                    ),
                  ),
                ),
              ),

              // Action buttons
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: Color(0xFFB0A6FF).withOpacity(0.2),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Edit button
                    InkWell(
                      onTap: () {
                        HapticFeedback.lightImpact();
                        avatarController.loadAvatarForEdit(index);
                      },
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF9387FF).withOpacity(0.6),
                        ),
                        child: Icon(
                          Icons.edit,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),

                    // Avatar number
                    Text(
                      "Avatar ${index + 1}",
                      style: TextStyle(
                        color: Color(0xFF666CFF),
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    // Delete button
                    InkWell(
                      onTap: () => _showDeleteConfirmation(index),
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFFF6CAB).withOpacity(0.6),
                        ),
                        child: Icon(
                          Icons.delete,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(int index) {
    Get.dialog(
      BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white.withOpacity(0.7),
              border: Border.all(
                color: Colors.white.withOpacity(0.8),
                width: 1.5,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  color: Color(0xFFFF6CAB),
                  size: 50,
                ),
                SizedBox(height: 15),
                Text(
                  "Delete Avatar?",
                  style: TextStyle(
                    color: Color(0xFF666CFF),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "This action cannot be undone.",
                  style: TextStyle(
                    color: Color(0xFF666CFF).withOpacity(0.7),
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: _buildGlassButton(
                        onTap: () => Get.back(),
                        width: double.infinity,
                        height: 45,
                        child: Text(
                          "Cancel",
                          style: TextStyle(
                            color: Color(0xFF666CFF),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: _buildGlassButton(
                        onTap: () {
                          saveController.deleteAvatar(index);
                          Get.back();
                          Get.snackbar(
                            "Avatar Deleted",
                            "Your avatar has been removed",
                            snackPosition: SnackPosition.TOP,
                            backgroundColor: Color(0xFFFF6CAB).withOpacity(0.8),
                            colorText: Colors.white,
                            margin: EdgeInsets.all(10),
                            duration: Duration(seconds: 2),
                          );
                        },
                        width: double.infinity,
                        height: 45,
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFFFF89B3).withOpacity(0.8),
                            Color(0xFFFF6CAB).withOpacity(0.6),
                          ],
                        ),
                        child: Text(
                          "Delete",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGlassButton({
    required Widget child,
    required Function()? onTap,
    required double width,
    required double height,
    Gradient? gradient,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(height * 0.4),
          gradient: gradient ??
              LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withOpacity(0.5),
                  Colors.white.withOpacity(0.3),
                ],
              ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              spreadRadius: 0,
              offset: Offset(0, 2),
            ),
          ],
          border: Border.all(
            color: Colors.white.withOpacity(0.5),
            width: 1.5,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(height * 0.4),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              color: Colors.transparent,
              child: Center(child: child),
            ),
          ),
        ),
      ),
    );
  }
}

// Ensure the SaveAvatarController has the necessary methods
extension SaveAvatarControllerExtension on SaveAvatarController {
  // Method to delete avatar (ensure this exists in your SaveAvatarController)
  void deleteAvatar(int index) {
    listAvatar.removeAt(index);
    saveAvatarsToStorage(); // Make sure this method exists in your controller
  }
}
