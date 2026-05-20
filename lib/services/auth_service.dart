import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:product_app/models/auth_user.dart';

class AuthService {
  static const _baseUrl = 'https://dummyjson.com/auth';

  Future<AuthUser> login({
    required String username,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'password': password,
        'expiresInMins': 30,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return AuthUser.fromJson(data);
    } else {
      throw Exception('Usuário ou senha inválidos');
    }
  }
}
