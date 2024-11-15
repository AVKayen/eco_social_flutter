import 'package:bson/bson.dart';
import 'dart:convert';

import '../model/User.dart';
import '../service/Request.dart';

abstract class UserRepository {
  // -> Future<PublicProfile | PrivateProfile | null>
  Future<dynamic> getUserProfile({required ObjectId id, required String token});

  Future<void> deleteUser({required ObjectId id, required String token});

  Future<String> addFriend({required ObjectId userId, required String token});

  Future<String> removeFriend(
      {required ObjectId userId, required String token});

  Future<String> acceptFriendRequest(
      {required ObjectId userId, required String token});

  Future<String> rejectFriendRequest(
      {required ObjectId userId, required String token});

  Future<List<PublicProfile>> searchUsers(
      {required String query, required String token});
}

class HttpUserRepository implements UserRepository {
  @override
  Future<dynamic> getUserProfile(
      {required ObjectId id, required String token}) async {
    final response = await Request.get('/user/${id.oid}', token: token);
    if (response.statusCode != 200) {
      throw Exception('Failed to get user profile');
    }
    if (json.decode(response.body).containsKey('activities')) {
      return PrivateProfile.fromJson(
          json.decode(utf8.decode(response.bodyBytes)));
    }
    return PublicProfile.fromJson(json.decode(utf8.decode(response.bodyBytes)));
  }

  @override
  Future<void> deleteUser({required ObjectId id, required String token}) async {
    final response = await Request.delete('/users/$id', token: token);
    if (response.statusCode != 200) {
      throw Exception('Failed to delete user');
    }
    return;
  }

  @override
  Future<String> addFriend(
      {required ObjectId userId, required String token}) async {
    Map<String, String> body = {'user_id': userId.oid};
    final response = await Request.post(
        '/user/invitation/send', token: token, jsonEncode(body));
    if (response.statusCode != 200 || response.statusCode != 201) {
      throw Exception('Failed to send friend request');
    }
    return response.body;
  }

  @override
  Future<String> removeFriend(
      {required ObjectId userId, required String token}) async {
    Map<String, String> body = {'user_id': userId.oid};
    final response = await Request.delete('/user/delete-friend',
        token: token, body: jsonEncode(body));
    if (response.statusCode != 200) {
      throw Exception('Failed to remove friend');
    }
    return response.body;
  }

  @override
  Future<String> acceptFriendRequest(
      {required ObjectId userId, required String token}) async {
    Map<String, String> body = {'user_id': userId.oid};
    final response = await Request.post(
        '/user/invitation/accept', token: token, jsonEncode(body));
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to accept friend request');
    }
    return response.body;
  }

  @override
  Future<String> rejectFriendRequest(
      {required ObjectId userId, required String token}) async {
    Map<String, String> body = {'user_id': userId.oid};
    final response = await Request.delete('/user/invitation/decline',
        token: token, body: jsonEncode(body));
    if (response.statusCode != 200) {
      throw Exception('Failed to reject friend request');
    }
    return response.body;
  }

  @override
  Future<List<PublicProfile>> searchUsers(
      {required String query, required String token}) async {
    final response = await Request.get('/user/find/$query', token: token);
    if (response.statusCode != 200) {
      throw Exception('Failed to search users');
    }
    return List<PublicProfile>.from(
        (json.decode(utf8.decode(response.bodyBytes)) as List)
            .map((e) => PublicProfile.fromJson(e)));
  }
}
