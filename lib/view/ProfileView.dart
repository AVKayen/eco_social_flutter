import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../components/ProfileWidget.dart';
import '../model/User.dart';
import '../repository/UserRepository.dart';

final userRepository = TemplateUserRepository();

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  User? _user;

  void _getCurrentUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token') ?? '672748d470e4e2a12d6cd21b';
    if (token.isEmpty) {
      throw Exception('Token not found');
    }
    final User user = await userRepository.getUserByToken(token: token);
    setState(() {
      _user = user;
    });
  }

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return _user == null
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : ProfileWidget(user: _user!);
  }
}
