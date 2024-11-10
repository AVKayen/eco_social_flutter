import 'package:flutter/material.dart';
import 'package:bson/bson.dart';
import 'package:provider/provider.dart';

import '/controller/CurrentUser.dart';
import '/controller/CurrentPage.dart';

import '/repository/UserRepository.dart';
import '/repository/ActivityRepository.dart';

import '/model/User.dart';
import '/model/Activity.dart';

import '/components/ActivityWidget.dart';

final _userRepository = TemplateUserRepository();
final _activityRepository = TemplateActivityRepository();

class ActivityView extends StatefulWidget {
  final ObjectId activityId;

  const ActivityView({super.key, required this.activityId});

  @override
  State<ActivityView> createState() => _ActivityViewState();
}

class _ActivityViewState extends State<ActivityView> {
  Activity? _activity;
  bool? _isCreator;

  void _getActivity() async {
    late User? user;
    final Activity? activity =
        await _activityRepository.getActivity(id: widget.activityId);
    if (activity == null) {
      throw Exception('Activity not found');
    }

    if (!mounted) {
      throw Exception('Widget not mounted, what?');
    }
    user = Provider.of<CurrentUser>(context, listen: false).user;

    if (user == null) {
      throw Exception('User not found');
    }

    if (user.id == activity.userId) {
      setState(() {
        _isCreator = true;
      });
    } else {
      setState(() {
        _isCreator = false;
      });
    }

    setState(() {
      _activity = activity;
    });
  }

  @override
  void initState() {
    super.initState();
    _getActivity();
  }

  @override
  void didUpdateWidget(ActivityView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.activityId != widget.activityId) {
      _getActivity();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CurrentPage>(builder:
        (BuildContext context, CurrentPage currentPage, Widget? child) {
      return _activity == null || _isCreator == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: _activity!.images.length,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      return Image.network(_activity!.images[index]);
                    },
                  ),
                  ActivityWidget(
                      activity: _activity!,
                      linkToProfile: !_isCreator!,
                      linkToActivity: false),
                ],
              ),
            );
    });
  }
}
