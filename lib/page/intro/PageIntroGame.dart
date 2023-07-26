import 'package:avatar_maker_anime/component/ComponentButton.dart';
import 'package:avatar_maker_anime/component/ComponentText.dart';
import 'package:avatar_maker_anime/page/PageBase.dart';
import 'package:avatar_maker_anime/page/repo/AssetRepo.dart';
import 'package:avatar_maker_anime/util/ColorApp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class PageIntroGame extends StatefulWidget {
  static String? routeName = "/PageIntroGame";
  @override
  State<PageIntroGame> createState() => _PageIntroGameState();
}

class _PageIntroGameState extends State<PageIntroGame> {
  void initState() {
    super.initState();
    // Tambahkan kode untuk menunggu beberapa saat, misalnya 3 detik


    Future.delayed(Duration(seconds: 3), () {
      // Navigasi ke halaman berikutnya setelah waktu yang ditentukan
      Get.to(
        PageBase(),
        transition: Transition.circularReveal,
        duration: Duration(seconds: 5),
      );
    });

  }
  final repoController = Get.put(AssetRepo());
  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Scaffold(
      backgroundColor: ColorApp.PrimaryColor,
      body: ScreenUtilInit(
        builder: (context, child) {
          return Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  "assets/ui_icon/page_intro.png",
                  fit: BoxFit.cover,
                ),
              ),
              ComponentTextPrimaryTittleBold(
                teks: "Make Your Anime Character",
                textAlign: TextAlign.center,
                size: 40.sp,
                colorText: Colors.white,
              ),
            ],
          );
        },
      ),
    );
  }
}
