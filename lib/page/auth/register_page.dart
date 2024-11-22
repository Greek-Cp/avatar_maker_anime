import 'dart:convert';

import 'package:avatar_maker/page/auth/login_page.dart';
import 'package:avatar_maker/service/authentication.dart';
import 'package:avatar_maker/util/color_app.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _hidePassword = false;

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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User registered successfully!')),
        );
      } else {
        String message = responseBody['message'] ?? 'An error occurred';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed: $message')),
        );
      }
    } catch (e) {
      // TODO: handle error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred. Please try again.')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
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
                          'Register',
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
                        TextField(
                          controller: _usernameController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color(0xfff0e3e2),
                            hintText: 'Username',
                            prefixIcon: Icon(
                              FluentIcons.person_24_filled,
                              color: Colors.grey[600],
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        TextField(
                          keyboardType: TextInputType.emailAddress,
                          controller: _emailController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color(0xfff0e3e2),
                            hintText: 'Email',
                            prefixIcon: Icon(
                              Icons.mail,
                              color: Colors.grey[600],
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        TextField(
                          obscureText: _hidePassword,
                          controller: _passwordController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color(0xfff0e3e2),
                            hintText: 'Password',
                            suffixIcon: IconButton(
                              icon: Icon(
                                _hidePassword
                                    ? FluentIcons.eye_off_24_regular
                                    : FluentIcons.eye_24_regular,
                                color: Colors.grey[600],
                              ),
                              onPressed: () {
                                setState(() {
                                  _hidePassword = !_hidePassword;
                                });
                              },
                            ),
                            prefixIcon: Icon(
                              Icons.lock,
                              color: Colors.grey[600],
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30.0),
                        Material(
                          shape: CircleBorder(),
                          child: GestureDetector(
                            onTap: () => _register(),
                            child: Container(
                              alignment: Alignment.center,
                              width: double.infinity,
                              height: 48,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(12),
                                ),
                                shape: BoxShape.rectangle,
                                gradient: LinearGradient(
                                  colors: [
                                    Color.fromRGBO(255, 56, 182, 1),
                                    ColorApp.primaryColor,
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                              child: _isLoading
                                  ? CircularProgressIndicator()
                                  : Text(
                                      'Sign Up',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            ),
                          ),
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
                                    text: 'Login here',
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
