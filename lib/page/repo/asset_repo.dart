import 'package:avatar_maker/assets_generated/Part0_class0.dart';
import 'package:avatar_maker/assets_generated/Part10_class10.dart';
import 'package:avatar_maker/assets_generated/Part11_class11.dart';
import 'package:avatar_maker/assets_generated/Part12_class12.dart';
import 'package:avatar_maker/assets_generated/Part13_class13.dart';
import 'package:avatar_maker/assets_generated/Part14_class14.dart';
import 'package:avatar_maker/assets_generated/Part15_class15.dart';
import 'package:avatar_maker/assets_generated/Part16_class16.dart';
import 'package:avatar_maker/assets_generated/Part17_class17.dart';
import 'package:avatar_maker/assets_generated/Part18_2class18.dart';
import 'package:avatar_maker/assets_generated/Part19_class19.dart';
import 'package:avatar_maker/assets_generated/Part1_class1.dart';
import 'package:avatar_maker/assets_generated/Part2_class2.dart';
import 'package:avatar_maker/assets_generated/Part3_class3.dart';
import 'package:avatar_maker/assets_generated/Part4_class4.dart';
import 'package:avatar_maker/assets_generated/Part5_class5.dart';
import 'package:avatar_maker/assets_generated/Part6_class6.dart';
import 'package:avatar_maker/assets_generated/Part7_class7.dart';
import 'package:avatar_maker/assets_generated/Part8_class8.dart';
import 'package:avatar_maker/assets_generated/Part9_class9.dart';
import 'package:avatar_maker/assets_generated/PartUpdate9.dart';
import 'package:avatar_maker/page/maker/create_char_page.dart';
import 'package:get/get.dart';

class AssetRepo extends GetxController {
  var listItemMaker = <ItemMaker>[
    ItemMaker(
      Part19_class19.asset_0,
      Part19_class19.listAssetpart19_class19,
    ), // 0
    ItemMaker(
      Part18_2class18.asset2_0,
      Part18_2class18.listAssetpart18_2class18,
    ), // 1
    ItemMaker(
      Part17_class17.asset_0,
      Part17_class17.listAssetpart17_class17,
    ), // 2
    ItemMaker(
      Part16_class16.asset_0,
      Part16_class16.listAssetpart16_class16,
    ), // 3
    ItemMaker(
      Part15_class15.asset_0,
      Part15_class15.listAssetpart15_class15,
    ), // 4
    ItemMaker(
      Part14_class14.asset_0,
      Part14_class14.listAssetpart14_class14,
    ), // 5
    ItemMaker(
      Part13_class13.asset_0,
      Part13_class13.listAssetpart13_class13,
    ), // 6
    ItemMaker(
      Part12_class12.asset_0,
      Part12_class12.listAssetpart12_class12,
    ), // 7
    ItemMaker(
      Part11_class11.asset_0,
      Part11_class11.listAssetpart11_class11,
    ), //8
    ItemMaker(
      Part10_class10.asset_0,
      Part10_class10.listAssetpart10_class10,
    ), //9
    ItemMaker(
      Part9_class9.asset_0,
      Part9_class9.listAssetpart9_class9,
    ), //10
    ItemMaker(
      Part8_class8.asset_0,
      Part8_class8.listAssetpart8_class8,
    ), //11
    ItemMaker(
      Part7_class7.asset_0,
      Part7_class7.listAssetpart7_class7,
    ), //12
    ItemMaker(
      Part6_class6.asset_0,
      Part6_class6.listAssetpart6_class6,
    ), //13
    ItemMaker(
      Part5_class5.asset_0,
      Part5_class5.listAssetpart5_class5,
    ), //14
    ItemMaker(
      Part4_class4.asset_0,
      Part4_class4.listAssetpart4_class4,
    ), //15 clothes
    ItemMaker(
      Part3_class3.asset_0,
      Part3_class3.listAssetpart3_class3,
    ), //16
    ItemMaker(
      Part2_class2.asset_0,
      Part2_class2.listAssetpart2_class2,
    ), //17
    ItemMaker(
      Part1_class1.asset_0,
      Part1_class1.listAssetpart1_class1,
    ), //18
    ItemMaker(
      Part0_class0.asset_0,
      Part0_class0.listAssetpart0_class0,
    ), //19
  ].obs;

  void updateRepo() {
    updateData(listItemMaker.length - 5, PartUpdate9.listUpdatePart9_class9);
  }

  void updateData(int itemSelectedIndex, List<String> listUpdateItem) {
    final itemList = listItemMaker[itemSelectedIndex].listItem;
    if (itemList != null) {
      itemList.insertAll(0, listUpdateItem);
    }
    // print("Update Success");
  }
}
