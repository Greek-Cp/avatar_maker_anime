import 'package:avatar_maker/page/intro/page_intro_game.dart';
import 'package:avatar_maker/page/page_base.dart';
import 'package:avatar_maker/util/color_app.dart';
import 'package:flutter/material.dart';
// import 'package:avatar_maker/page/test_play.dart';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

// import 'package:shared_preferences/shared_preferences.dart';

import 'page/maker/page_maker_character.dart';

void main() => runApp(const MainApp());

void requestPermissions() async {
  Map<Permission, PermissionStatus> statuses = await [
    Permission.storage,
    Permission.manageExternalStorage,
  ].request();

  if (statuses[Permission.storage]!.isGranted &&
      statuses[Permission.manageExternalStorage]!.isGranted) {
    // Permissions granted, you can now access external storage
  } else {
    // TODO: handle permission denied
  }
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: ColorApp.primaryColor,
      ),
    );
    requestPermissions();

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: PageIntroGame.routeName,
      getPages: [
        GetPage(
          name: PageIntroGame.routeName.toString(),
          page: () => PageIntroGame(),
        ),
        GetPage(
          name: PageBase.routeName.toString(),
          page: () => PageBase(),
        ),
        // GetPage(
        //   name: Playground.routeName.toString(),
        //   page: () => Playground(),
        // ),
        GetPage(
          name: PageMakerCharacter.routeName.toString(),
          page: () => PageMakerCharacter(),
        ),
      ],
    );
  }
}
