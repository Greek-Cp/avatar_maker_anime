import 'dart:convert';

import 'package:avatar_maker/model/user_model.dart';
import 'package:avatar_maker/util/user_preferences.dart';
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

  Future<UserModel?> loginWithGoogle() async {
    try {
      final response = await loginWithGoogleAPI(); // API login Google
      if (response != null && response.statusCode == 200) {
        final Map<String, dynamic> responseBody = json.decode(response.body);
        if (responseBody['success'] == true) {
          // Parsing ke UserModel
          return UserModel.fromJson(responseBody['user']);
        }
      }
    } catch (e) {
      // print("Error: $e");
    }
    return null;
  }

  Future<http.Response?> loginWithGoogleAPI() async {
    try {
      // Trigger Google Sign-In
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        // Sign-in aborted by user
        return null;
      }

      // Get the ID token from Google
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final String? token = googleAuth.idToken;

      if (token == null) {
        throw Exception("Failed to retrieve ID token");
      }

      // Send the ID token to backend
      final response = await http.post(
        Uri.parse('${dotenv.env['API_URL']}/auth/login-with-google'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-api-key': '${dotenv.env['API_KEY']}',
        },
        body: jsonEncode(<String, String>{'token': token}),
      );

      return response;
    } catch (e) {
      // print("Error during Google login: $e");
      return null;
    }
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
}
