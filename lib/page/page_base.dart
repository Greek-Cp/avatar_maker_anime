import 'package:avatar_maker/page/maker/page_maker_character.dart';
import 'package:avatar_maker/page/repo/asset_repo.dart';
import 'package:avatar_maker/page/viewcharacter/page_view_character.dart';
import 'package:avatar_maker/util/color_app.dart';
import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
      bottomNavigationBar: FlashyTabBar(
        shadows: [],
        iconSize: 32,
        height: 56,
        showElevation: true,
        backgroundColor: ColorApp.backgroundNavigationBottomColor,
        selectedIndex: selectedPage,
        onItemSelected: (index) => setState(() {
          selectedPage = index;
        }),
        items: [
          FlashyTabBarItem(
            activeColor: ColorApp.primaryColor,
            inactiveColor: ColorApp.primaryColor,
            icon: Icon(FluentIcons.home_24_filled),
            title: Text('Playground'),
          ),
          FlashyTabBarItem(
            activeColor: ColorApp.primaryColor,
            inactiveColor: ColorApp.primaryColor,
            icon: Icon(FluentIcons.history_24_filled),
            title: Text('History'),
          ),
          FlashyTabBarItem(
            activeColor: ColorApp.primaryColor,
            inactiveColor: ColorApp.primaryColor,
            icon: Icon(FluentIcons.person_24_filled),
            title: Text('Account'),
          ),
        ],
      ),
    );
  }
}
