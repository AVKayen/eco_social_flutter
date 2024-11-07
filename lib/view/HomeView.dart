import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bson/bson.dart';

import '../../components/ActivityWidget.dart';
import '../model/Activity.dart';
import '../repository/ActivityRepository.dart';

final _activityRepository = TemplateActivityRepository();

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late List<Activity> _activities = [];

  void _getActivites() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    if (token == null || token.isEmpty) {
      throw Exception('Token not found');
    }
    final List<Activity> activities = await _activityRepository
        .getUserActivities(userId: ObjectId.fromHexString(token));
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
