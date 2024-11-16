import 'package:avatar_maker/component/ComponentText.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CommingSoon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ScreenUtilInit(
      builder: (context, child) {
        return Scaffold(
          body: Center(
            child: ComponentTextPrimaryTittleBold(
              teks: "Comming Soon...\n :)",
              colorText: Colors.black,
              size: 30,
              textAlign: TextAlign.center,
            ),
          ),
        );
      },
    );
  }
}
