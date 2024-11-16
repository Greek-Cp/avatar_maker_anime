// import 'package:avatar_maker/page/repo/AssetRepo.dart';
// import 'package:encrypted_asset_image/encrypted_asset_image.dart';
// import 'package:avatar_maker/page/maker/PageMakerCharacter.dart';
// import 'package:flutter/material.dart';
// import 'dart:io';

// import 'package:encrypted_asset_image/encrypted_asset_image.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
// import 'package:get/get.dart';
// import 'package:path_provider/path_provider.dart';
// import '../../component/ComponentItem.dart';

// class Playground extends StatefulWidget {
//   static String? routeName = "/PagePlayground";
//   State<Playground> createState() => _PlaygroundState();
// }

// class _PlaygroundState extends State<Playground> {
//   late final FileCryptor fileCryptor;

//   List<Widget> encryptAssetImage = [];

//   List<EncryptedAssetImage> listItemWget = [];

//   List<Widget> listChildItem = [];

//   final RepositoryAsset = Get.put(AssetRepo());

//   int select_part = 0;
//   List<ItemMaker>? listItemMaker;
//   @override
//   void initState() {
//     listItemMaker = RepositoryAsset.listItemMaker;
//     fileCryptor = FileCryptor(
//       key:
//           'VihW5CNfR9Fmhgz6b5AbUDQPsAzRWCA8', // This is your key with a length equal to 32
//       iv: 16, // iv is Initialization vector encryption times
//       dir: '', // Not required for this widget
//     );

//     listItemWget = List.generate(
//         listItemMaker!.length,
//         (index) => EncryptedAssetImage(
//               height: 140,
//               width: 140,
//               assetPath: listItemMaker![index].listItem![0],
//               fileCryptor: fileCryptor,
//             ));

//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     listChildItem = List.generate(
//       listItemMaker![select_part].listItem!.length,
//       (index) => EncryptedAssetImage(
//           width: 140,
//           height: 140,
//           assetPath: listItemMaker![select_part].listItem![index],
//           fileCryptor: fileCryptor),
//     );

//     return MaterialApp(
//       title: 'Flutter Encrypted Asset Image Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: Scaffold(
//           body: SingleChildScrollView(
//         child: Column(
//           mainAxisSize: MainAxisSize.max,
//           children: [
//             SizedBox(
//               height: 300,
//               child: ListView.builder(
//                 itemBuilder: (context, index) {
//                   return GestureDetector(
//                     onTap: () {
//                       setState(() {
//                         select_part = index;
//                         print("select part = $select_part");
//                       });
//                     },
//                     child: EncryptedAssetImage(
//                         width: 100,
//                         height: 100,
//                         assetPath: listItemMaker![index].listItem![0],
//                         fileCryptor: fileCryptor),
//                   );
//                 },
//                 scrollDirection: Axis.horizontal,
//                 itemCount: listItemWget.length,
//               ),
//             ),
//             SizedBox(
//               height: 1000,
//               child: Expanded(
//                 child: AnimationLimiter(
//                   child: GridView.count(
//                     crossAxisCount: 5, // Number of columns
//                     children: List.generate(
//                         listChildItem.length,
//                         (index) => AnimationConfiguration.staggeredGrid(
//                             columnCount: 3,
//                             position: index,
//                             duration: Duration(seconds: 1000),
//                             child: ScaleAnimation(
//                                 child: FadeInAnimation(
//                                     child: listChildItem[index])))),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       )),
//     );
//   }
// }
