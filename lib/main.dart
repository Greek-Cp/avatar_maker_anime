import 'package:avatar_maker/controller/AvatarController.dart';
import 'package:avatar_maker/page/PageBase.dart';
import 'package:avatar_maker/page/intro/PageIntroGame.dart';
import 'package:avatar_maker/page/repo/AssetRepo.dart';
import 'package:avatar_maker/page/viewcharacter/PageViewCharacter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import 'page/maker/PageMakerCharacter.dart';

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
    final saveController = Get.put(SaveAvatarController());
    final avatarController = Get.put(AvatarController());
    final repoController = Get.put(AssetRepo());
    final makerCharacter = Get.put(PageMakerCharacterController());
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: PageIntroGame.routeName,
      getPages: [
        GetPage(
            name: PageIntroGame.routeName.toString(),
            page: () => PageIntroGame()),
        GetPage(name: PageBase.routeName.toString(), page: () => PageBase()),
        // GetPage(
        //     name: Playground.routeName.toString(), page: () => Playground()),
        GetPage(
            name: PageMakerCharacter.routeName.toString(),
            page: () => PageMakerCharacter()),
        GetPage(
            name: AvatarHistoryPage.routeName, page: () => AvatarHistoryPage())
      ],
    );
  }
}
