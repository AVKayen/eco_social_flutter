import 'package:bson/bson.dart';

import '../model/User.dart';
import '../service/Request.dart';

abstract class UserRepository {
  Future<User> getUser({required ObjectId id});

  Future<User> getUserByToken({required String token});

  Future<User> createUser({required UserForm user});

  Future<User> updateUser({required User user});

  Future<User> deleteUser({required ObjectId id});
}
