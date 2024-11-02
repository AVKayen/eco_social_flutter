import 'package:bson/bson.dart';

import '../model/Activity.dart';
import '../service/Request.dart';

abstract class ActivityRepository {
  Future<List<Activity>> getActivities({required ObjectId userId});

  Future<List<Activity>> getFriendsActivities(
      {required ObjectId userId, int limit = 10});

  Future<Activity> createActivity({required Activity activity});

  Future<Activity> updateActivity({required ObjectId activityId});

  Future<Activity> deleteActivity({required ObjectId activityId});
}
