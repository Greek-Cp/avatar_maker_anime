import 'package:avatar_maker_anime/Base.dart';
import 'package:avatar_maker_anime/Clothes.dart';
import 'package:avatar_maker_anime/Hats.dart';
import 'package:avatar_maker_anime/Multiple_color_hats.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  Widget itemAsset(String imageAssets) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      child: Image.asset(
        imageAssets,
        width: 50,
        height: 50,
        fit: BoxFit.cover,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int countTotalASset = Hats.ListAsset2_hats.length +
        Clothes.ListAsset0_clothes.length +
        Base.ListAsset3_base.length +
        Multiple_color_hats.ListAsset1_multiple_color_hats.length;

    return MaterialApp(
      home: Scaffold(
          body: SingleChildScrollView(
        physics: PageScrollPhysics(),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          SizedBox(
            height: 30,
          ),
          Text(
            "Integrated Test \n Generator Assets Flutter\ntotal Asset Loaded = $countTotalASset Gambar Terender",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 50,
            child: ListView.builder(
              shrinkWrap: true,
              physics: PageScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount:
                  Multiple_color_hats.ListAsset1_multiple_color_hats.length,
              itemBuilder: (context, index) {
                return itemAsset(
                    Multiple_color_hats.ListAsset1_multiple_color_hats[index]);
              },
            ),
          ),
          SizedBox(
            height: 50,
            child: ListView.builder(
              shrinkWrap: true,
              physics: PageScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: Hats.ListAsset2_hats.length,
              itemBuilder: (context, index) {
                return itemAsset(Hats.ListAsset2_hats[index]);
              },
            ),
          ),
          SizedBox(
            height: 50,
            child: ListView.builder(
              shrinkWrap: true,
              physics: PageScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: Base.ListAsset3_base.length,
              itemBuilder: (context, index) {
                return itemAsset(Base.ListAsset3_base[index]);
              },
            ),
          ),
          SizedBox(
            height: 50,
            child: ListView.builder(
              shrinkWrap: true,
              physics: PageScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: Clothes.ListAsset0_clothes.length,
              itemBuilder: (context, index) {
                return itemAsset(Clothes.ListAsset0_clothes[index]);
              },
            ),
          ),
          Wrap(
            children: List.generate(Hats.ListAsset2_hats.length,
                (index) => itemAsset(Hats.ListAsset2_hats[index])),
          ),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.start,
            children: List.generate(
                Multiple_color_hats.ListAsset1_multiple_color_hats.length,
                (index) => itemAsset(
                    Multiple_color_hats.ListAsset1_multiple_color_hats[index])),
          ),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.start,
            children: List.generate(Base.ListAsset3_base.length,
                (index) => itemAsset(Base.ListAsset3_base[index])),
          ),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.start,
            children: List.generate(Clothes.ListAsset0_clothes.length,
                (index) => itemAsset(Clothes.ListAsset0_clothes[index])),
          ),
        ]),
      )),
    );
  }
}
