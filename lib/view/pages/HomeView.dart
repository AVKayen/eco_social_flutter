import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bson/bson.dart';
import 'package:provider/provider.dart';

import '/controller/CurrentUser.dart';

import '/repository/ActivityRepository.dart';

import '/model/Activity.dart';
import '/model/User.dart';

import '/components/ActivityWidget.dart';

final _activityRepository = HttpActivityRepository();

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late List<Activity> _activities = [];

  void _getActivites() async {
    final CurrentUser user = Provider.of<CurrentUser>(context, listen: false);

    final List<Activity> activities =
        await _activityRepository.getFriendsActivities(token: user.token!);
    setState(() {
      _activities = activities;
    });
  }

  @override
  void initState() {
    super.initState();
    _getActivites();
  }

  @override
  void didUpdateWidget(covariant HomeView oldWidget) {
    super.didUpdateWidget(oldWidget);
    _getActivites();
  }

  @override
  Widget build(BuildContext context) {
    return _activities == []
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : ListView.builder(
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
          );
  }
}
