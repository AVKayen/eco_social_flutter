import 'package:bson/bson.dart';
import 'dart:convert';

import '../model/User.dart';
import '../service/Request.dart';

abstract class AuthRepository {
  Future<User?> getCurrentUser({required String token});

  Future<Token?> login({required UserForm user});

  Future<Token?> register({required RegisterForm user});
}

class HttpAuthRepository implements AuthRepository {
  @override
  Future<User?> getCurrentUser({required String token}) async {
    final Response response =
        await Request.get('/user/my-profile', token: token, headers: {});
    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body));
    }
    return null;
  }

  @override
  Future<Token?> login({required UserForm user}) async {
    Map<String, String> headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'accept': 'application/json',
    };
    final Response response =
        await Request.post('/token', user.toJson(), headers: headers);
    if (response.statusCode == 200) {
      return Token.fromJson(json.decode(response.body));
    }
    return null;
  }

  @override
  Future<Token?> register({required RegisterForm user}) async {
    // TEMP
    UserForm userForm = UserForm(
      username: user.username,
      password: user.password,
    );
    Map<String, String> headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'accept': 'application/json',
    };

    final Response response =
        await Request.post('/signup', userForm.toJson(), headers: headers);
    if (response.statusCode == 200) {
      return Token.fromJson(json.decode(response.body));
    }
    return null;
  }
}
