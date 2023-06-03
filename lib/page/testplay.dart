import 'package:avatar_maker_anime/page/maker/PageMakerCharacter.dart';
import 'package:encrypted_asset_image/encrypted_asset_image.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:encrypted_asset_image/encrypted_asset_image.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
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

class Playground extends StatefulWidget {
  static String? routeName = "/PagePlayground";
  State<Playground> createState() => _PlaygroundState();
}

class _PlaygroundState extends State<Playground> {
  late final FileCryptor fileCryptor;

  List<Widget> encryptAssetImage = [];

  List<EncryptedAssetImage> listItemWget = [];

  List<Widget> listChildItem = [];
  int select_part = 0;
  @override
  void initState() {
    fileCryptor = FileCryptor(
      key:
          'VihW5CNfR9Fmhgz6b5AbUDQPsAzRWCA8', // This is your key with a length equal to 32
      iv: 16, // iv is Initialization vector encryption times
      dir: '', // Not required for this widget
    );

    listItemWget = List.generate(
        listItemMaker.length,
        (index) => EncryptedAssetImage(
              height: 140,
              width: 140,
              assetPath: listItemMaker[index].listItem![0],
              fileCryptor: fileCryptor,
            ));

    super.initState();
  }

  List<ItemMaker> listItemMaker = [
    ItemMaker(Part28_class28.asset_0, Part28_class28.listAssetpart28_class28),
    ItemMaker(Part27_class27.asset_0, Part27_class27.listAssetpart27_class27),
    ItemMaker(
        Part26_02class26.asset02_0, Part26_02class26.listAssetpart26_02class26),
    ItemMaker(
        Part25_01class25.asset01_0, Part25_01class25.listAssetpart25_01class25),
    ItemMaker(Part24_class24.asset_0, Part24_class24.listAssetpart24_class24),
  ];

  @override
  Widget build(BuildContext context) {
    listChildItem = List.generate(
      listItemMaker[select_part].listItem!.length,
      (index) => EncryptedAssetImage(
          width: 140,
          height: 140,
          assetPath: listItemMaker[select_part].listItem![index],
          fileCryptor: fileCryptor),
    );

    return MaterialApp(
      title: 'Flutter Encrypted Asset Image Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
          body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(
              height: 300,
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        select_part = index;
                        print("select part = $select_part");
                      });
                    },
                    child: EncryptedAssetImage(
                        width: 100,
                        height: 100,
                        assetPath: listItemMaker[index].listItem![0],
                        fileCryptor: fileCryptor),
                  );
                },
                scrollDirection: Axis.horizontal,
                itemCount: listItemWget.length,
              ),
            ),
            SizedBox(
              height: 1000,
              child: Expanded(
                child: GridView.count(
                  crossAxisCount: 5, // Number of columns
                  children: listChildItem,
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
