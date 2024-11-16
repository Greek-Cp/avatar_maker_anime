import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../util/color_app.dart';
import '../util/size_app.dart';

class ComponentTextPrimaryTittleRegular extends StatelessWidget {
  String? text;
  double? size = SizeApp.sizeTextHeader;
  Color? colorText = ColorApp.primaryColor;
  TextAlign? textAlign = TextAlign.start;

  ComponentTextPrimaryTittleRegular({
    super.key,
    this.text,
    this.size,
    this.colorText,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      "$text",
      textAlign: textAlign,
      style: GoogleFonts.poppins(
        fontSize: size,
        textStyle: TextStyle(color: colorText),
      ),
    );
  }
}

class ComponentTextPrimaryTittleBold extends StatelessWidget {
  String? text;
  double? size = SizeApp.sizeTextHeader;
  Color? colorText = ColorApp.primaryColor;
  TextAlign? textAlign = TextAlign.start;

  ComponentTextPrimaryTittleBold({
    super.key,
    this.text,
    this.size,
    this.colorText,
    this.textAlign,
  });
  @override
  Widget build(BuildContext context) {
    return Text(
      "$text",
      textAlign: textAlign,
      style: GoogleFonts.poppins(
          fontWeight: FontWeight.bold,
          fontSize: size,
          textStyle: TextStyle(color: colorText)),
    );
  }
}

class ComponentTextPrimaryDescriptionBold extends StatelessWidget {
  String? text;
  double? size = SizeApp.sizeTextDescription;
  Color? colorText = ColorApp.textSecondaryColor;
  TextAlign? textAlign = TextAlign.start;

  ComponentTextPrimaryDescriptionBold({
    super.key,
    this.text,
    this.size,
    this.colorText = Colors.black,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      "$text",
      textAlign: textAlign,
      style: GoogleFonts.poppins(
        fontSize: size,
        fontWeight: FontWeight.bold,
        textStyle: TextStyle(color: colorText),
      ),
    );
  }
}

class ComponentTextPrimaryDescriptionRegular extends StatelessWidget {
  String? text;
  double? size = SizeApp.sizeTextDescription;
  Color? colorText = ColorApp.textSecondaryColor;
  TextAlign? textAlign = TextAlign.start;
  FontWeight? fontWeight = FontWeight.normal;

  ComponentTextPrimaryDescriptionRegular({
    super.key,
    this.text,
    this.size,
    this.colorText = Colors.black,
    this.textAlign,
    this.fontWeight,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      "$text",
      textAlign: textAlign,
      style: GoogleFonts.poppins(
        fontSize: size,
        fontWeight: fontWeight,
        textStyle: TextStyle(color: colorText),
      ),
    );
  }
}
