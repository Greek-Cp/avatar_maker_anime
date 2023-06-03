import 'dart:math';

import 'package:avatar_maker_anime/component/ComponentButton.dart';
import 'package:avatar_maker_anime/component/ComponentText.dart';
import 'package:avatar_maker_anime/util/ColorApp.dart';
import 'package:bottom_bar_matu/utils/app_utils.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import '../../component/ComponentItem.dart';
import '../../assets_class/Part28_class28.dart';
import '../../assets_class/Part27_class27.dart';
import '../../assets_class/Part26_02class26.dart';
import '../../assets_class/Part25_01class25.dart';
import '../../assets_class/Part24_class24.dart';
import '../../assets_class/Part23_class23.dart';
import '../../assets_class/Part22__class22.dart';
import '../../assets_class/Part21_class21.dart';
import '../../assets_class/Part20_class20.dart';
import '../../assets_class/Part19_class19.dart';
import '../../assets_class/Part18_class18.dart';
import '../../assets_class/Part17_class17.dart';
import '../../assets_class/Part16_02class16.dart';
import '../../assets_class/Part15_01class15.dart';
import '../../assets_class/Part14_class14.dart';
import '../../assets_class/Part13_class13.dart';
import '../../assets_class/Part12_class12.dart';
import '../../assets_class/Part11_class11.dart';
import '../../assets_class/Part10__class10.dart';
import '../../assets_class/Part9_class9.dart';
import '../../assets_class/Part8_class8.dart';
import '../../assets_class/Part7_class7.dart';
import '../../assets_class/Part6_02class6.dart';
import '../../assets_class/Part5_01class5.dart';
import '../../assets_class/Part4_class4.dart';
import '../../assets_class/Part3_class3.dart';
import '../../assets_class/Part2_01class2.dart';
import '../../assets_class/Part1_02class1.dart';
import '../../assets_class/Part0_class0.dart';
import 'package:encrypted_asset_image/encrypted_asset_image.dart';

class PageMakerCharacter extends StatefulWidget {
  static String? routeName = "/PageMakerCharacter";

  @override
  State<PageMakerCharacter> createState() => _PageMakerCharacterState();
}

class ItemMaker {
  String? assetParent;
  bool statusSelected = false;
  List<String>? listItem;
  ItemMaker(this.assetParent, this.listItem);
}

List<ItemMaker> listItemMaker = [
  ItemMaker(Part28_class28.asset_0, Part28_class28.listAssetpart28_class28),
  ItemMaker(Part27_class27.asset_0, Part27_class27.listAssetpart27_class27),
  ItemMaker(
      Part26_02class26.asset02_0, Part26_02class26.listAssetpart26_02class26),
  ItemMaker(
      Part25_01class25.asset01_0, Part25_01class25.listAssetpart25_01class25),
  ItemMaker(Part24_class24.asset_0, Part24_class24.listAssetpart24_class24),
  ItemMaker(Part23_class23.asset_0, Part23_class23.listAssetpart23_class23),
  ItemMaker(Part22__class22.asset__0, Part22__class22.listAssetpart22__class22),
  ItemMaker(Part21_class21.asset_0, Part21_class21.listAssetpart21_class21),
  ItemMaker(Part20_class20.asset_0, Part20_class20.listAssetpart20_class20),
  ItemMaker(Part19_class19.asset_0, Part19_class19.listAssetpart19_class19),
  ItemMaker(Part18_class18.asset_0, Part18_class18.listAssetpart18_class18),
  ItemMaker(Part17_class17.asset_0, Part17_class17.listAssetpart17_class17),
  ItemMaker(
      Part16_02class16.asset02_0, Part16_02class16.listAssetpart16_02class16),
  ItemMaker(
      Part15_01class15.asset01_0, Part15_01class15.listAssetpart15_01class15),
  ItemMaker(Part14_class14.asset_0, Part14_class14.listAssetpart14_class14),
  ItemMaker(Part13_class13.asset_0, Part13_class13.listAssetpart13_class13),
  ItemMaker(Part12_class12.asset_0, Part12_class12.listAssetpart12_class12),
  ItemMaker(Part11_class11.asset_0, Part11_class11.listAssetpart11_class11),
  ItemMaker(Part10__class10.asset__0, Part10__class10.listAssetpart10__class10),
  ItemMaker(Part9_class9.asset_0, Part9_class9.listAssetpart9_class9),
  ItemMaker(Part8_class8.asset_0, Part8_class8.listAssetpart8_class8),
  ItemMaker(Part7_class7.asset_0, Part7_class7.listAssetpart7_class7),
  ItemMaker(Part6_02class6.asset02_0, Part6_02class6.listAssetpart6_02class6),
  ItemMaker(Part5_01class5.asset01_0, Part5_01class5.listAssetpart5_01class5),
  ItemMaker(Part4_class4.asset_0, Part4_class4.listAssetpart4_class4),
  ItemMaker(Part3_class3.asset_0, Part3_class3.listAssetpart3_class3),
  ItemMaker(Part2_01class2.asset01_0, Part2_01class2.listAssetpart2_01class2),
  ItemMaker(Part1_02class1.asset02_0, Part1_02class1.listAssetpart1_02class1),
  ItemMaker(Part0_class0.asset_0, Part0_class0.listAssetpart0_class0),
];

class _PageMakerCharacterState extends State<PageMakerCharacter> {
  int partSelected = 0;
  int itemSelected = 0;
  List<Widget> listImageLayer = [];

  @override
  void initState() {
    listImageLayer = List.generate(
      listItemMaker.length,
      (index) => Image.asset(
        listItemMaker[index].assetParent.toString(),
        fit: BoxFit.fitWidth,
      ),
    );
    super.initState();
  }

  Widget ComponentItemAvatar(
      ItemMaker itemMaker, double width, double heigth, int index) {
    return Material(
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(30.r),
          gradient: LinearGradient(
            colors: partSelected == index
                ? [
                    Color.fromRGBO(255, 56, 182, 1),
                    Color.fromRGBO(255, 26, 136, 1),
                  ]
                : [
                    Color.fromRGBO(255, 255, 255, 1),
                    Color.fromRGBO(255, 255, 255, 1),
                  ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            Image.asset(
              Part21_class21.asset_0,
            ),
            Image.asset(
              itemMaker.listItem![0].toString(),
            ),
          ],
        ),
      ),
    );
  }

  int getRandomNumber(int len) {
    int max = len - 1;
    int randomNumber = Random().nextInt(max) + 1;
    return randomNumber;
  }

  void showImageLayerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Image Layers'),
          content: Container(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: listImageLayer.length,
              itemBuilder: (BuildContext context, int index) {
                return Row(
                  children: [
                    ComponentTextPrimaryTittleBold(
                      teks: index.toString(),
                    ),
                    Expanded(
                      child: Container(
                          width: 100,
                          height: 100,
                          child: listImageLayer[index]),
                    ),
                    GradientButtonWithCustomIconAndFunction(
                        "assets/ui_icon/ic_erase.png",
                        () => {
                              setState(() {
                                listImageLayer[index] =
                                    Image.asset("assets/assets0sv1.png");
                                Navigator.of(context).pop();
                              }),
                            }),
                  ],
                );
              },
            ),
          ),
          actions: <Widget>[
            GradientCustomWidgetText(
                "Kembali ✨", () => {Navigator.of(context).pop()})
          ],
        );
      },
    );
  }

  Widget ComponentItemPart(
      String? assetName, double width, double heigth, int index) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(30.r),
        gradient: LinearGradient(
          colors: itemSelected == index
              ? [
                  Color.fromRGBO(255, 56, 182, 1),
                  Color.fromRGBO(255, 26, 136, 1),
                ]
              : [
                  Color.fromRGBO(255, 255, 255, 1),
                  Color.fromRGBO(255, 255, 255, 1),
                ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          Image.asset(
            Part21_class21.asset_0,
            width: width,
            height: heigth,
          ),
          Image.asset(
            assetName.toString(),
            width: width,
            height: heigth,
          ),
        ],
      ),
    );
  }

  bool isSelectedPart = false;
  bool isSelectedItem = false;
  GlobalKey globalKey = GlobalKey();

  Future<Uint8List> captureWidget() async {
    try {
      RenderRepaintBoundary boundary =
          globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 2.0);
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      return byteData!.buffer.asUint8List();
    } catch (e) {
      print(e);
      return Uint8List(0);
    }
  }

  Future<void> saveWidgetAsImage() async {
    Uint8List imageBytes = await captureWidget();

    // Save the image to device storage
    final result = await ImageGallerySaver.saveImage(imageBytes);
    if (result['isSuccess']) {
      print('Image saved successfully!');
    } else {
      print('Failed to save image.');
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Scaffold(
      body: ScreenUtilInit(
        builder: (context, child) {
          return Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                children: [
                  Center(
                    child: RepaintBoundary(
                      key: globalKey,
                      child: Stack(
                        children: List.generate(listImageLayer.length,
                            (index) => listImageLayer[index]),
                      ),
                    ),
                  ),
                  GradientButtonWithCustomIconAndFunction(
                      "assets/ui_icon/ic_back.png", () => {setState(() {})}),
                  Positioned(
                    right: 1,
                    bottom: 1,
                    child: GradientButtonWithCustomIconAndFunction(
                        "assets/ui_icon/ic_camera.png",
                        () => {saveWidgetAsImage()}),
                  ),
                  Positioned(
                    bottom: 1,
                    child: Column(
                      children: [
                        GradientButtonWithCustomIconAndFunction(
                            "assets/ui_icon/ic_layer.png",
                            () => {
                                  setState(() {
                                    showImageLayerDialog(context);
                                  })
                                }),
                        GradientButtonWithCustomIconAndFunction(
                            "assets/ui_icon/ic_erase.png",
                            () => {
                                  setState(() {
                                    listImageLayer
                                        .forEachIndexed((element, index) {
                                      listImageLayer[index] =
                                          Image.asset("assets/assets0sv1.png");
                                    });
                                  })
                                }),
                        GradientButtonWithCustomIconAndFunction(
                            "assets/ui_icon/ic_random.png",
                            () => {
                                  setState(() {
                                    listImageLayer
                                        .forEachIndexed((element, index) {
                                      int tnd = Random().nextInt(
                                          listItemMaker[index]
                                              .listItem!
                                              .length);
                                      listImageLayer[index] = Image.asset(
                                          listItemMaker[index].listItem![tnd]);
                                    });
                                  })
                                }),
                      ],
                    ),
                  ),
                  Align(
                      alignment: Alignment.center,
                      child:
                          GradientCustomWidgetText("Anime Maker ✨", () => {}))
                ],
              ),
              Container(),
              SizedBox(
                height: 100.h,
                child: ListView(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  physics: PageScrollPhysics(),
                  children: List.generate(
                      listItemMaker.length,
                      (index) => GestureDetector(
                            onTap: () {
                              setState(() {
                                partSelected = index;
                              });
                            },
                            child: ComponentItemAvatar(
                                listItemMaker[index], 100, 100, index),
                          )),
                ),
              ),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 5, // Number of columns
                  children: List.generate(
                      listItemMaker[partSelected].listItem!.length, (index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          listImageLayer[partSelected] = Image.asset(
                              listItemMaker[partSelected].listItem![index]);
                          itemSelected = index;
                        });
                      },
                      child: ComponentItemPart(
                          listItemMaker[partSelected].listItem![index],
                          200,
                          200,
                          index),
                    );
                  }),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
