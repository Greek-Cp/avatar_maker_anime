import '../util/ColorApp.dart';
import '../util/SizeApp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class ComponentTextPrimaryTittleRegular extends StatelessWidget {
  String? teks;
  double? size = SizeApp.SizeTextHeader;
  Color? colorText = ColorApp.PrimaryColor;
  TextAlign? textALign = TextAlign.start;
  ComponentTextPrimaryTittleRegular(
      {this.teks, this.size, this.colorText, this.textALign});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Text(
      "$teks",
      textAlign: textALign,
      style: GoogleFonts.poppins(
          fontSize: this.size, textStyle: TextStyle(color: colorText)),
    );
  }
}

class ComponentTextPrimaryTittleBold extends StatelessWidget {
  String? teks;
  double? size = SizeApp.SizeTextHeader;
  Color? colorText = ColorApp.PrimaryColor;
  TextAlign? textAlign = TextAlign.start;

  ComponentTextPrimaryTittleBold(
      {this.teks, this.size, this.colorText, this.textAlign});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Text(
      "$teks",
      textAlign: textAlign,
      style: GoogleFonts.poppins(
          fontWeight: FontWeight.bold,
          fontSize: this.size,
          textStyle: TextStyle(color: colorText)),
    );
  }
}

class ComponentTextPrimaryDescriptionBold extends StatelessWidget {
  String? teks;
  double? size = SizeApp.SizeTextDescription;
  Color? colorText = ColorApp.TextSecondaryColor;
  TextAlign? textAlign = TextAlign.start;

  ComponentTextPrimaryDescriptionBold(
      {this.teks, this.size, this.colorText = Colors.black, this.textAlign});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Text(
      "$teks",
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
  String? teks;
  double? size = SizeApp.SizeTextDescription;
  Color? colorText = ColorApp.TextSecondaryColor;
  TextAlign? textAlign = TextAlign.start;
  FontWeight? fontWeight = FontWeight.normal;

  ComponentTextPrimaryDescriptionRegular(
      {this.teks,
      this.size,
      this.colorText = Colors.black,
      this.textAlign,
      this.fontWeight});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Text(
      "$teks",
      textAlign: textAlign,
      style: GoogleFonts.poppins(
        fontSize: size,
        fontWeight: fontWeight,
        textStyle: TextStyle(color: colorText),
      ),
    );
  }
}
