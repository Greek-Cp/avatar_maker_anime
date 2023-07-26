import 'package:avatar_maker_anime/page/PageBase.dart';
import 'package:avatar_maker_anime/page/intro/PageIntroGame.dart';
import 'package:avatar_maker_anime/page/testplay.dart';

import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'page/maker/PageMakerCharacter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MainApp());
}

void requestPermissions() async {
  Map<Permission, PermissionStatus> statuses = await [
    Permission.storage,
    Permission.manageExternalStorage,
  ].request();

  if (statuses[Permission.storage]!.isGranted &&
      statuses[Permission.manageExternalStorage]!.isGranted) {
    // Permissions granted, you can now access external storage 
  } else {
    // Permissions not granted, handle accordingly
  }
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle());
    requestPermissions();

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: PageIntroGame.routeName,
      getPages: [
        GetPage(
            name: PageIntroGame.routeName.toString(),
            page: () => PageIntroGame()),
        GetPage(name: PageBase.routeName.toString(), page: () => PageBase()),
        GetPage(
            name: Playground.routeName.toString(), page: () => Playground()),
        GetPage(
            name: PageMakerCharacter.routeName.toString(),
            page: () => PageMakerCharacter()),
      ],
    );
  }
}
