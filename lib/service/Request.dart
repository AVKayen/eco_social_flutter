import 'package:http/http.dart' as http;
import '/constants.dart';

typedef Response = http.Response;

// each method takes a path and an optional token and returns an http.Response
// post and put methods also take a body json-like map
class Request {
  static const String baseUrl = Constants.baseUrl;

  static Future<http.Response> _sendRequest(
      Future<http.Response> Function() request) async {
    final response = await request();
    return response;
  }

  static Map<String, String> _createHeaders(
      {String? token, Map<String, String>? predefHeaders}) {
    final headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      ...?predefHeaders,
    };
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  static Future<http.Response> get(String path,
      {String? token, Map<String, String>? headers}) async {
    return _sendRequest(() => http.get(
          Uri.parse('$baseUrl$path'),
          headers: _createHeaders(token: token, predefHeaders: headers),
        ));
  }

  static Future<http.Response> post(
    String path,
    dynamic body, {
    String? token,
    Map<String, String>? headers,
  }) async {
    return _sendRequest(() => http.post(
          Uri.parse('$baseUrl$path'),
          headers: _createHeaders(token: token, predefHeaders: headers),
          body: body,
        ));
  }

  static Future<http.Response> put(String path, dynamic body,
      {String? token, Map<String, String>? headers}) async {
    return _sendRequest(() => http.put(
          Uri.parse('$baseUrl$path'),
          headers: _createHeaders(token: token, predefHeaders: headers),
          body: body,
        ));
  }

  static Future<http.Response> delete(String path,
      {String? token, Map<String, String>? headers, dynamic body}) async {
    return _sendRequest(() => http.delete(
          Uri.parse('$baseUrl$path'),
          headers: _createHeaders(token: token, predefHeaders: headers),
          body: body,
        ));
  }
}
