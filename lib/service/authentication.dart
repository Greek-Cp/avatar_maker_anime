import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class AuthService {
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
}
