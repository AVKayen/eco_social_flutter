import 'dart:convert';
import 'package:http/http.dart' as http;

// each method takes a path and an optional token and returns a json-like map
// post and put methods also take a body json-like map
class Request {
  static const String API = 'http://localhost:8000';

  static Future<Map<String, dynamic>> _sendRequest(
      Future<http.Response> Function() request) async {
    final response = await request();

    if (response.statusCode != 200) {
      throw Exception('Http error: ${response.statusCode}');
    }

    return jsonDecode(response.body);
  }

  static Map<String, String> _createHeaders([String? token]) {
    final headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    };
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  static Future<Map<String, dynamic>> get(String path, [String? token]) async {
    return _sendRequest(() => http.get(
          Uri.parse('$API$path'),
          headers: _createHeaders(token),
        ));
  }

  static Future<Map<String, dynamic>> post(
      String path, Map<String, dynamic> body,
      [String? token]) async {
    return _sendRequest(() => http.post(
          Uri.parse('$API$path'),
          headers: _createHeaders(token),
          body: jsonEncode(body),
        ));
  }

  static Future<Map<String, dynamic>> put(
      String path, Map<String, dynamic> body,
      [String? token]) async {
    return _sendRequest(() => http.put(
          Uri.parse('$API$path'),
          headers: _createHeaders(token),
          body: jsonEncode(body),
        ));
  }

  static Future<Map<String, dynamic>> delete(String path,
      [String? token]) async {
    return _sendRequest(() => http.delete(
          Uri.parse('$API$path'),
          headers: _createHeaders(token),
        ));
  }
}
