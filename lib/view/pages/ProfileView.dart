import 'package:flutter/material.dart';
import 'package:bson/bson.dart';
import 'package:provider/provider.dart';

import '/controller/CurrentUser.dart';

import '/repository/UserRepository.dart';
import '/repository/ActivityRepository.dart';

import '/model/User.dart';
import '/model/Activity.dart';

import '/components/ProfileWidget.dart';
import '/components/ActivityWidget.dart';

final _userRepository = HttpUserRepository();
final _activityRepository = HttpActivityRepository();

class ProfileView extends StatefulWidget {
  final ObjectId? profileId;

  const ProfileView({super.key, this.profileId});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  dynamic _profile;
  final List<Activity> _activities = [];

  void _getProfile() async {
    final CurrentUser currentUser =
        Provider.of<CurrentUser>(context, listen: false);
    late dynamic profile;

    if (widget.profileId == null) {
      profile = currentUser.user!.toPrivateProfile();
    } else {
      profile = await _userRepository.getUserProfile(
          id: widget.profileId!, token: currentUser.token!);
    }

    if (profile == null) {
      throw Exception('User not found');
    }

    setState(() {
      _profile = profile!;
    });
    if (_profile.runtimeType == PrivateProfile) {
      for (final ObjectId activityId in _profile!.activities) {
        final Activity? activity = await _activityRepository.getActivity(
            id: activityId, token: currentUser.token!);
        if (activity != null) {
          setState(() {
            _activities.add(activity);
          });
        }
      }
    }
  }

  @override
  void didUpdateWidget(ProfileView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.profileId != widget.profileId) {
      _getProfile();
      _activities.clear();
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
                        ActivityWidget(activity: activity, showProfile: false),
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
