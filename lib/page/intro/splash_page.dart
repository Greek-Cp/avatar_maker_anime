import 'package:avatar_maker/component/typography.dart';
import 'package:avatar_maker/page/intro/wizard_page.dart';
import 'package:avatar_maker/page/playground_page.dart';
import 'package:avatar_maker/service/authentication.dart';
import 'package:avatar_maker/util/color_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SplashPage extends StatefulWidget {
  static String? routeName = "/SplashPage";

  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final AuthService authService = AuthService();

  @override
  void initState() {
    super.initState();

    // Cek login status setelah splash screen muncul
    Future.delayed(Duration(seconds: 3), () async {
      // Cek apakah user sudah login
      bool isLoggedIn = await authService.isLoggedIn();

      // Navigasi berdasarkan status login
      if (isLoggedIn) {
        // Jika sudah login, navigasi ke halaman utama (misalnya PlaygroundPage)
        Get.to(() => PlaygroundPage());
      } else {
        // Jika belum login, navigasi ke halaman wizard (WizardPage)
        Get.to(() => WizardPage());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: ColorApp.primaryColor,
        systemNavigationBarColor: ColorApp.primaryColor,
      ),
    );
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
                TitleBold(
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
