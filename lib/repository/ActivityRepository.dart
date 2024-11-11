import 'package:bson/bson.dart';
import 'dart:convert';
import '../model/Activity.dart';
import '../service/Request.dart';

abstract class ActivityRepository {
  Future<Activity?> getActivity({
    required ObjectId id,
    required String token,
  });

  Future<List<Activity>> getFriendsActivities({
    required String token,
    int limit = 10,
  });

  Future<Activity?> createActivity({
    required Activity activity,
    required String token,
  });
}

// class TemplateActivityRepository implements ActivityRepository {
//   final List<Activity> _activities = [
//     Activity(
//       id: ObjectId.fromHexString('672748e315d90bf94058fb04'),
//       activityName: ActivityName.trashPicking,
//       title: 'Picked up trash',
//       streak: 1,
//       points: 1,
//       userId: ObjectId.fromHexString('672748e315d90bf94058fb04'),
//       caption: 'I picked up trash in the park',
//       images: [
//         'https://picsum.photos/200',
//         'https://picsum.photos/201',
//         'https://picsum.photos/202',
//         'https://picsum.photos/203',
//         'https://picsum.photos/204',
//         'https://picsum.photos/201',
//         'https://picsum.photos/202',
//         'https://picsum.photos/203',
//         'https://picsum.photos/204',
//         'https://picsum.photos/201',
//         'https://picsum.photos/202',
//         'https://picsum.photos/203',
//         'https://picsum.photos/204',
//       ],
//     ),
//     Activity(
//       id: ObjectId.fromHexString('672748f6f64cd020b0b322d2'),
//       activityName: ActivityName.plantTree,
//       title: 'Planted a tree',
//       streak: 1,
//       points: 1,
//       userId: ObjectId.fromHexString('672748edb356bb7d062c5b24'),
//       caption: 'I planted a tree in my garden',
//       images: ['https://picsum.photos/200'],
//     ),
//     Activity(
//       id: ObjectId.fromHexString('672748d470e4e2a12d6cd21b'),
//       activityName: ActivityName.buyLocal,
//       title: 'Bought local',
//       streak: 1,
//       points: 1,
//       userId: ObjectId.fromHexString('672748edb356bb7d062c5b24'),
//       caption: 'I bought local produce from the market',
//       images: ['https://picsum.photos/200'],
//     ),
//     Activity(
//       id: ObjectId.fromHexString('672748e315d90bf94058fb04'),
//       activityName: ActivityName.reduceWater,
//       title: 'Reduced water usage',
//       streak: 1,
//       points: 1,
//       userId: ObjectId.fromHexString('672748f6f64cd020b0b322d2'),
//       caption: 'I reduced my water usage by taking shorter showers',
//       images: ['https://picsum.photos/200'],
//     ),
//   ];

//   @override
//   Future<Activity?> getActivity({required ObjectId id}) async {
//     try {
//       final activity = _activities.firstWhere((a) => a.id == id);
//       return activity;
//     } catch (e) {
//       return null;
//     }
//   }

//   @override
//   Future<List<Activity>> getUserActivities(
//       {required ObjectId userId, int limit = 10}) async {
//     return _activities;
//   }

//   @override
//   Future<List<Activity>> getFriendsActivities(
//       {required ObjectId userId, int limit = 10}) async {
//     return _activities;
//   }

//   @override
//   Future<Activity> createActivity({required Activity activity}) async {
//     _activities.add(activity);
//     return activity;
//   }

//   @override
//   Future<Activity> updateActivity({required Activity activity}) async {
//     final index = _activities.indexWhere((a) => a.id == activity.id);
//     if (index != -1) {
//       _activities[index] = activity;
//     }
//     return activity;
//   }

//   @override
//   Future<Activity> deleteActivity({required ObjectId activityId}) async {
//     final index = _activities.indexWhere((a) => a.id == activityId);
//     if (index != -1) {
//       final activity = _activities[index];
//       _activities.removeAt(index);
//       return activity;
//     }
//     throw Exception('Activity not found');
//   }
// }

class HttpActivityRepository implements ActivityRepository {
  @override
  Future<Activity?> getActivity(
      {required ObjectId id, required String token}) async {
    final response = await Request.get('/activity/${id.oid}', token: token);
    if (response.statusCode != 200) return null;

    return Activity.fromJson(json.decode(response.body));
  }

  @override
  Future<List<Activity>> getFriendsActivities(
      {required String token, int limit = 10}) async {
    final response = await Request.get('/activity/feed', token: token);
    return List<Activity>.from(
        (json.decode(response.body) as List).map((e) => Activity.fromJson(e)));
  }

  @override
  Future<Activity?> createActivity(
      {required Activity activity, required String token}) async {
    final response =
        await Request.post('/activity', activity.toJson(), token: token);
    if (response.statusCode != 200) return null;
    return activity;
  }
}

// Uncharted territory of ChatGPT code

// class HttpActivityRepository implements ActivityRepository {
//   @override
//   Future<Activity> getActivity({required ObjectId id}) async {
//     final response = await Request.get('/activities/$id');
//     return Activity.fromJson(response);
//   }

//   @override
//   Future<List<Activity>> getUserActivities(
//       {required ObjectId userId, int limit = 10}) async {
//     final response = await Request.get('/activities/user/$userId?limit=$limit');
//     return List<Activity>.from(
//         (response as List).map((e) => Activity.fromJson(e)));
//   }

//   @override
//   Future<List<Activity>> getFriendsActivities(
//       {required ObjectId userId, int limit = 10}) async {
//     final response =
//         await Request.get('/activities/friends/$userId?limit=$limit');
//     return List<Activity>.from(
//         (response as List).map((e) => Activity.fromJson(e)));
//   }

//   @override
//   Future<Activity> createActivity({required Activity activity}) async {
//     final response =
//         await Request.post('/activities/activity', activity.toJson());
//     return Activity.fromJson(response);
//   }

//   @override
//   Future<Activity> updateActivity({required Activity activity}) async {
//     final response =
//         await Request.put('/activities/${activity.id}', activity.toJson());
//     return Activity.fromJson(response);
//   }

//   @override
//   Future<Activity> deleteActivity({required ObjectId activityId}) async {
//     final response = await Request.delete('/activities/$activityId');
//     return Activity.fromJson(response);
//   }
// }
