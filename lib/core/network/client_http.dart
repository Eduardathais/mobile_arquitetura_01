import 'package:http/http.dart' as http;
import 'dart:convert';

class HttpClient {
  final http.Client _client = http.Client();

  Future<http.Response> get(String path) async {
    return await _client.get(Uri.parse(path));
  }

  Future<http.Response> post(
    String path, {
    Map<String, dynamic>? body,
  }) async {
    return await _client.post(
      Uri.parse(path),
      headers: {'Content-Type': 'application/json'},
      body: body == null ? null : jsonEncode(body),
    );
  }

  Future<http.Response> put(
    String path, {
    Map<String, dynamic>? body,
  }) async {
    return await _client.put(
      Uri.parse(path),
      headers: {'Content-Type': 'application/json'},
      body: body == null ? null : jsonEncode(body),
    );
  }

  Future<http.Response> delete(String path) async {
    return await _client.delete(Uri.parse(path));
  }
}
