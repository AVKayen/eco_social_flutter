import 'package:bson/bson.dart';
import 'dart:convert';

import '../model/User.dart';
import '../service/Request.dart';

abstract class UserRepository {
  // -> Future<PublicProfile | PrivateProfile | null>
  Future<dynamic> getUserProfile({required ObjectId id, required String token});

  Future<void> deleteUser({required ObjectId id, required String token});

  /*
  Future<User> addFriend(
      {required ObjectId userId, required ObjectId friendId});

  Future<User> removeFriend(
      {required ObjectId userId, required ObjectId friendId});

  Future<User> acceptFriendRequest(
      {required ObjectId userId, required ObjectId requestId});

  Future<User> rejectFriendRequest(
      {required ObjectId userId, required ObjectId requestId});

  Future<User> sendFriendRequest(
      {required ObjectId userId, required ObjectId friendId});
  */
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
      return PrivateProfile.fromJson(json.decode(response.body));
    }
    return PublicProfile.fromJson(json.decode(response.body));
  }

  @override
  Future<void> deleteUser({required ObjectId id, required String token}) async {
    final response = await Request.delete('/users/$id', token: token);
    if (response.statusCode != 200) {
      throw Exception('Failed to delete user');
    }
    return;
  }
}
