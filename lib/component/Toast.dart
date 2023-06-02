import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import '../util/SizeApp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ToastWidget {
  static void ToastEror(BuildContext context, String txt, String judul) {
    return CherryToast.error(
        animationDuration: Duration(milliseconds: 300),
        animationCurve: Curves.easeIn,
        title: Text(
          judul,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        displayTitle: true,
        animationType: AnimationType.fromTop,
        toastDuration: Duration(seconds: 3),
        description: Text(
          txt,
          style: TextStyle(fontSize: SizeApp.SizeTextDescription.sp),
        )).show(context);
  }

  static void ToastInfo(BuildContext context, String txt, String judul) {
    return CherryToast.info(
        animationDuration: Duration(milliseconds: 300),
        animationCurve: Curves.easeIn,
        title: Text(
          judul,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        displayTitle: true,
        animationType: AnimationType.fromTop,
        toastDuration: Duration(seconds: 3),
        description: Text(
          txt,
          style: TextStyle(fontSize: SizeApp.SizeTextDescription.sp),
        )).show(context);
  }

  static void ToastWarning(BuildContext context, String txt, String judul) {
    return CherryToast.warning(
        animationDuration: Duration(milliseconds: 300),
        animationCurve: Curves.easeIn,
        title: Text(
          judul,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        displayTitle: true,
        animationType: AnimationType.fromTop,
        toastDuration: Duration(seconds: 3),
        description: Text(
          txt,
          style: TextStyle(fontSize: SizeApp.SizeTextDescription.sp),
        )).show(context);
  }

  static void ToastSucces(BuildContext context, String txt, String judul) {
    return CherryToast.success(
            title: Text(
              judul,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            animationDuration: Duration(milliseconds: 300),
            animationCurve: Curves.easeIn,
            toastDuration: Duration(seconds: 2),
            animationType: AnimationType.fromTop,
            description: Text(txt))
        .show(context);
  }
}
