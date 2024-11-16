import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../util/color_app.dart';
import '../util/size_app.dart';
import 'component_text.dart';

class ComponentButtonPrimary extends StatelessWidget {
  String? buttonName;
  Function? func;
  Color? colorButton = ColorApp.primaryColor;
  double? sizeTextButton = SizeApp.sizeTextDescription;
  String? routeName;

  ComponentButtonPrimary(
    this.buttonName,
    this.func, {
    super.key,
    this.colorButton,
    this.sizeTextButton,
    this.routeName,
  });

  @override
  Widget build(BuildContext context) {
    return _button(context, func, buttonName);
  }

  Widget _button(BuildContext context, Function? function, String? buttonName) {
    return ElevatedButton(
      onPressed: () {
        Navigator.of(context).pushNamed(routeName.toString());
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: ColorApp.primaryColor,
        minimumSize: Size.fromHeight(55.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
      ),
      child: ComponentTextPrimaryTittleBold(
        text: buttonName,
        size: sizeTextButton,
      ),
    );
  }
}

class ComponentButtonChooseBirthDayPrimary extends StatelessWidget {
  String? buttonName;
  Function? func;
  Color? colorButton = ColorApp.primaryColor;
  double? sizeTextButton = SizeApp.sizeTextDescription;
  String? routeName;

  ComponentButtonChooseBirthDayPrimary(
    this.buttonName,
    this.func, {
    super.key,
    this.colorButton,
    this.sizeTextButton,
    this.routeName,
  });

  @override
  Widget build(BuildContext context) {
    return _button(context, func, buttonName);
  }

  Widget _button(BuildContext context, Function? function, String? buttonName) {
    return ElevatedButton(
      onPressed: () {
        Navigator.of(context).pushNamed(routeName.toString());
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: ColorApp.primaryColor,
        minimumSize: Size.fromHeight(55.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
      ),
      child: ComponentTextPrimaryTittleBold(
        text: buttonName,
        size: sizeTextButton,
      ),
    );
  }
}

class ComponentButtonChoosePhotoProfile extends StatelessWidget {
  String? buttonName;
  Function? func;
  Color? colorButton = ColorApp.secondaryButtonColor;
  double? sizeTextButton = SizeApp.sizeTextDescription;
  String? routeName;
  IconData? iconData;

  ComponentButtonChoosePhotoProfile(
    this.buttonName,
    this.func, {
    super.key,
    this.colorButton,
    this.sizeTextButton,
    this.routeName,
    this.iconData,
  });

  @override
  Widget build(BuildContext context) {
    return _button(context, func, buttonName, iconData);
  }

  Widget _button(
    BuildContext context,
    Function? function,
    String? buttonName,
    IconData? prefixIcon,
  ) {
    return ElevatedButton(
      onPressed: () {
        Navigator.of(context).pushNamed(routeName.toString());
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: colorButton,
        minimumSize: Size.fromHeight(55.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(
            prefixIcon,
            color: ColorApp.primaryColor,
          ),
          SizedBox(width: 10.0),
          ComponentTextPrimaryTittleBold(
            text: buttonName,
            size: sizeTextButton,
            colorText: ColorApp.primaryColor,
          ),
        ],
      ),
    );
  }
}

class ComponentButtonPrimaryWithFunction extends StatelessWidget {
  String? buttonName;
  Function? func;
  Color? colorButton = ColorApp.primaryColor;
  double? sizeTextButton = SizeApp.sizeTextDescription;
  String? routeName;

  ComponentButtonPrimaryWithFunction(
    this.buttonName,
    this.func, {
    super.key,
    this.colorButton,
    this.sizeTextButton,
    this.routeName,
  });

  @override
  Widget build(BuildContext context) {
    return _button(context, func, buttonName);
  }

  Widget _button(BuildContext context, Function? function, String? buttonName) {
    return ElevatedButton(
      onPressed: () {
        func!();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: ColorApp.primaryColor,
        minimumSize: Size.fromHeight(55.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
      ),
      child: ComponentTextPrimaryTittleBold(
        text: buttonName,
        size: sizeTextButton,
      ),
    );
  }
}

class ComponentButtonSecondary extends StatelessWidget {
  String? buttonName;
  Function? func;
  Color? colorButton = ColorApp.primaryColor;
  double? sizeTextButton = SizeApp.sizeTextDescription;
  String? routeName;

  ComponentButtonSecondary(
    this.buttonName,
    this.func, {
    super.key,
    this.colorButton,
    this.sizeTextButton,
    this.routeName,
  });

  @override
  Widget build(BuildContext context) {
    return _button(context, func, buttonName);
  }

  Widget _button(BuildContext context, Function? function, String? buttonName) {
    return ElevatedButton(
      onPressed: () => Navigator.of(context).pushNamed(routeName.toString()),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        minimumSize: Size.fromHeight(55.h),
        side: BorderSide(color: Colors.grey, width: 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
      ),
      child: ComponentTextPrimaryTittleBold(
        text: buttonName,
        size: sizeTextButton,
        colorText: ColorApp.primaryColor,
      ),
    );
  }
}

class GradientButtonWithCustomIconAndFunction extends StatefulWidget {
  final String? assetImage;
  final Function? func;

  const GradientButtonWithCustomIconAndFunction(
    this.assetImage,
    this.func, {
    super.key,
  });

  @override
  State<GradientButtonWithCustomIconAndFunction> createState() =>
      _GradientButtonWithCustomIconAndFunctionState();
}

class _GradientButtonWithCustomIconAndFunctionState
    extends State<GradientButtonWithCustomIconAndFunction> {
  double buttonSize = 56.0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 10.h,
        top: 10.h,
        bottom: 10.h,
        right: 10.h,
      ),
      child: Material(
        elevation: 8.0,
        shape: CircleBorder(),
        child: GestureDetector(
          onTapDown: (_) {
            setState(() => buttonSize = 76.0);
          },
          onTapUp: (_) {
            setState(() => buttonSize = 56.0);
            widget.func?.call();
          },
          onTapCancel: () {
            setState(() => buttonSize = 56.0);
          },
          child: AnimatedContainer(
            duration: Duration(milliseconds: 200),
            width: buttonSize.w,
            height: buttonSize.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(255, 56, 182, 1),
                  Color.fromRGBO(255, 26, 136, 1),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Image.asset(
                widget.assetImage.toString(),
                width: 28.0.w,
                height: 28.0.h,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class GradientCustomWidgetText extends StatelessWidget {
  String? assetImage;
  Function? func;

  GradientCustomWidgetText(
    this.assetImage,
    this.func, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        func!();
      },
      child: Padding(
        padding: EdgeInsets.all(10.0.h),
        child: Material(
          elevation: 10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.r),
          ),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(10.r),
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(255, 56, 182, 1),
                  Color.fromRGBO(255, 26, 136, 1),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(10.0.h),
              child: ComponentTextPrimaryDescriptionBold(
                text: "$assetImage",
                colorText: Colors.white,
                size: 15.sp,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
