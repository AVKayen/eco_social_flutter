import 'package:bson/bson.dart';
import 'package:image_input/image_input.dart';
import '/constants.dart';

Function calculateLevel = (int points) {
  return points ~/ 100;
};

Function calculateProgress = (int points) {
  return points % 100;
};

class _JsonKeys {
  static const String token = 'access_token';
  static const String tokenType = 'token_type';
  static const String password = 'password';

  static const String id = '_id';
  static const String username = 'username';

  static const String streak = 'streak';
  static const String points = 'points';
  static const String picture = 'profile_pic';
  static const String aboutMe = 'about_me';

  static const String activities = 'activities';
  static const String friends = 'friends';
  static const String friendCount = 'friend_count';
  static const String incomingRequests = 'incoming_requests';
  static const String outgoingRequests = 'outgoing_requests';
  static const String lastTimeOnStreak = 'last_time_on_streak';

  static const String userId = 'user_id';
  static const String sentAt = 'sent_at';
}

class UserForm {
  final String username;
  final String password;

  UserForm({
    required this.username,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      _JsonKeys.username: username,
      _JsonKeys.password: password,
    };
  }

  factory UserForm.fromJson(Map<String, dynamic> json) {
    return UserForm(
      username: json[_JsonKeys.username],
      password: json[_JsonKeys.password],
    );
  }
}

class RegisterForm extends UserForm {
  final XFile? picture;

  RegisterForm({
    required super.username,
    required super.password,
    this.picture,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      _JsonKeys.picture: picture,
    };
  }

  factory RegisterForm.fromJson(Map<String, dynamic> json) {
    return RegisterForm(
      username: json[_JsonKeys.username],
      password: json[_JsonKeys.password],
      picture: json[_JsonKeys.picture],
    );
  }
}

class Token {
  final String token;
  final String tokenType;

  Token({
    required this.token,
    this.tokenType = 'Bearer',
  });

  Map<String, dynamic> toJson() {
    return {
      _JsonKeys.token: token,
      _JsonKeys.tokenType: tokenType,
    };
  }

  factory Token.fromJson(Map<String, dynamic> json) {
    return Token(
      token: json[_JsonKeys.token],
      tokenType: json[_JsonKeys.tokenType],
    );
  }
}

class FriendshipRequest {
  final ObjectId userId;
  final DateTime sentAt;
  final String username;

  FriendshipRequest({
    required this.userId,
    required this.sentAt,
    this.username = '',
  });

  factory FriendshipRequest.fromJson(Map<String, dynamic> json) {
    return FriendshipRequest(
      userId: ObjectId.fromHexString(json[_JsonKeys.userId]),
      sentAt: DateTime.parse(json[_JsonKeys.sentAt]),
      username: json[_JsonKeys.username],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      _JsonKeys.userId: userId,
      _JsonKeys.sentAt: sentAt.toIso8601String(),
      _JsonKeys.username: username,
    };
  }
}

class User extends PrivateProfile {
  final List<FriendshipRequest> incomingRequests;
  final List<FriendshipRequest> outgoingRequests;
  final DateTime? lastTimeOnStreak;

  User({
    required super.id,
    required super.username,
    super.picture,
    required super.streak,
    required super.points,
    super.aboutMe,
    super.level,
    super.progress,
    super.friendCount,
    super.activities = const [],
    super.friends = const [],
    this.incomingRequests = const [],
    this.outgoingRequests = const [],
    this.lastTimeOnStreak,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    User user = User(
      id: ObjectId.fromHexString(json[_JsonKeys.id]),
      username: json[_JsonKeys.username],
      streak: json[_JsonKeys.streak],
      points: json[_JsonKeys.points],
      picture: (json[_JsonKeys.picture] == '')
          ? "${Constants.imageUrl}${json[_JsonKeys.picture]}"
          : null,
      level: calculateLevel(json[_JsonKeys.points]),
      progress: calculateProgress(json[_JsonKeys.points]),
      aboutMe: json[_JsonKeys.aboutMe],
      activities: List<ObjectId>.from(
          json[_JsonKeys.activities].map((id) => ObjectId.fromHexString(id))),
      friends: List<ObjectId>.from(
          json[_JsonKeys.friends].map((id) => ObjectId.fromHexString(id))),
      friendCount: json[_JsonKeys.friends].length,
      incomingRequests: List<FriendshipRequest>.from(
        json[_JsonKeys.incomingRequests]
            .map((request) => FriendshipRequest.fromJson(request)),
      ),
      outgoingRequests: List<FriendshipRequest>.from(
        json[_JsonKeys.outgoingRequests]
            .map((request) => FriendshipRequest.fromJson(request)),
      ),
      lastTimeOnStreak: (json[_JsonKeys.lastTimeOnStreak] == null)
          ? null
          : DateTime.parse(json[_JsonKeys.lastTimeOnStreak]),
    );

    return user;
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      _JsonKeys.id: id.oid,
      _JsonKeys.username: username,
      _JsonKeys.streak: streak,
      _JsonKeys.points: points,
      _JsonKeys.activities: activities,
      _JsonKeys.friends: friends,
      _JsonKeys.incomingRequests:
          incomingRequests.map((request) => request.toJson()).toList(),
      _JsonKeys.outgoingRequests:
          outgoingRequests.map((request) => request.toJson()).toList(),
    };
  }
}

class PublicProfile {
  final String? picture;
  final ObjectId id;
  final String username;
  final int streak;
  final int points;
  final int level;
  final int progress;
  final String? aboutMe;
  final int friendCount;

  PublicProfile({
    required this.id,
    required this.username,
    this.picture,
    required this.streak,
    required this.points,
    this.aboutMe = '',
    this.level = 0,
    this.progress = 0,
    required this.friendCount,
  });

  factory PublicProfile.fromJson(Map<String, dynamic> json) {
    return PublicProfile(
      id: ObjectId.fromHexString(json[_JsonKeys.id]),
      username: json[_JsonKeys.username],
      streak: json[_JsonKeys.streak],
      points: json[_JsonKeys.points],
      picture: (json[_JsonKeys.picture] == '')
          ? "${Constants.imageUrl}${json[_JsonKeys.picture]}"
          : null,
      level: calculateLevel(json[_JsonKeys.points]),
      progress: calculateProgress(json[_JsonKeys.points]),
      aboutMe: json[_JsonKeys.aboutMe],
      friendCount: json[_JsonKeys.friendCount],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      _JsonKeys.id: id.oid,
      _JsonKeys.username: username,
      _JsonKeys.streak: streak,
      _JsonKeys.points: points,
      _JsonKeys.picture: picture,
      _JsonKeys.aboutMe: aboutMe,
      _JsonKeys.friendCount: friendCount,
    };
  }
}

class PrivateProfile extends PublicProfile {
  final List<ObjectId> activities;
  final List<ObjectId> friends;

  PrivateProfile({
    required super.id,
    required super.username,
    super.picture,
    required super.streak,
    required super.points,
    super.aboutMe = null,
    super.level,
    super.progress,
    super.friendCount = 0,
    required this.activities,
    required this.friends,
  });

  @override
  factory PrivateProfile.fromJson(Map<String, dynamic> json) {
    return PrivateProfile(
      id: ObjectId.fromHexString(json[_JsonKeys.id]),
      username: json[_JsonKeys.username],
      streak: json[_JsonKeys.streak],
      points: json[_JsonKeys.points],
      picture: (json[_JsonKeys.picture] == '')
          ? "${Constants.imageUrl}${json[_JsonKeys.picture]}"
          : null,
      level: calculateLevel(json[_JsonKeys.points]),
      progress: calculateProgress(json[_JsonKeys.points]),
      aboutMe: json[_JsonKeys.aboutMe],
      activities: List<ObjectId>.from(
          json[_JsonKeys.activities].map((id) => ObjectId.fromHexString(id))),
      friends: List<ObjectId>.from(
          json[_JsonKeys.friends].map((id) => ObjectId.fromHexString(id))),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      _JsonKeys.id: id.oid,
      _JsonKeys.username: username,
      _JsonKeys.streak: streak,
      _JsonKeys.points: points,
      _JsonKeys.picture: picture,
      _JsonKeys.aboutMe: aboutMe,
      _JsonKeys.friendCount: friendCount,
      _JsonKeys.activities: activities,
      _JsonKeys.friends: friends,
    };
  }
}
