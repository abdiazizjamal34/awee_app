import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  // final String baseUrl = "http://10.0.2.2:5000/api"; // For Android Emulator
  // final String baseUrl = "http://localhost:5000/api";
  // For web Simulator
  final String baseUrl =
      "http://192.168.43.247:5000/api"; // For Android adB connected

  // late final SharedPreferences prefs;

  // AuthService() {
  //   _initializePrefs();
  // }

  // Future<void> _initializePrefs() async {
  //   prefs = await SharedPreferences.getInstance();
  // }

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      // Save token
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', data['token']);

      return {'success': true, 'user': data};
    } else {
      final error = jsonDecode(response.body);
      return {'success': false, 'message': error['message'] ?? 'Login failed'};
    }
  }
}
