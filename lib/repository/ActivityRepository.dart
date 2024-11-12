import 'package:bson/bson.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
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

  Future<void> createActivity({
    required ActivityForm activity,
    required String token,
  });

  Future<void> deleteActivity({
    required ObjectId activityId,
    required String token,
  });
}

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
  Future<void> createActivity(
      {required ActivityForm activity, required String token}) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('${Request.baseUrl}/activity/'),
    );
    request.headers['Authorization'] = 'Bearer $token';
    request.headers['Content-Type'] = 'multipart/form-data';
    final images = activity.images;

    request.fields['title'] = activity.title;
    if (activity.caption != null) {
      request.fields['caption'] = activity.caption!;
    }
    request.fields['activity_type'] = activity.activityType.toString();

    for (var i = 0; i < images.length; i++) {
      dynamic file;
      file = http.MultipartFile.fromBytes(
        'images',
        await images[i].readAsBytes(),
        contentType: MediaType.parse('image/jpeg'),
        filename: 'image$i.png',
      );
      request.files.add(file);
    }
    final response = await request.send();
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to create activity');
    }

    return;
  }

  @override
  Future<void> deleteActivity(
      {required ObjectId activityId, required String token}) async {
    await Request.delete('/activity/${activityId.oid}', token: token);
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
