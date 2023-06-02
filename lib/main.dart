import 'page/maker/PageMakerCharacter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: PageMakerCharacter.routeName,
      getPages: [
        GetPage(
            name: PageMakerCharacter.routeName.toString(),
            page: () => PageMakerCharacter()),
      ],
    );
  }
}
