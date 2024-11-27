import 'package:avatar_maker/component/button.dart';
import 'package:avatar_maker/controller/avatar_controller.dart';
import 'package:avatar_maker/page/maker/create_char_page.dart';
import 'package:avatar_maker/page/repo/asset_repo.dart';
import 'package:avatar_maker/util/color_app.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ViewCharacterPage extends StatefulWidget {
  static String? routeName = "/ViewCharacterPage";

  const ViewCharacterPage({super.key});

  @override
  State<ViewCharacterPage> createState() => _ViewCharacterPageState();
}

class _ViewCharacterPageState extends State<ViewCharacterPage> {
  final repositoryAsset = Get.put(AssetRepo());
  List<ItemMaker> listItemMaker = [];

  late SaveAvatarController _saveAvatarController;
  @override
  void initState() {
    super.initState();
    listItemMaker = repositoryAsset.listItemMaker;
    _saveAvatarController = Get.put(SaveAvatarController());
    _saveAvatarController.loadDataFromSharedPreferences();
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
    List<List<String>> listLayer = _saveAvatarController.listAvatar;
    return Scaffold(
      body: ScreenUtilInit(
        builder: (context, child) {
          return Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 6.h),
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
                              Icon(
                                FluentIcons.eraser_24_filled,
                                color: Colors.white,
                                size: 32,
                              ),
                              () => {
                                setState(() {
                                  _saveAvatarController.deleteAvatar(index);
                                })
                              },
                            ),
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
