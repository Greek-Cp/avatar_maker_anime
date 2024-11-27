import 'package:avatar_maker/page/intro/splash_page.dart';
import 'package:avatar_maker/page/maker/page_maker_character.dart';
import 'package:avatar_maker/page/page_base.dart';
import 'package:avatar_maker/util/color_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
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
      initialRoute: SplashPage.routeName,
      getPages: [
        GetPage(
          name: SplashPage.routeName.toString(),
          page: () => SplashPage(),
        ),
        GetPage(
          name: PageBase.routeName.toString(),
          page: () => PageBase(),
        ),
        GetPage(
          name: PageMakerCharacter.routeName.toString(),
          page: () => PageMakerCharacter(),
        ),
      ],
    );
  }
}
