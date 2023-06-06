import 'package:avatar_maker_anime/controller/AvatarController.dart';
import 'package:avatar_maker_anime/page/PageBase.dart';
import 'package:avatar_maker_anime/page/intro/PageIntroGame.dart';
import 'package:avatar_maker_anime/page/testplay.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'page/maker/PageMakerCharacter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});
  // Panggil loadDataFromSharedPreferences sebelum menjalankan aplikasi
  SaveAvatarController saveAvatarController = Get.put(SaveAvatarController());
  saveAvatarController.loadDataFromSharedPreferences();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle());

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
