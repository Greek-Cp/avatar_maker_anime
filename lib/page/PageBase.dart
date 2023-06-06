import 'package:avatar_maker_anime/page/comming_soon/CommingSoon.dart';
import 'package:avatar_maker_anime/page/maker/PageMakerCharacter.dart';
import 'package:avatar_maker_anime/page/viewcharacter/PageViewCharacter.dart';
import 'package:avatar_maker_anime/util/ColorApp.dart';
import 'package:fluid_bottom_nav_bar/fluid_bottom_nav_bar.dart';
import 'package:flutter/material.dart';

class PageBase extends StatefulWidget {
  static String? routeName = "/PageBase";
  @override
  State<PageBase> createState() => _PageBaseState();
}

class _PageBaseState extends State<PageBase> {
  List<Widget> listPage = [
    SafeArea(child: PageMakerCharacter()),
    SafeArea(child: PageViewCharacter()),
    SafeArea(child: CommingSoon()),
  ];

  int selectedPage = 0;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: listPage[selectedPage],
      bottomNavigationBar: FluidNavBar(
          scaleFactor: 2,
          style: FluidNavBarStyle(
              barBackgroundColor: ColorApp.PrimaryColor,
              iconSelectedForegroundColor: Colors.white),
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
                extras: {"label": "bookmark"}),
            FluidNavBarIcon(
                icon: Icons.history,
                unselectedForegroundColor: Colors.white,
                selectedForegroundColor: Colors.white,
                extras: {"label": "bookmark"}),
            FluidNavBarIcon(
                icon: Icons.info,
                unselectedForegroundColor: Colors.white,
                selectedForegroundColor: Colors.white,
                extras: {"label": "bookmark"})
          ]),
    );
  }
}
