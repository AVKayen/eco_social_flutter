import 'package:bson/bson.dart';

import '../model/Activity.dart';
import '../service/Request.dart';

abstract class ActivityRepository {
  Future<List<Activity>> getUserActivities(
      {required ObjectId userId, int limit = 10});

  Future<List<Activity>> getFriendsActivities(
      {required ObjectId userId, int limit = 10});

  Future<Activity> createActivity({required Activity activity});

  Future<Activity> updateActivity({required Activity activity});

  Future<Activity> deleteActivity({required ObjectId activityId});
}

class TemplateActivityRepository implements ActivityRepository {
  final List<Activity> _activities = [
    Activity(
      id: ObjectId.fromHexString('000000000000000000000001'),
      activityType: ActivityType.trashPicking,
      title: 'Picked up trash',
      caption: 'I picked up trash in the park',
      images: ['https://example.com/image.jpg'],
    ),
    Activity(
      id: ObjectId.fromHexString('000000000000000000000002'),
      activityType: ActivityType.plantTree,
      title: 'Planted a tree',
      caption: 'I planted a tree in my garden',
      images: ['https://example.com/image.jpg'],
    ),
    Activity(
      id: ObjectId.fromHexString('000000000000000000000003'),
      activityType: ActivityType.buyLocal,
      title: 'Bought local',
      caption: 'I bought local produce from the market',
      images: ['https://example.com/image.jpg'],
    ),
    Activity(
      id: ObjectId.fromHexString('000000000000000000000004'),
      activityType: ActivityType.reduceWater,
      title: 'Reduced water usage',
      caption: 'I reduced my water usage by taking shorter showers',
      images: ['https://example.com/image.jpg'],
    ),
    Activity(
      id: ObjectId.fromHexString('000000000000000000000005'),
      activityType: ActivityType.other,
      title: 'Other activity',
      caption: 'This is an example of an activity with no specific type',
      images: ['https://example.com/image.jpg'],
    ),
  ];

  @override
  Future<List<Activity>> getUserActivities(
      {required ObjectId userId, int limit = 10}) async {
    return _activities;
  }

  @override
  Future<List<Activity>> getFriendsActivities(
      {required ObjectId userId, int limit = 10}) async {
    return _activities;
  }

  @override
  Future<Activity> createActivity({required Activity activity}) async {
    _activities.add(activity);
    return activity;
  }

  @override
  Future<Activity> updateActivity({required Activity activity}) async {
    final index = _activities.indexWhere((a) => a.id == activity.id);
    if (index != -1) {
      _activities[index] = activity;
    }
    return activity;
  }

  @override
  Future<Activity> deleteActivity({required ObjectId activityId}) async {
    final index = _activities.indexWhere((a) => a.id == activityId);
    if (index != -1) {
      final activity = _activities[index];
      _activities.removeAt(index);
      return activity;
    }
    throw Exception('Activity not found');
  }
}

class HttpActivityRepository implements ActivityRepository {
  @override
  Future<List<Activity>> getUserActivities(
      {required ObjectId userId, int limit = 10}) async {
    final response = await Request.get('/activities/user/$userId?limit=$limit');
    return List<Activity>.from(
        (response as List).map((e) => Activity.fromJson(e)));
  }

  @override
  Future<List<Activity>> getFriendsActivities(
      {required ObjectId userId, int limit = 10}) async {
    final response =
        await Request.get('/activities/friends/$userId?limit=$limit');
    return List<Activity>.from(
        (response as List).map((e) => Activity.fromJson(e)));
  }

  @override
  Future<Activity> createActivity({required Activity activity}) async {
    final response =
        await Request.post('/activities/activity', activity.toJson());
    return Activity.fromJson(response);
  }

  @override
  Future<Activity> updateActivity({required Activity activity}) async {
    final response =
        await Request.put('/activities/${activity.id}', activity.toJson());
    return Activity.fromJson(response);
  }

  @override
  Future<Activity> deleteActivity({required ObjectId activityId}) async {
    final response = await Request.delete('/activities/$activityId');
    return Activity.fromJson(response);
  }
}
