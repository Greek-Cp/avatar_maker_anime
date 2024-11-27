import 'dart:convert';

import 'package:avatar_maker/component/toast.dart';
import 'package:avatar_maker/model/user_model.dart';
import 'package:avatar_maker/util/user_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

class AuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final UserPreferences _userPrefs = UserPreferences();

  Future<http.Response> register(
    String username,
    String email,
    String password,
  ) {
    return http.post(
      Uri.parse('${dotenv.env['API_URL']}/auth/register'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'x-api-key': '${dotenv.env['API_KEY']}',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'username': username,
        'password': password,
      }),
    );
  }

  // Fungsi untuk login dengan email dan password
  Future<UserModel?> login(
      BuildContext context, String email, String password) async {
    final response = await _sendLoginRequest(email, password);
    if (response.statusCode == 200) {
      final user = UserModel.fromJson(jsonDecode(response.body)['user']);
      await saveUserAfterLogin(user);
      Toast.showSuccessToast(context, 'Login successful');
      return user;
    } else {
      _handleErrorResponse(context, response);
    }
    return null;
  }

  // Fungsi login dengan Google
  Future<UserModel?> loginWithGoogle(BuildContext context) async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        Toast.showErrorToast(context, 'Google Sign-In aborted by user');
        return null;
      }

      final googleAuth = await googleUser.authentication;
      final String? token = googleAuth.idToken;

      if (token == null) {
        Toast.showErrorToast(context, 'Failed to retrieve Google ID token');
        return null;
      }

      final response = await _sendGoogleLoginRequest(token);
      if (response != null && response.statusCode == 200) {
        return _handleGoogleLoginSuccess(context, response);
      } else {
        Toast.showErrorToast(context, 'Google login failed');
      }
    } catch (e) {
      Toast.showErrorToast(context, 'An error occurred: $e');
    }
    return null;
  }

  // Mengirim request login dengan email dan password
  Future<http.Response> _sendLoginRequest(String email, String password) async {
    return http.post(
      Uri.parse('${dotenv.env['API_URL']}/auth/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'x-api-key': '${dotenv.env['API_KEY']}',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );
  }

  // Mengirim request login menggunakan Google ID token
  Future<http.Response?> _sendGoogleLoginRequest(String token) async {
    try {
      return await http.post(
        Uri.parse('${dotenv.env['API_URL']}/auth/login-with-google'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-api-key': '${dotenv.env['API_KEY']}',
        },
        body: jsonEncode(<String, String>{'token': token}),
      );
    } catch (e) {
      print('Error during Google login API call: $e');
      return null;
    }
  }

  // Menangani response sukses dari login Google
  Future<UserModel?> _handleGoogleLoginSuccess(
      BuildContext context, http.Response response) async {
    final Map<String, dynamic> responseBody = json.decode(response.body);
    if (responseBody['success'] == true) {
      final user = UserModel.fromJson(responseBody['user']);
      await saveUserAfterLogin(user);
      Toast.showSuccessToast(context, responseBody['message']);
      return user;
    } else {
      Toast.showErrorToast(context, responseBody['message']);
    }
    return null;
  }

  // Menangani error yang didapat dari response
  void _handleErrorResponse(BuildContext context, http.Response response) {
    final data = jsonDecode(response.body);
    Toast.showErrorToast(context, data['message'] ?? 'Login failed');
  }

  Future<void> saveUserAfterLogin(UserModel user) async {
    await _userPrefs.saveUser(user);
  }

  Future<bool> isLoggedIn() async {
    final user = await _userPrefs.getUser();
    return user != null;
  }

  Future<void> logout() async {
    await _userPrefs.clearUser();
  }

  Future<UserModel?> getUser() async {
    final user = await _userPrefs.getUser();
    return user; // Mengembalikan user jika ada
  }
}
