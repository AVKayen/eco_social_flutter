import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bson/bson.dart';

import '../../components/ProfileWidget.dart';
import '/model/User.dart';
import '/repository/UserRepository.dart';
import '/components/ActivityWidget.dart';
import '/model/Activity.dart';
import '/repository/ActivityRepository.dart';

final _userRepository = TemplateUserRepository();
final _activityRepository = TemplateActivityRepository();

class ProfileView extends StatefulWidget {
  final User user;
  final ObjectId? profileId;

  const ProfileView({super.key, required this.user, this.profileId});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  User? _profile;
  final List<Activity> _activities = [];

  void _getProfile() async {
    if (widget.profileId != null) {
      final User? profile =
          await _userRepository.getUser(id: widget.profileId!);
      if (profile == null) {
        throw Exception('User not found');
      }
      setState(() {
        _profile = profile;
      });
    } else {
      setState(() {
        _profile = widget.user;
      });
    }
    for (final ObjectId activityId in _profile!.activities) {
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
    _getProfile();
  }

  @override
  Widget build(BuildContext context) {
    return _profile == null
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Column(
            children: [
              ProfileWidget(user: _profile!),
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
