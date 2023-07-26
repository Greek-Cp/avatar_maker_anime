import 'package:avatar_maker_anime/controller/AvatarController.dart';
import 'package:avatar_maker_anime/page/maker/PageMakerCharacter.dart';
import 'package:avatar_maker_anime/page/repo/AssetRepo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:avatar_maker_anime/component/ComponentButton.dart';
import 'package:avatar_maker_anime/component/ComponentText.dart';
import 'package:avatar_maker_anime/util/ColorApp.dart';
import 'package:bottom_bar_matu/utils/app_utils.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:drop_shadow_image/drop_shadow_image.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:get/get.dart';

class PageViewCharacter extends StatefulWidget {
  @override
  State<PageViewCharacter> createState() => _PageViewCharacterState();
}

class _PageViewCharacterState extends State<PageViewCharacter> {


  final RepositoryAsset = Get.put(AssetRepo());
  List<ItemMaker> listItemMaker = [
  ];

  late SaveAvatarController _saveAvatarController;
  @override
  void initState() {
    super.initState();
    listItemMaker = RepositoryAsset.listItemMaker;
    _saveAvatarController = Get.put(SaveAvatarController());
    _saveAvatarController.loadDataFromSharedPreferences();
  }

  @override
  Widget build(BuildContext context) {
    List<List<String>> listLayer = _saveAvatarController.listAvatar;
    listLayer.forEach(
      (element) {
        print(element);
      },
    );
    return Scaffold(
      body: ScreenUtilInit(
        builder: (context, child) {
          return Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 30),
                child: GradientCustomWidgetText("My Avatar ✨", () => {}),
              ),
              Expanded(
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: PageScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                  ),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Stack(
                        children: [
                          Stack(
                            children: listLayer[index]
                                .map((item) => Image.asset(item))
                                .toList(),
                          ),
                          Positioned(
                            right: 1,
                            child: GradientButtonWithCustomIconAndFunction(
                                "assets/ui_icon/ic_erase.png",
                                () => {
                                      setState(() => {
                                            _saveAvatarController
                                                .deleteAvatar(index),
                                          })
                                    }),
                          ),
                        ],
                      ),
                    );
                  },
                  itemCount: listLayer.length,
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
