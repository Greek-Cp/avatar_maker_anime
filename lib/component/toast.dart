import 'package:flutter/material.dart';
import 'package:toasty_box/toast_enums.dart';
import 'package:toasty_box/toasty_box.dart';

class Toast {
  static void showToast(BuildContext context, String message, Icon? icon) {
    ToastService.showToast(
      context,
      isClosable: true,
      backgroundColor: Colors.white,
      shadowColor: Colors.transparent,
      length: ToastLength.medium,
      expandedHeight: 100,
      message: message,
      leading: icon,
      slideCurve: Curves.elasticInOut,
      positionCurve: Curves.bounceOut,
      dismissDirection: DismissDirection.none,
    );
  }

  static void showSuccessToast(BuildContext context, String message) {
    ToastService.showSuccessToast(
      context,
      length: ToastLength.medium,
      backgroundColor: Colors.green.shade600,
      shadowColor: Colors.transparent,
      expandedHeight: 100,
      message: message,
    );
  }

  static void showErrorToast(BuildContext context, String message) {
    ToastService.showErrorToast(
      context,
      length: ToastLength.medium,
      backgroundColor: Colors.red,
      shadowColor: Colors.transparent,
      expandedHeight: 100,
      message: message,
    );
  }
}
