import '../util/ColorApp.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class TextFieldPassword extends StatefulWidget {
  TextEditingController? text_kontrol;
  String? hintText;
  bool? passwordType = false;
  String? labelName;
  String? pesanValidasi;
  TextFieldPassword(this.text_kontrol, this.hintText, this.passwordType,
      this.labelName, this.pesanValidasi);

  @override
  State<TextFieldPassword> createState() => _TextFieldPasswordState();
}

class _TextFieldPasswordState extends State<TextFieldPassword> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 10.h,
        ),
        Text(
          "${widget.labelName}",
          style: GoogleFonts.dmSans(
              textStyle:
                  TextStyle(fontWeight: FontWeight.normal, fontSize: 13.sp)),
          textAlign: TextAlign.start,
        ),
        SizedBox(
          height: 5.h,
        ),
        TextFormField(
          validator: (value) {
            if (value!.isEmpty || value == null) {
              return "${widget.pesanValidasi} Tidak Boleh Kosong";
            }
            if (value.length < 7) {
              return 'Password minimal terdiri dari 7 karakter';
            }
            final regex = RegExp(r'^(?=.*?[A-Z])(?=.*?[0-9]).{7,}$');
            if (!regex.hasMatch(value)) {
              return 'Password harus mengandung huruf besar dan angka';
            }
            return null;
          },
          obscureText: !widget.passwordType!,
          controller: widget.text_kontrol,
          textInputAction: TextInputAction.done,
          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.normal),
          decoration: InputDecoration(
              suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      widget.passwordType = !widget.passwordType!;
                    });
                  },
                  icon: Icon(
                    widget.passwordType!
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: ColorApp.PrimaryColor,
                  )),
              hintText: widget.hintText,
              contentPadding: EdgeInsets.all(15),
              enabledBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(width: 1, color: ColorApp.PrimaryColor),
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              focusedBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(width: 2, color: ColorApp.PrimaryColor),
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              border: OutlineInputBorder(
                  borderSide:
                      BorderSide(width: 1, color: ColorApp.PrimaryColor),
                  borderRadius: BorderRadius.all(Radius.circular(10)))),
        ),
      ],
    );
  }
}

class TextFieldImport {
  static Padding TextForm(
      {TextEditingController? text_kontrol,
      String? hintText,
      bool? readyOnlyTydack = false,
      String? labelName,
      String? pesanValidasi}) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 10.h,
          ),
          Text(
            "${labelName}",
            style: GoogleFonts.dmSans(
                textStyle:
                    TextStyle(fontWeight: FontWeight.normal, fontSize: 13.sp)),
            textAlign: TextAlign.start,
          ),
          SizedBox(
            height: 5.h,
          ),
          TextFormField(
            validator: (value) {
              if (value!.isEmpty || value == null) {
                return "${pesanValidasi} Tidak Boleh Kosong";
              }
            },
            readOnly: readyOnlyTydack!,
            controller: text_kontrol,
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.normal),
            decoration: InputDecoration(
                hintText: hintText,
                contentPadding: EdgeInsets.all(15),
                enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(width: 1, color: ColorApp.PrimaryColor),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(width: 2, color: ColorApp.PrimaryColor),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                border: OutlineInputBorder(
                    borderSide:
                        BorderSide(width: 1, color: ColorApp.PrimaryColor),
                    borderRadius: BorderRadius.all(Radius.circular(10)))),
          ),
        ],
      ),
    );
  }

  static Padding TextFormMultiLine(
      {TextEditingController? text_kontrol,
      String? hintText,
      bool? readyOnlyTydack = false,
      String? labelName,
      String? pesanValidasi}) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 10.h,
          ),
          Text(
            "${labelName}",
            style: GoogleFonts.dmSans(
                textStyle:
                    TextStyle(fontWeight: FontWeight.normal, fontSize: 13.sp)),
            textAlign: TextAlign.start,
          ),
          SizedBox(
            height: 5.h,
          ),
          TextFormField(
            validator: (value) {
              if (value!.isEmpty || value == null) {
                return "${pesanValidasi} Tidak Boleh Kosong";
              }
            },
            readOnly: readyOnlyTydack!,
            minLines: 3,
            maxLines: 8,
            keyboardType: TextInputType.multiline,
            controller: text_kontrol,
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.normal),
            decoration: InputDecoration(
                hintText: hintText,
                contentPadding: EdgeInsets.all(15),
                enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(width: 1, color: ColorApp.PrimaryColor),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(width: 2, color: ColorApp.PrimaryColor),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                border: OutlineInputBorder(
                    borderSide:
                        BorderSide(width: 1, color: ColorApp.PrimaryColor),
                    borderRadius: BorderRadius.all(Radius.circular(10)))),
          ),
        ],
      ),
    );
  }

  static Padding TextFormNama(
      {TextEditingController? text_kontrol,
      String? hintText,
      bool? readyOnlyTydack = false,
      String? labelName,
      String? pesanValidasi}) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 10.h,
          ),
          Text(
            "${labelName}",
            style: GoogleFonts.dmSans(
                textStyle:
                    TextStyle(fontWeight: FontWeight.normal, fontSize: 13.sp)),
            textAlign: TextAlign.start,
          ),
          SizedBox(
            height: 5.h,
          ),
          TextFormField(
            validator: (value) {
              if (value!.isEmpty || value == null) {
                return "${pesanValidasi} Tidak Boleh Kosong";
              }
            },
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp('[a-zA-Z\\s]'))
            ],
            readOnly: readyOnlyTydack!,
            controller: text_kontrol,
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.normal),
            decoration: InputDecoration(
                hintText: hintText,
                contentPadding: EdgeInsets.all(15),
                enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(width: 1, color: ColorApp.PrimaryColor),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(width: 2, color: ColorApp.PrimaryColor),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                border: OutlineInputBorder(
                    borderSide:
                        BorderSide(width: 1, color: ColorApp.PrimaryColor),
                    borderRadius: BorderRadius.all(Radius.circular(10)))),
          ),
        ],
      ),
    );
  }

  static Padding TextFormEmail(
      {TextEditingController? text_kontrol,
      String? hintText,
      bool? readyOnlyTydack = false,
      String? labelName,
      String? pesanValidasi}) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 10.h,
          ),
          Text(
            "${labelName}",
            style: GoogleFonts.dmSans(
                textStyle:
                    TextStyle(fontWeight: FontWeight.normal, fontSize: 13.sp)),
            textAlign: TextAlign.start,
          ),
          SizedBox(
            height: 5.h,
          ),
          TextFormField(
            validator: (value) {
              if (value!.isEmpty || value == null) {
                return "${pesanValidasi} Tidak Boleh Kosong";
              }
              final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
              if (!regex.hasMatch(value)) {
                return 'Format email tidak valid';
              }
              return null;
            },
            readOnly: readyOnlyTydack!,
            controller: text_kontrol,
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.normal),
            decoration: InputDecoration(
                hintText: hintText,
                contentPadding: EdgeInsets.all(15),
                enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(width: 1, color: ColorApp.PrimaryColor),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(width: 2, color: ColorApp.PrimaryColor),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                border: OutlineInputBorder(
                    borderSide:
                        BorderSide(width: 1, color: ColorApp.PrimaryColor),
                    borderRadius: BorderRadius.all(Radius.circular(10)))),
          ),
        ],
      ),
    );
  }

  static Column TextFormTelp(
      {TextEditingController? text_kontrol,
      String? hintText,
      int? length,
      bool? readyOnlyTydack = false,
      String? labelName,
      String? pesanValidasi}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 10.h,
        ),
        Text(
          "${labelName}",
          style: GoogleFonts.dmSans(
              textStyle:
                  TextStyle(fontWeight: FontWeight.normal, fontSize: 13.sp)),
          textAlign: TextAlign.start,
        ),
        SizedBox(
          height: 5.h,
        ),
        TextFormField(
          validator: (value) {
            if (value!.isEmpty || value == null) {
              return "${pesanValidasi} Tidak Boleh Kosong";
            }
          },
          controller: text_kontrol,
          readOnly: readyOnlyTydack!,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(length)
          ],
          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.normal),
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
              hintText: hintText,
              contentPadding: EdgeInsets.all(15),
              // ignore: prefer_const_constructors
              enabledBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(width: 1, color: ColorApp.PrimaryColor),
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              // ignore: prefer_const_constructors
              focusedBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(width: 2, color: ColorApp.PrimaryColor),
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              // ignore: prefer_const_constructors
              border: OutlineInputBorder(
                  borderSide:
                      BorderSide(width: 1, color: ColorApp.PrimaryColor),
                  borderRadius: BorderRadius.all(Radius.circular(10)))),
        ),
      ],
    );
  }
}
