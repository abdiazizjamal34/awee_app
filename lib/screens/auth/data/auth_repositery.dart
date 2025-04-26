import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/user_entity.dart';

class AuthRepository {
  final String baseUrl = "http://192.168.10.107:5000/api";
  // final String baseUrl = "http://localhost:5000/api";

  Future<UserEntity> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      // Save token + info
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', data['token']);
      await prefs.setString('name', data['name']);
      await prefs.setString('email', data['email']);
      await prefs.setString('role', data['role']);

      return UserEntity(
        id: data['_id'],
        name: data['name'],
        email: data['email'],
        token: data['token'],
        role: data['role'],
      );
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['message'] ?? 'Login failed');
    }
  }
}
