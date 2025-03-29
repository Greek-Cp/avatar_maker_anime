import 'package:avatar_maker/page/maker/PageMakerCharacter.dart';
import 'package:avatar_maker/page/repo/AssetRepo.dart';
import 'package:avatar_maker/util/ColorApp.dart';
import 'package:fluid_bottom_nav_bar/fluid_bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'viewcharacter/PageViewCharacter.dart';
import 'package:avatar_maker/page/maker/PageMakerCharacter.dart';
import 'package:avatar_maker/page/repo/AssetRepo.dart';
import 'package:avatar_maker/util/ColorApp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class PageBase extends StatefulWidget {
  static String? routeName = "/PageBase";
  @override
  State<PageBase> createState() => _PageBaseState();
}

class _PageBaseState extends State<PageBase>
    with SingleTickerProviderStateMixin {
  List<Widget> listPage = [
    SafeArea(child: PageMakerCharacter()),
    SafeArea(child: PageViewCharacter()),
  ];

  int selectedPage = 0;
  final repoController = Get.put(AssetRepo());

  // Warna tema estetika
  final Color primaryColor = Color(0xFFFA9ECC);
  final Color secondaryColor = Color(0xFFFFC0D9);
  final Color accentColor = Color(0xFFAA336A);
  final Color backgroundColor = Color(0xFFFFF0F5);

  // Controller untuk animasi
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    repoController.updateRepo();

    // Inisialisasi controller animasi
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: listPage[selectedPage],
      bottomNavigationBar: Container(
        height: 70.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25.r),
            topRight: Radius.circular(25.r),
          ),
          boxShadow: [
            BoxShadow(
              color: primaryColor.withOpacity(0.15),
              blurRadius: 10,
              offset: Offset(0, -3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNavItem(
              icon: Icons.edit,
              label: "Create",
              isActive: selectedPage == 0,
              index: 0,
            ),
            _buildCenterNavItem(),
            _buildNavItem(
              icon: Icons.person,
              label: "Avatars",
              isActive: selectedPage == 1,
              index: 1,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required bool isActive,
    required int index,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPage = index;

          // Play animation when selected
          if (isActive) {
            _animationController.forward(from: 0.0);
          }
        });
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedContainer(
            duration: Duration(milliseconds: 200),
            padding: EdgeInsets.all(10.r),
            decoration: BoxDecoration(
              color:
                  isActive ? primaryColor.withOpacity(0.2) : Colors.transparent,
              borderRadius: BorderRadius.circular(15.r),
            ),
            child: Icon(
              icon,
              color: isActive ? accentColor : Colors.grey,
              size: 26.r,
            ),
          ),
          SizedBox(height: 5.h),
          Text(
            label,
            style: TextStyle(
              color: isActive ? accentColor : Colors.grey,
              fontSize: 12.sp,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCenterNavItem() {
    return GestureDetector(
      onTap: () {
        // Randomize avatar effect
        setState(() {
          _animationController.forward(from: 0.0);
        });

        // Tambahkan logika randomize avatar disini jika perlu
        // Misalnya panggil fungsi randomize dari controller
      },
      child: Container(
        width: 60.r,
        height: 60.r,
        decoration: BoxDecoration(
          color: accentColor,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: accentColor.withOpacity(0.3),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Transform.rotate(
              angle: _animationController.value * 2 * 3.14159,
              child: child,
            );
          },
          child: Icon(
            Icons.autorenew,
            color: Colors.white,
            size: 30.r,
          ),
        ),
      ),
    );
  }
}
