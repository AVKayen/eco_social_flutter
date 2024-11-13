import 'package:flutter/material.dart';
import 'package:bson/bson.dart';
import 'package:provider/provider.dart';

import '/controller/CurrentUser.dart';

import '/repository/ActivityRepository.dart';

import '/model/Activity.dart';

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
    final CurrentUser currentUser =
        Provider.of<CurrentUser>(context, listen: false);

    if (currentUser.token == null || currentUser.user == null) {
      Navigator.pop(context);
      throw Exception('User not found');
    }

    final List<String> activities = await _activityRepository
        .getFriendsActivities(token: currentUser.token!);

    for (final String activityId in activities) {
      Activity? activity = await _activityRepository.getActivity(
          id: ObjectId.fromHexString(activityId), token: currentUser.token!);
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
