import 'package:flutter/material.dart';

class OtpCodeWidget extends StatefulWidget {
  @override
  _OtpCodeWidgetState createState() => _OtpCodeWidgetState();
}

class _OtpCodeWidgetState extends State<OtpCodeWidget> {
  List<String> otpCode = List.filled(4, '');

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        for (int i = 0; i < 4; i++) buildOtpTextField(i, otpCode[i].isEmpty),
      ],
    );
  }

  Widget buildOtpTextField(int index, bool isEmpty) {
    Color backgroundColor = isEmpty ? Colors.grey : Colors.red;

    return Container(
      width: 40.0,
      height: 40.0,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: TextField(
        textAlign: TextAlign.center,
        maxLength: 1,
        keyboardType: TextInputType.number,
        onChanged: (value) {
          setState(() {
            otpCode[index] = value;
          });
        },
        decoration: InputDecoration(
          counterText: '',
          border: InputBorder.none,
          errorBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: EdgeInsets.zero,
          isDense: true,
        ),
      ),
    );
  }
}
