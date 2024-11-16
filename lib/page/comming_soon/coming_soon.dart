import 'package:avatar_maker/component/component_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ComingSoon extends StatelessWidget {
  const ComingSoon({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: (context, child) {
        return Scaffold(
          body: Center(
            child: ComponentTextPrimaryTittleBold(
              text: "Coming Soon...\n :)",
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
