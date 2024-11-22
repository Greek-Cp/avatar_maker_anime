import 'package:avatar_maker/component/component_text.dart';
import 'package:avatar_maker/page/auth/register_page.dart';
// import 'package:avatar_maker/page/page_base.dart';
import 'package:avatar_maker/page/repo/asset_repo.dart';
import 'package:avatar_maker/util/color_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class PageIntroGame extends StatefulWidget {
  static String? routeName = "/PageIntroGame";

  const PageIntroGame({super.key});

  @override
  State<PageIntroGame> createState() => _PageIntroGameState();
}

class _PageIntroGameState extends State<PageIntroGame> {
  final repoController = Get.put(AssetRepo());

  @override
  void initState() {
    super.initState();

    // Tambahkan kode untuk menunggu beberapa saat, misalnya 3 detik
    Future.delayed(Duration(seconds: 3), () {
      // Navigasi ke halaman berikutnya setelah waktu yang ditentukan
      Get.to(RegisterPage()); // PageBase()
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorApp.primaryColor,
      body: ScreenUtilInit(
        builder: (context, child) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/ui_icon/page_intro.png",
                  height: 152.h,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                ComponentTextPrimaryTittleBold(
                  text: "Make Your Anime Character",
                  textAlign: TextAlign.center,
                  size: 38.sp,
                  colorText: Colors.white,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
