import '../util/SizeApp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Country {
  final String name;
  final String code;

  Country(this.name, this.code);
}

class PhoneTextField extends StatefulWidget {
  @override
  _PhoneTextFieldState createState() => _PhoneTextFieldState();
}

class _PhoneTextFieldState extends State<PhoneTextField> {
  Country? selectedCountry;

  List<Country> countries = [
    Country('Indonesia', '+62'),
    Country('United States', '+1'),
    Country('United Kingdom', '+44'),
    // Add more countries as needed
  ];

  TextEditingController _phoneController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: 'Phone Number',
        labelStyle: TextStyle(fontSize: (SizeApp.SizeTextDescription + 5).sp),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.r)),
      ),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Select Country'),
                    content: SingleChildScrollView(
                      child: ListBody(
                        children: countries
                            .map(
                              (country) => ListTile(
                                title: Text(
                                    country.name + "(" + country.code + ")"),
                                onTap: () {
                                  setState(() {
                                    selectedCountry = country;
                                  });
                                  Navigator.of(context).pop();
                                },
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  );
                },
              );
            },
            child: Text(
              selectedCountry?.code ?? '+',
              style: TextStyle(fontSize: SizeApp.SizeTextHeader.sp),
            ),
          ),
          SizedBox(
            width: 10.w,
          ),
          Container(
            color: Colors.grey,
            height: 20.h,
            width: 1.w,
          ),
          SizedBox(
            width: 10.w,
          ),
          Expanded(
            child: TextField(
              keyboardType: TextInputType.number,
              style: TextStyle(fontSize: SizeApp.SizeTextHeader.sp),
              controller: _phoneController,
              decoration: InputDecoration(
                hintText: 'Enter your phone number',
                hintStyle: TextStyle(fontSize: SizeApp.SizeTextHeader.sp),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: -1.0.h),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
