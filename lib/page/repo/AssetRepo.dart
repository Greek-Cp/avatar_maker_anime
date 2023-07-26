import 'package:avatar_maker_anime/page/maker/PageMakerCharacter.dart';
import 'package:get/get.dart';
import '../../assets_class/Part19_class19.dart';
import '../../assets_class/Part18_2class18.dart';
import '../../assets_class/Part17_class17.dart';
import '../../assets_class/Part16_class16.dart';
import '../../assets_class/Part15_class15.dart';
import '../../assets_class/Part14_class14.dart';
import '../../assets_class/Part13_class13.dart';
import '../../assets_class/Part12_class12.dart';
import '../../assets_class/Part11_class11.dart';
import '../../assets_class/Part10_class10.dart';
import '../../assets_class/Part9_class9.dart';
import '../../assets_class/Part8_class8.dart';
import '../../assets_class/Part7_class7.dart';
import '../../assets_class/Part6_class6.dart';
import '../../assets_class/Part5_class5.dart';
import '../../assets_class/Part4_class4.dart';
import '../../assets_class/Part3_class3.dart';
import '../../assets_class/Part2_class2.dart';
import '../../assets_class/Part1_class1.dart';
import '../../assets_class/Part0_class0.dart';

class AssetRepo extends GetxController {
  var listItemMaker = <ItemMaker>[
    ItemMaker(Part19_class19.asset_0, Part19_class19.listAssetpart19_class19),
    ItemMaker(
        Part18_2class18.asset2_0, Part18_2class18.listAssetpart18_2class18),
    ItemMaker(Part17_class17.asset_0, Part17_class17.listAssetpart17_class17),
    ItemMaker(Part16_class16.asset_0, Part16_class16.listAssetpart16_class16),
    ItemMaker(Part15_class15.asset_0, Part15_class15.listAssetpart15_class15),
    ItemMaker(Part14_class14.asset_0, Part14_class14.listAssetpart14_class14),
    ItemMaker(Part13_class13.asset_0, Part13_class13.listAssetpart13_class13),
    ItemMaker(Part12_class12.asset_0, Part12_class12.listAssetpart12_class12),
    ItemMaker(Part11_class11.asset_0, Part11_class11.listAssetpart11_class11),
    ItemMaker(Part10_class10.asset_0, Part10_class10.listAssetpart10_class10),
    ItemMaker(Part9_class9.asset_0, Part9_class9.listAssetpart9_class9),
    ItemMaker(Part8_class8.asset_0, Part8_class8.listAssetpart8_class8),
    ItemMaker(Part7_class7.asset_0, Part7_class7.listAssetpart7_class7),
    ItemMaker(Part6_class6.asset_0, Part6_class6.listAssetpart6_class6),
    ItemMaker(Part5_class5.asset_0, Part5_class5.listAssetpart5_class5),
    ItemMaker(Part4_class4.asset_0, Part4_class4.listAssetpart4_class4),
    ItemMaker(Part3_class3.asset_0, Part3_class3.listAssetpart3_class3),
    ItemMaker(Part2_class2.asset_0, Part2_class2.listAssetpart2_class2),
    ItemMaker(Part1_class1.asset_0, Part1_class1.listAssetpart1_class1),
    ItemMaker(Part0_class0.asset_0, Part0_class0.listAssetpart0_class0),
  ].obs;

  void updateRepo(){
      updateData(1  , Part19_class19.listAssetpart19_class19);

  }
  void updateData(int itemSelectedIndex, List<String> listUpdateItem) {
    List<String>? currentListPartFromItem =
        listItemMaker.value[itemSelectedIndex].listItem;
    currentListPartFromItem!.addAll(listUpdateItem);
    print("Update Succes");
  }
}
