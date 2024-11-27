import 'package:avatar_maker/page/auth/account_page.dart';
import 'package:avatar_maker/page/maker/create_char_page.dart';
import 'package:avatar_maker/page/repo/asset_repo.dart';
import 'package:avatar_maker/page/viewcharacter/view_char_page.dart';
import 'package:avatar_maker/util/color_app.dart';
import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class PlaygroundPage extends StatefulWidget {
  static String? routeName = "/PlaygroundPage";

  const PlaygroundPage({super.key});

  @override
  State<PlaygroundPage> createState() => _PlaygroundPageState();
}

class _PlaygroundPageState extends State<PlaygroundPage> {
  List<Widget> listPage = [
    SafeArea(child: CreateCharacterPage()),
    SafeArea(child: ViewCharacterPage()),
    SafeArea(child: AccountPage()),
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
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: ColorApp.primaryColor,
        systemNavigationBarColor: ColorApp.backgroundNavigationBottomColor,
      ),
    );
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
