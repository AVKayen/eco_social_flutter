import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/User.dart';
import '../repository/UserRepository.dart';

final userRepository = TemplateUserRepository();

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  late Future<SharedPreferences> _prefs;

  @override
  void initState() {
    super.initState();
    _prefs = SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SharedPreferences>(
      future: _prefs,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        const token = '000000000000000000000001';
        return FutureBuilder<User>(
          future: userRepository.getUserByToken(token: token),
          builder: (context, userSnapshot) {
            if (userSnapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }

            if (userSnapshot.hasError) {
              return Text('Error: ${userSnapshot.error}');
            }

            final user = userSnapshot.data;
            return Column(
              children: [
                Text('Name: ${user?.username ?? 'N/A'}'),
                Text('Points: ${user?.points ?? 'N/A'}'),
                Text('Streak: ${user?.streak ?? 'N/A'}'),
              ],
            );
          },
        );
      },
    );
  }
}
