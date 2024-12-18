import 'dart:convert';

import 'package:avatar_maker/component/button.dart';
import 'package:avatar_maker/component/text_field.dart';
import 'package:avatar_maker/component/toast.dart';
import 'package:avatar_maker/page/auth/login_page.dart';
import 'package:avatar_maker/service/authentication.dart';
import 'package:avatar_maker/util/color_app.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class RegisterPage extends StatefulWidget {
  static String? routeName = "/RegisterPage";

  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;

  Future<void> _register() async {
    FocusScope.of(context).unfocus();
    String email = _emailController.text.trim();
    String username = _usernameController.text.trim();
    String password = _passwordController.text.trim();

    setState(() => _isLoading = true);

    try {
      final response = await AuthService().register(username, email, password);

      int statusCode = response.statusCode;
      final Map<String, dynamic> responseBody = jsonDecode(response.body);

      // Handle status code
      if (statusCode == 201) {
        Toast.showSuccessToast(context, responseBody['message']);
        Get.to(LoginPage());
      } else {
        String message = responseBody['message'] ?? 'An error occurred';
        Toast.showErrorToast(context, message);
      }
    } catch (e) {
      Toast.showErrorToast(context, 'An error occurred. Please try again.');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: ColorApp.primaryColor,
        systemNavigationBarColor: ColorApp.backgroundNavigationBottomColor,
      ),
    );
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
            maxHeight: MediaQuery.of(context).size.height,
          ),
          decoration: const BoxDecoration(
            color: ColorApp.primaryColor,
            image: DecorationImage(
              image: AssetImage('assets/ui_icon/page_intro.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(
                flex: 2,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 12.0,
                    horizontal: 24.0,
                  ),
                ),
              ),
              Expanded(
                flex: 5,
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      topRight: Radius.circular(30.0),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 48, 24, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'You\'re New Here?',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 32.0,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const Text(
                          'Fill out the form below to register',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        TextFieldUsername(controller: _usernameController),
                        const SizedBox(height: 10.0),
                        TextFieldEmail(controller: _emailController),
                        const SizedBox(height: 10.0),
                        TextFieldPassword(controller: _passwordController),
                        const SizedBox(height: 30.0),
                        Button(
                          text: 'Sign Up',
                          onTap: () => _register(),
                          isLoading: _isLoading,
                        ),
                        const SizedBox(height: 10.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            RichText(
                              text: TextSpan(
                                children: [
                                  const TextSpan(
                                    text: 'Already have an account? ',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  TextSpan(
                                    text: 'Sign In here',
                                    style: TextStyle(
                                      color: Colors.blue[900],
                                      decoration: TextDecoration.underline,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () => Get.to(LoginPage()),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
