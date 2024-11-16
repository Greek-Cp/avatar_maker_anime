import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../util/color_app.dart';

class TextFieldPassword extends StatefulWidget {
  TextEditingController? textEditingController;
  String? hintText;
  bool? passwordType = false;
  String? labelName;
  String? validationMessage;

  TextFieldPassword(
    this.textEditingController,
    this.hintText,
    this.passwordType,
    this.labelName,
    this.validationMessage, {
    super.key,
  });

  @override
  State<TextFieldPassword> createState() => _TextFieldPasswordState();
}

class _TextFieldPasswordState extends State<TextFieldPassword> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10.h),
        Text(
          "${widget.labelName}",
          style: GoogleFonts.dmSans(
            textStyle: TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 13.sp,
            ),
          ),
          textAlign: TextAlign.start,
        ),
        SizedBox(height: 5.h),
        TextFormField(
          validator: (value) {
            if (value!.isEmpty) {
              return "${widget.validationMessage} Tidak Boleh Kosong";
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
          controller: widget.textEditingController,
          textInputAction: TextInputAction.done,
          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.normal),
          decoration: InputDecoration(
            suffixIcon: IconButton(
              onPressed: () {
                setState(() => widget.passwordType = !widget.passwordType!);
              },
              icon: Icon(
                widget.passwordType! ? Icons.visibility : Icons.visibility_off,
                color: ColorApp.primaryColor,
              ),
            ),
            hintText: widget.hintText,
            contentPadding: EdgeInsets.all(15),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: ColorApp.primaryColor),
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 2, color: ColorApp.primaryColor),
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: ColorApp.primaryColor),
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class TextFieldImport {
  static Padding textForm({
    TextEditingController? textEditingController,
    String? hintText,
    bool? readOnly = false,
    String? labelName,
    String? validationMessage,
  }) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10.h),
          Text(
            "$labelName",
            style: GoogleFonts.dmSans(
              textStyle: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 13.sp,
              ),
            ),
            textAlign: TextAlign.start,
          ),
          SizedBox(height: 5.h),
          TextFormField(
            validator: (value) {
              if (value!.isEmpty) {
                return "$validationMessage Tidak Boleh Kosong";
              }
              return null;
            },
            readOnly: readOnly!,
            controller: textEditingController,
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.normal),
            decoration: InputDecoration(
              hintText: hintText,
              contentPadding: EdgeInsets.all(15),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 1, color: ColorApp.primaryColor),
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 2, color: ColorApp.primaryColor),
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(width: 1, color: ColorApp.primaryColor),
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Padding textFormMultiLine(
      {TextEditingController? textEditingController,
      String? hintText,
      bool? readOnly = false,
      String? labelName,
      String? validationMessage}) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10.h),
          Text(
            "$labelName",
            style: GoogleFonts.dmSans(
              textStyle: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 13.sp,
              ),
            ),
            textAlign: TextAlign.start,
          ),
          SizedBox(height: 5.h),
          TextFormField(
            validator: (value) {
              if (value!.isEmpty) {
                return "$validationMessage Tidak Boleh Kosong";
              }
              return null;
            },
            readOnly: readOnly!,
            minLines: 3,
            maxLines: 8,
            keyboardType: TextInputType.multiline,
            controller: textEditingController,
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.normal),
            decoration: InputDecoration(
              hintText: hintText,
              contentPadding: EdgeInsets.all(15),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 1, color: ColorApp.primaryColor),
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 2, color: ColorApp.primaryColor),
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(width: 1, color: ColorApp.primaryColor),
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Padding textFormName(
      {TextEditingController? textEditingController,
      String? hintText,
      bool? readOnly = false,
      String? labelName,
      String? validationMessage}) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10.h),
          Text(
            "$labelName",
            style: GoogleFonts.dmSans(
              textStyle: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 13.sp,
              ),
            ),
            textAlign: TextAlign.start,
          ),
          SizedBox(height: 5.h),
          TextFormField(
            validator: (value) {
              if (value!.isEmpty) {
                return "$validationMessage Tidak Boleh Kosong";
              }
              return null;
            },
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp('[a-zA-Z\\s]'))
            ],
            readOnly: readOnly!,
            controller: textEditingController,
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.normal),
            decoration: InputDecoration(
              hintText: hintText,
              contentPadding: EdgeInsets.all(15),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 1, color: ColorApp.primaryColor),
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 2, color: ColorApp.primaryColor),
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(width: 1, color: ColorApp.primaryColor),
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Padding textFormEmail(
      {TextEditingController? textEditingController,
      String? hintText,
      bool? readOnly = false,
      String? labelName,
      String? validationMessage}) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10.h),
          Text(
            "$labelName",
            style: GoogleFonts.dmSans(
              textStyle: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 13.sp,
              ),
            ),
            textAlign: TextAlign.start,
          ),
          SizedBox(height: 5.h),
          TextFormField(
            validator: (value) {
              if (value!.isEmpty) {
                return "$validationMessage Tidak Boleh Kosong";
              }
              final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
              if (!regex.hasMatch(value)) {
                return 'Format email tidak valid';
              }
              return null;
            },
            readOnly: readOnly!,
            controller: textEditingController,
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.normal),
            decoration: InputDecoration(
              hintText: hintText,
              contentPadding: EdgeInsets.all(15),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 1, color: ColorApp.primaryColor),
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 2, color: ColorApp.primaryColor),
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(width: 1, color: ColorApp.primaryColor),
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Column textFormPhone({
    TextEditingController? textEditingController,
    String? hintText,
    int? length,
    bool? readOnly = false,
    String? labelName,
    String? validationMessage,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10.h),
        Text(
          "$labelName",
          style: GoogleFonts.dmSans(
            textStyle: TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 13.sp,
            ),
          ),
          textAlign: TextAlign.start,
        ),
        SizedBox(height: 5.h),
        TextFormField(
          validator: (value) {
            if (value!.isEmpty) {
              return "$validationMessage Tidak Boleh Kosong";
            }
            return null;
          },
          controller: textEditingController,
          readOnly: readOnly!,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(length)
          ],
          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.normal),
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: hintText,
            contentPadding: EdgeInsets.all(15),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: ColorApp.primaryColor),
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 2, color: ColorApp.primaryColor),
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: ColorApp.primaryColor),
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
