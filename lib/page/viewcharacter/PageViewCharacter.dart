import 'package:avatar_maker/controller/AvatarController.dart';
import 'package:avatar_maker/page/maker/PageMakerCharacter.dart';
import 'package:avatar_maker/page/repo/AssetRepo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:avatar_maker/component/ComponentButton.dart';
import 'package:avatar_maker/component/ComponentText.dart';
import 'package:avatar_maker/util/ColorApp.dart';
import 'package:drop_shadow_image/drop_shadow_image.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:get/get.dart';
import 'package:avatar_maker/controller/AvatarController.dart';
import 'package:avatar_maker/page/maker/PageMakerCharacter.dart';
import 'package:avatar_maker/page/repo/AssetRepo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:avatar_maker/controller/AvatarController.dart';
import 'package:avatar_maker/page/maker/PageMakerCharacter.dart';
import 'package:avatar_maker/page/repo/AssetRepo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:avatar_maker/controller/AvatarController.dart';
import 'package:avatar_maker/page/maker/PageMakerCharacter.dart';
import 'package:avatar_maker/page/repo/AssetRepo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';

class PageViewCharacter extends StatelessWidget {
  // Warna tema estetika
  final Color primaryColor = Color(0xFFFA9ECC);
  final Color secondaryColor = Color(0xFFFFC0D9);
  final Color accentColor = Color(0xFFAA336A);
  final Color backgroundColor = Color(0xFFFFF0F5);
  final Color textColor = Color(0xFF4A4A4A);

  // Controllers
  final AssetRepo repositoryAsset = Get.find<AssetRepo>();
  final SaveAvatarController saveAvatarController =
      Get.find<SaveAvatarController>();
  final AvatarController avatarController = Get.put(AvatarController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Obx(() {
          final listLayer = saveAvatarController.listAvatar;

          if (listLayer.isEmpty) {
            return _buildEmptyState();
          } else {
            return _buildAvatarGrid(listLayer);
          }
        }),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: AnimationConfiguration.synchronized(
        duration: const Duration(milliseconds: 500),
        child: SlideAnimation(
          verticalOffset: 50.0,
          child: FadeInAnimation(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 120.w,
                  height: 120.w,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: primaryColor.withOpacity(0.2),
                        blurRadius: 15,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.person_outline,
                    size: 60.w,
                    color: primaryColor.withOpacity(0.5),
                  ),
                ),
                Text(
                  "No Avatars Yet",
                  style: TextStyle(
                    color: textColor,
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 15.h),
                Text(
                  "Create your first anime avatar!",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16.sp,
                  ),
                ),
                SizedBox(height: 40.h),
                _buildCreateButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAvatarGrid(RxList<List<String>> listLayer) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "My Collection",
                style: TextStyle(
                  color: accentColor,
                  fontSize: 28.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.h),
              Row(
                children: [
                  Text(
                    "${listLayer.length} Avatar${listLayer.length > 1 ? 's' : ''}",
                    style: TextStyle(
                      color: textColor,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Spacer(),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.sort,
                          size: 18.w,
                          color: accentColor,
                        ),
                        SizedBox(width: 5.w),
                        Text(
                          "Latest",
                          style: TextStyle(
                            color: accentColor,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: AnimationLimiter(
            child: GridView.builder(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              physics: BouncingScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 15.w,
                mainAxisSpacing: 15.w,
                childAspectRatio: 0.8,
              ),
              itemCount: listLayer.length,
              itemBuilder: (context, index) {
                return AnimationConfiguration.staggeredGrid(
                  position: index,
                  duration: const Duration(milliseconds: 375),
                  columnCount: 2,
                  child: ScaleAnimation(
                    child: FadeInAnimation(
                      child: _buildAvatarCard(listLayer, index),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(20.w),
          child: _buildCreateButton(),
        ),
      ],
    );
  }

  Widget _buildAvatarCard(List<List<String>> listLayer, int index) {
    return GestureDetector(
      onTap: () => _showCardOptionsDialog(index),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.15),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: secondaryColor.withOpacity(0.2),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.r),
                        topRight: Radius.circular(20.r),
                      ),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: listLayer[index]
                          .map((item) => Image.asset(item))
                          .toList(),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(15.r),
                        onTap: () => _showDeleteDialog(index),
                        child: Container(
                          padding: EdgeInsets.all(8.r),
                          decoration: BoxDecoration(
                            color: Colors.red[50],
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.delete_outline,
                            color: Colors.red[300],
                            size: 20.w,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(15.r),
                        onTap: () => _loadCharacter(index),
                        child: Container(
                          padding: EdgeInsets.all(8.r),
                          decoration: BoxDecoration(
                            color: Colors.green[50],
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.download_outlined,
                            color: Colors.green[400],
                            size: 20.w,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20.r),
                  bottomRight: Radius.circular(20.r),
                ),
              ),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Avatar ${index + 1}",
                        style: TextStyle(
                          color: textColor,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        "Anime",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12.sp,
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  Container(
                    width: 30.w,
                    height: 30.w,
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(15.r),
                    ),
                    child: Icon(
                      Icons.more_horiz,
                      color: accentColor,
                      size: 18.w,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCreateButton() {
    return Container(
      width: double.infinity,
      height: 55.h,
      child: ElevatedButton(
        onPressed: () => Get.to(() => PageMakerCharacter()),
        style: ElevatedButton.styleFrom(
          backgroundColor: accentColor,
          elevation: 5,
          shadowColor: accentColor.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.r),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_circle_outline,
              size: 22.w,
            ),
            SizedBox(width: 10.w),
            Text(
              "Create New Avatar",
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(int index) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        title: Row(
          children: [
            Icon(
              Icons.delete_outline,
              color: Colors.red[400],
              size: 24.w,
            ),
            SizedBox(width: 10.w),
            Text(
              "Delete Avatar",
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Text(
          "Are you sure you want to delete this avatar? This action cannot be undone.",
          style: TextStyle(
            color: Colors.grey[700],
            fontSize: 14.sp,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              "Cancel",
              style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // Hapus avatar dari controller
              saveAvatarController.deleteAvatar(index);
              Get.back();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[400],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
            child: Text(
              "Delete",
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Fungsi untuk memuat avatar ke editor
  void _loadCharacter(int index) {
    avatarController.loadAvatarForEdit(index);

    Get.snackbar(
      "Avatar Loaded",
      "Avatar is ready to edit",
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.green[100],
      colorText: Colors.green[800],
      margin: EdgeInsets.all(10),
      borderRadius: 10,
      isDismissible: true,
      duration: Duration(seconds: 2),
      icon: Icon(Icons.check_circle, color: Colors.green[800]),
    );
  }

  void _showCardOptionsDialog(int index) {
    Get.bottomSheet(
      Container(
        height: 230.h,
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25.r),
            topRight: Radius.circular(25.r),
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 40.w,
              height: 5.h,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(5.r),
              ),
            ),
            SizedBox(height: 15.h),
            Text(
              "Avatar Options",
              style: TextStyle(
                color: textColor,
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20.h),
            _buildOptionButton(
              icon: Icons.edit_outlined,
              label: "Edit Avatar",
              color: Colors.green[400]!,
              onTap: () {
                _loadCharacter(index);
                Get.back();
              },
            ),
            SizedBox(height: 10.h),
            _buildOptionButton(
              icon: Icons.share_outlined,
              label: "Share Avatar",
              color: Colors.blue[400]!,
              onTap: () {
                Get.back();
                Get.snackbar(
                  "Sharing",
                  "Sharing feature coming soon!",
                  snackPosition: SnackPosition.BOTTOM,
                );
              },
            ),
            SizedBox(height: 10.h),
            _buildOptionButton(
              icon: Icons.delete_outline,
              label: "Delete Avatar",
              color: Colors.red[400]!,
              onTap: () {
                Get.back();
                _showDeleteDialog(index);
              },
            ),
          ],
        ),
      ),
      backgroundColor: Colors.transparent,
      isDismissible: true,
      enableDrag: true,
    );
  }

  Widget _buildOptionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 20.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.r),
          border: Border.all(
            color: Colors.grey[200]!,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: color,
                size: 20.w,
              ),
            ),
            SizedBox(width: 15.w),
            Text(
              label,
              style: TextStyle(
                color: textColor,
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            Spacer(),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey,
              size: 16.w,
            ),
          ],
        ),
      ),
    );
  }
}
