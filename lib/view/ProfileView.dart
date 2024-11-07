import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bson/bson.dart';

import '../../components/ProfileWidget.dart';
import '../model/User.dart';
import '../repository/UserRepository.dart';
import '../../components/ActivityWidget.dart';
import '../model/Activity.dart';
import '../repository/ActivityRepository.dart';

final _userRepository = TemplateUserRepository();
final _activityRepository = TemplateActivityRepository();

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  User? _user;
  final List<Activity> _activities = [];

  void _getCurrentUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    if (token == null || token.isEmpty) {
      throw Exception('Token not found');
    }
    final User user = await _userRepository.getUserByToken(token: token);
    setState(() {
      _user = user;
    });

    for (final ObjectId activityId in user.activities) {
      final Activity? activity =
          await _activityRepository.getActivity(id: activityId);
      if (activity != null) {
        setState(() {
          _activities.add(activity);
        });
      }
    }
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
        : Column(
            children: [
              ProfileWidget(user: _user!),
              Expanded(
                child: ListView.builder(
                  itemCount: _activities.length,
                  itemBuilder: (BuildContext context, int index) {
                    final Activity activity = _activities[index];
                    return Column(
                      children: [
                        ActivityWidget(activity: activity),
                        const Divider(
                          height: 0,
                          indent: 16,
                          endIndent: 16,
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          );
  }
}
