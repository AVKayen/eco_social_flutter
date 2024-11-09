import 'package:bson/bson.dart';

import '../model/User.dart';
import '../service/Request.dart';

abstract class UserRepository {
  Future<User?> getUser({required ObjectId id});

  Future<User?> getUserByToken({required String token});

  Future<User> createUser({required UserForm user});

  Future<User> updateUser({required User user});

  Future<User> deleteUser({required ObjectId id});

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

class TemplateUserRepository implements UserRepository {
  final List<User> _users = [
    User(
      id: ObjectId.fromHexString('672748d470e4e2a12d6cd21b'),
      username: 'user1',
      streak: 1,
      points: 1,
      picture: 'https://picsum.photos/200',
      activities: [
        ObjectId.fromHexString('672748edb356bb7d062c5b24'),
        ObjectId.fromHexString('672748f6f64cd020b0b322d2'),
      ],
      friends: [],
      incomingRequests: [],
      outgoingRequests: [],
    ),
    User(
      id: ObjectId.fromHexString('672748e315d90bf94058fb04'),
      username: 'user1',
      streak: 1,
      points: 41,
      picture: 'https://picsum.photos/200',
      activities: [
        ObjectId.fromHexString('672748d470e4e2a12d6cd21b'),
        ObjectId.fromHexString('672748e315d90bf94058fb04'),
      ],
      friends: [
        ObjectId.fromHexString('672748edb356bb7d062c5b24'),
        ObjectId.fromHexString('672748f6f64cd020b0b322d2'),
      ],
      incomingRequests: [],
      outgoingRequests: [],
    ),
    User(
      id: ObjectId.fromHexString('672748edb356bb7d062c5b24'),
      username: 'user1',
      streak: 1,
      points: 1,
      activities: [],
      friends: [],
      incomingRequests: [
        FriendshipRequest(
          userId: ObjectId.fromHexString('672748f6f64cd020b0b322d2'),
          sentAt: DateTime.now(),
        ),
      ],
      outgoingRequests: [],
    ),
    User(
      id: ObjectId.fromHexString('672748f6f64cd020b0b322d2'),
      username: 'user1',
      streak: 1,
      points: 1,
      activities: [],
      friends: [],
      incomingRequests: [],
      outgoingRequests: [
        FriendshipRequest(
          userId: ObjectId.fromHexString('672748edb356bb7d062c5b24'),
          sentAt: DateTime.now(),
        ),
      ],
    ),
  ];

  @override
  Future<User?> getUser({required ObjectId id}) async {
    return _users.firstWhere((user) => user.id == id);
  }

  @override
  Future<User?> getUserByToken({required String token}) async {
    return _users
        .firstWhere((user) => user.id == ObjectId.fromHexString(token));
  }

  @override
  Future<User> createUser({required UserForm user}) async {
    final newUser = User(
      id: ObjectId(),
      username: user.username,
      streak: 0,
      points: 0,
      activities: [],
      friends: [],
      incomingRequests: [],
      outgoingRequests: [],
    );
    _users.add(newUser);
    return newUser;
  }

  @override
  Future<User> updateUser({required User user}) async {
    final index = _users.indexWhere((u) => u.id == user.id);
    _users[index] = user;
    return user;
  }

  @override
  Future<User> deleteUser({required ObjectId id}) async {
    final user = _users.firstWhere((u) => u.id == id);
    _users.remove(user);
    return user;
  }
}

class HttpUserRepository implements UserRepository {
  @override
  Future<User> getUser({required ObjectId id}) async {
    final response = await Request.get('/user/$id');
    return User.fromJson(response);
  }

  @override
  Future<User> getUserByToken({required String token}) async {
    final response = await Request.get('/user/me', token);
    return User.fromJson(response);
  }

  @override
  Future<User> createUser({required UserForm user}) async {
    final response = await Request.post('/user/user', user.toJson());
    return User.fromJson(response);
  }

  @override
  Future<User> updateUser({required User user}) async {
    final response = await Request.put('/user/${user.id}', user.toJson());
    return User.fromJson(response);
  }

  @override
  Future<User> deleteUser({required ObjectId id}) async {
    final response = await Request.delete('/user/$id');
    return User.fromJson(response);
  }
}
