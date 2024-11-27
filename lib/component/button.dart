import 'package:avatar_maker/component/typography.dart';
import 'package:avatar_maker/util/color_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GradientButtonWithCustomIconAndFunction extends StatefulWidget {
  final Icon? icon;
  final Function? func;

  const GradientButtonWithCustomIconAndFunction(
    this.icon,
    this.func, {
    super.key,
  });

  @override
  State<GradientButtonWithCustomIconAndFunction> createState() =>
      _GradientButtonWithCustomIconAndFunctionState();
}

class _GradientButtonWithCustomIconAndFunctionState
    extends State<GradientButtonWithCustomIconAndFunction> {
  double buttonSize = 48.0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.h),
      child: Material(
        elevation: 8.0,
        shape: CircleBorder(),
        child: GestureDetector(
          onTapDown: (_) {
            setState(() => buttonSize = 52.0);
          },
          onTapUp: (_) {
            setState(() => buttonSize = 48.0);
            widget.func?.call();
          },
          onTapCancel: () {
            setState(() => buttonSize = 48.0);
          },
          child: AnimatedContainer(
            duration: Duration(milliseconds: 100),
            width: buttonSize.w + 8,
            height: buttonSize.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(12),
              ),
              shape: BoxShape.rectangle,
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(255, 56, 182, 1),
                  ColorApp.primaryColor,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: widget.icon,
            ),
          ),
        ),
      ),
    );
  }
}

class GradientButtonWithCustomImageAndFunction extends StatefulWidget {
  final String? assetImage;
  final Function? func;

  const GradientButtonWithCustomImageAndFunction(
    this.assetImage,
    this.func, {
    super.key,
  });

  @override
  State<GradientButtonWithCustomImageAndFunction> createState() =>
      _GradientButtonWithCustomImageAndFunctionState();
}

class _GradientButtonWithCustomImageAndFunctionState
    extends State<GradientButtonWithCustomImageAndFunction> {
  double buttonSize = 48.0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.h),
      child: Material(
        elevation: 8.0,
        shape: CircleBorder(),
        child: GestureDetector(
          onTapDown: (_) {
            setState(() => buttonSize = 52.0);
          },
          onTapUp: (_) {
            setState(() => buttonSize = 48.0);
            widget.func?.call();
          },
          onTapCancel: () {
            setState(() => buttonSize = 48.0);
          },
          child: AnimatedContainer(
            duration: Duration(milliseconds: 100),
            width: buttonSize.w + 8,
            height: buttonSize.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(12),
              ),
              shape: BoxShape.rectangle,
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(255, 56, 182, 1),
                  ColorApp.primaryColor,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Image.asset(
                widget.assetImage.toString(),
                width: 24.w,
                height: 24.h,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class GradientCustomWidgetText extends StatefulWidget {
  final String? assetImage;
  final Function? func;

  const GradientCustomWidgetText(
    this.assetImage,
    this.func, {
    super.key,
  });

  @override
  State<GradientCustomWidgetText> createState() =>
      _GradientCustomWidgetTextState();
}

class _GradientCustomWidgetTextState extends State<GradientCustomWidgetText> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.func!();
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
                  ColorApp.primaryColor,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(10.0.h),
              child: DescriptionBold(
                text: "$widget.assetImage",
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

class Button extends StatelessWidget {
  final String? text;
  final bool isLoading;
  final GestureTapCallback? onTap;

  const Button({
    super.key,
    this.text,
    this.isLoading = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      shape: CircleBorder(),
      child: GestureDetector(
        onTap: onTap ?? () {},
        child: Container(
          alignment: Alignment.center,
          width: double.infinity,
          height: 48,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(7),
            ),
            color: ColorApp.primaryColor,
            shape: BoxShape.rectangle,
          ),
          child: isLoading
              ? CircularProgressIndicator()
              : Text(
                  text ?? '',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ),
    );
  }
}

class ButtonSecondary extends StatelessWidget {
  final String? text;
  final bool isLoading;
  final GestureTapCallback? onTap;

  const ButtonSecondary({
    super.key,
    this.text,
    this.isLoading = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      shape: CircleBorder(),
      child: GestureDetector(
        onTap: onTap ?? () {},
        child: Container(
          alignment: Alignment.center,
          width: double.infinity,
          height: 48,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(7),
            ),
            color: ColorApp.primaryColor,
            shape: BoxShape.rectangle,
          ),
          child: isLoading
              ? CircularProgressIndicator()
              : Text(
                  text ?? '',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: ColorApp.primaryColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ),
    );
  }
}
