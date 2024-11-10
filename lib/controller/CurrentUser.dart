import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/User.dart';
import '../repository/AuthRepository.dart';

AuthRepository _authRepository = TemplateAuthRepository();

class CurrentUser extends ChangeNotifier {
  User? _user;

  User? get user {
    if (_user == null) {
      loadFromStorage();
    }
    return _user;
  }

  void logout() {
    _user = null;
    notifyListeners();
  }

  Future<void> login(UserForm form) async {
    _authRepository.login(user: form).then((Token? token) async {
      if (token == null) {
        throw Exception('Token not found');
      }

      final User? user =
          await _authRepository.getUserByToken(token: token.token);

      if (user == null) {
        throw Exception('User not found');
      }

      _user = user;

      final SharedPreferencesAsync asyncPrefs = SharedPreferencesAsync();
      await asyncPrefs.setString('token', token.token);
      notifyListeners();
      return token;
    });
  }

  Future<void> loadFromStorage() async {
    final SharedPreferencesAsync asyncPrefs = SharedPreferencesAsync();

    final String? token = await asyncPrefs.getString('token');
    if (token == null || token.isEmpty) {
      throw Exception('Token not found');
    }
    final User? user = await _authRepository.getUserByToken(token: token);
    if (user == null) {
      throw Exception('User not found');
    }

    _user = user;
    notifyListeners();
  }
}
