import 'package:flutter/material.dart';
import 'package:bson/bson.dart';
import 'package:provider/provider.dart';

import '/controller/CurrentUser.dart';
import '/controller/CurrentPage.dart';

import '/repository/UserRepository.dart';
import '/repository/ActivityRepository.dart';

import '/model/Activity.dart';

import '/components/ActivityWidget.dart';

final _userRepository = HttpUserRepository();
final _activityRepository = HttpActivityRepository();

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
    late CurrentUser? user;

    user = Provider.of<CurrentUser>(context, listen: false);

    final Activity? activity = await _activityRepository.getActivity(
        id: widget.activityId, token: user.token!);
    if (activity == null) {
      throw Exception('Activity not found');
    }

    if (user.user!.id == activity.userId) {
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

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete activity'),
          content: const Text('Are you sure you want to delete this activity?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: _deleteActivity,
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _deleteActivity() async {
    final CurrentUser currentUser =
        Provider.of<CurrentUser>(context, listen: false);

    final CurrentPage currentPage =
        Provider.of<CurrentPage>(context, listen: false);

    await _activityRepository.deleteActivity(
        activityId: widget.activityId, token: currentUser.token!);

    currentPage.goBack();
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
              child: ListView(
                children: [
                  ActivityWidget(
                      activity: _activity!,
                      linkToProfile: !_isCreator!,
                      linkToActivity: false),
                  if (_isCreator!)
                    ElevatedButton(
                      onPressed: _showDeleteDialog,
                      child: const Text('Delete activity'),
                    ),
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
                      return GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Dialog(
                                child: InteractiveViewer(
                                  child:
                                      Image.network(_activity!.images[index]),
                                ),
                              );
                            },
                          );
                        },
                        child: Image.network(_activity!.images[index]),
                      );
                    },
                  ),
                ],
              ),
            );
    });
  }
}
