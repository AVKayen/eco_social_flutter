import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/User.dart';
import '../repository/AuthRepository.dart';

AuthRepository _authRepository = HttpAuthRepository();

class CurrentUser extends ChangeNotifier {
  User? _user;
  String? _token;

  User? get user {
    if (_user == null) {
      loadFromStorage();
    }

    return _user;
  }

  String? get token {
    if (_token == null || _token == '') {
      loadFromStorage();
    }
    return _token;
  }

  Future<bool> login(UserForm form) async {
    final Token? token = await _authRepository.login(user: form);
    if (token == null) {
      throw Exception('Token not found');
    }
    final User? user = await _authRepository.getCurrentUser(token: token.token);
    if (user == null) {
      throw Exception('User not found');
    }
    _token = token.token;
    _user = user;

    final SharedPreferencesAsync asyncPrefs = SharedPreferencesAsync();
    await asyncPrefs.setString('token', token.token);
    notifyListeners();
    return true;
  }

  Future<bool> register(RegisterForm form) async {
    await _authRepository.register(user: form);

    UserForm loginForm = UserForm(
      username: form.username,
      password: form.password,
    );

    final Token? token = await _authRepository.login(user: loginForm);
    if (token == null) {
      throw Exception('Token not found');
    }
    final User? user = await _authRepository.getCurrentUser(token: token.token);
    if (user == null) {
      throw Exception('User not found');
    }
    _token = token.token;
    _user = user;

    final SharedPreferencesAsync asyncPrefs = SharedPreferencesAsync();
    await asyncPrefs.setString('token', token.token);
    return true;
  }

  Future<void> logout() async {
    final SharedPreferencesAsync asyncPrefs = SharedPreferencesAsync();
    await asyncPrefs.remove('token');
    _token = null;
    _user = null;
    notifyListeners();
    return;
  }

  Future<void> refreshUser() async {
    final User? user = await _authRepository.getCurrentUser(token: token!);
    if (user == null) {
      throw Exception('User not found');
    }
    _user = user;

    notifyListeners();
    return;
  }

  Future<void> loadFromStorage() async {
    final SharedPreferencesAsync asyncPrefs = SharedPreferencesAsync();

    final String? token = await asyncPrefs.getString('token');
    if (token == null || token.isEmpty) {
      throw Exception('Token not found');
    }
    final User? user = await _authRepository.getCurrentUser(token: token);
    if (user == null) {
      throw Exception('User not found');
    }

    _token = token;
    _user = user;
    notifyListeners();
  }
}
