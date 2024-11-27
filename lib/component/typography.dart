import 'package:avatar_maker/util/color_app.dart';
import 'package:avatar_maker/util/size_app.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TitleRegular extends StatefulWidget {
  final String text;
  final double? size = SizeApp.sizeTextHeader;
  final Color colorText;
  final TextAlign textAlign;

  TitleRegular({
    super.key,
    required this.text,
    size,
    this.colorText = ColorApp.primaryColor,
    this.textAlign = TextAlign.start,
  });

  @override
  State<TitleRegular> createState() => _TitleRegularState();
}

class _TitleRegularState extends State<TitleRegular> {
  @override
  Widget build(BuildContext context) {
    return Text(
      widget.text,
      textAlign: widget.textAlign,
      style: GoogleFonts.poppins(
        fontSize: widget.size,
        textStyle: TextStyle(color: widget.colorText),
      ),
    );
  }
}

class TitleBold extends StatefulWidget {
  final String text;
  final double? size = SizeApp.sizeTextHeader;
  final Color colorText;
  final TextAlign textAlign;

  TitleBold({
    super.key,
    required this.text,
    size,
    this.colorText = ColorApp.primaryColor,
    this.textAlign = TextAlign.start,
  });

  @override
  State<TitleBold> createState() => _TitleBoldState();
}

class _TitleBoldState extends State<TitleBold> {
  @override
  Widget build(BuildContext context) {
    return Text(
      widget.text,
      textAlign: widget.textAlign,
      style: GoogleFonts.poppins(
        fontWeight: FontWeight.bold,
        fontSize: widget.size,
        textStyle: TextStyle(color: widget.colorText),
      ),
    );
  }
}

class DescriptionRegular extends StatefulWidget {
  final String text;
  final double size = SizeApp.sizeTextDescription;
  final Color colorText;
  final TextAlign textAlign;
  final FontWeight fontWeight;

  DescriptionRegular({
    super.key,
    required this.text,
    size,
    this.colorText = ColorApp.textSecondaryColor,
    this.textAlign = TextAlign.start,
    this.fontWeight = FontWeight.normal,
  });

  @override
  State<DescriptionRegular> createState() => _DescriptionRegularState();
}

class _DescriptionRegularState extends State<DescriptionRegular> {
  @override
  Widget build(BuildContext context) {
    return Text(
      widget.text,
      textAlign: widget.textAlign,
      style: GoogleFonts.poppins(
        fontSize: widget.size,
        fontWeight: widget.fontWeight,
        textStyle: TextStyle(color: widget.colorText),
      ),
    );
  }
}

class DescriptionBold extends StatefulWidget {
  final String text;
  final double size = SizeApp.sizeTextDescription;
  final Color colorText;
  final TextAlign textAlign;

  DescriptionBold({
    super.key,
    required this.text,
    size,
    this.colorText = ColorApp.textSecondaryColor,
    this.textAlign = TextAlign.start,
  });

  @override
  State<DescriptionBold> createState() => _DescriptionBoldState();
}

class _DescriptionBoldState extends State<DescriptionBold> {
  @override
  Widget build(BuildContext context) {
    return Text(
      widget.text,
      textAlign: widget.textAlign,
      style: GoogleFonts.poppins(
        fontSize: widget.size,
        fontWeight: FontWeight.bold,
        textStyle: TextStyle(color: widget.colorText),
      ),
    );
  }
}
