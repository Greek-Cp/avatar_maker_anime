import 'package:avatar_maker/component/component_button.dart';
import 'package:avatar_maker/controller/avatar_controller.dart';
import 'package:avatar_maker/page/maker/page_maker_character.dart';
import 'package:avatar_maker/page/repo/asset_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class PageViewCharacter extends StatefulWidget {
  @override
  State<PageViewCharacter> createState() => _PageViewCharacterState();
}

class _PageViewCharacterState extends State<PageViewCharacter> {
  final RepositoryAsset = Get.put(AssetRepo());
  List<ItemMaker> listItemMaker = [];

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
