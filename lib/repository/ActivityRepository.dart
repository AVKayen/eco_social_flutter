import 'package:bson/bson.dart';

import '../model/Activity.dart';
import '../service/Request.dart';

abstract class ActivityRepository {
  Future<Activity?> getActivity({required ObjectId id});

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
      id: ObjectId.fromHexString('672748edb356bb7d062c5b24'),
      activityName: ActivityName.trashPicking,
      title: 'Picked up trash',
      caption: 'I picked up trash in the park',
      images: ['https://example.com/image.jpg'],
    ),
    Activity(
      id: ObjectId.fromHexString('672748f6f64cd020b0b322d2'),
      activityName: ActivityName.plantTree,
      title: 'Planted a tree',
      caption: 'I planted a tree in my garden',
      images: ['https://example.com/image.jpg'],
    ),
    Activity(
      id: ObjectId.fromHexString('672748d470e4e2a12d6cd21b'),
      activityName: ActivityName.buyLocal,
      title: 'Bought local',
      caption: 'I bought local produce from the market',
      images: ['https://example.com/image.jpg'],
    ),
    Activity(
      id: ObjectId.fromHexString('672748e315d90bf94058fb04'),
      activityName: ActivityName.reduceWater,
      title: 'Reduced water usage',
      caption: 'I reduced my water usage by taking shorter showers',
      images: ['https://example.com/image.jpg'],
    ),
  ];

  @override
  Future<Activity?> getActivity({required ObjectId id}) async {
    print('Getting activity with id: $id');
    print('Available activities:');
    for (var activity in _activities) {
      print('Activity id: ${activity.id}');
    }
    try {
      final activity = _activities.firstWhere((a) => a.id == id);
      return activity;
    } catch (e) {
      print('Error getting activity: $e');
      return null;
    }
  }

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

// Uncharted territory of ChatGPT code

class HttpActivityRepository implements ActivityRepository {
  @override
  Future<Activity> getActivity({required ObjectId id}) async {
    final response = await Request.get('/activities/$id');
    return Activity.fromJson(response);
  }

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
