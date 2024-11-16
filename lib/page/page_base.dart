import 'package:avatar_maker/page/maker/page_maker_character.dart';
import 'package:avatar_maker/page/repo/asset_repo.dart';
import 'package:avatar_maker/util/color_app.dart';
import 'package:fluid_bottom_nav_bar/fluid_bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'viewcharacter/page_view_character.dart';

class PageBase extends StatefulWidget {
  static String? routeName = "/PageBase";

  const PageBase({super.key});

  @override
  State<PageBase> createState() => _PageBaseState();
}

class _PageBaseState extends State<PageBase> {
  List<Widget> listPage = [
    SafeArea(child: PageMakerCharacter()),
    SafeArea(child: PageViewCharacter()),
  ];

  int selectedPage = 0;
  final repoController = Get.put(AssetRepo());

  @override
  void initState() {
    super.initState();
    repoController.updateRepo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: listPage[selectedPage],
      bottomNavigationBar: FluidNavBar(
        scaleFactor: 2,
        style: FluidNavBarStyle(
          barBackgroundColor: ColorApp.primaryColor,
          iconSelectedForegroundColor: Colors.white,
        ),
        onChange: (selectedIndex) {
          setState(() {
            selectedPage = selectedIndex;
          });
        },
        icons: [
          FluidNavBarIcon(
            icon: Icons.home_filled,
            unselectedForegroundColor: Colors.white,
            selectedForegroundColor: Colors.white,
            extras: {
              "label": "bookmark",
            },
          ),
          FluidNavBarIcon(
            icon: Icons.history,
            unselectedForegroundColor: Colors.white,
            selectedForegroundColor: Colors.white,
            extras: {
              "label": "bookmark",
            },
          ),
        ],
      ),
    );
  }
}
