import 'package:bson/bson.dart';

class _JsonKeys {
  static const String id = '_id';
  static const String username = 'username';
  static const String password = 'password';
  static const String streak = 'streak';
  static const String points = 'points';
  static const String activities = 'activities';
  static const String friends = 'friends';
  static const String incomingRequests = 'incoming_requests';
  static const String outgoingRequests = 'outgoing_requests';
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

class FriendshipRequest {
  final ObjectId userId;
  final DateTime sentAt;

  FriendshipRequest({
    required this.userId,
    required this.sentAt,
  });

  factory FriendshipRequest.fromJson(Map<String, dynamic> json) {
    return FriendshipRequest(
      userId: json[_JsonKeys.userId],
      sentAt: DateTime.parse(json[_JsonKeys.sentAt]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      _JsonKeys.userId: userId,
      _JsonKeys.sentAt: sentAt.toIso8601String(),
    };
  }
}

class User {
  final ObjectId id;
  final String username;
  final int streak;
  final int points;
  final List<String> activities;
  final List<String> friends;
  final List<FriendshipRequest> incomingRequests;
  final List<FriendshipRequest> outgoingRequests;

  User({
    required this.id,
    required this.username,
    this.streak = 0,
    this.points = 0,
    this.activities = const [],
    this.friends = const [],
    this.incomingRequests = const [],
    this.outgoingRequests = const [],
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json[_JsonKeys.id],
      username: json[_JsonKeys.username],
      streak: json[_JsonKeys.streak],
      points: json[_JsonKeys.points],
      activities: List<String>.from(json[_JsonKeys.activities]),
      friends: List<String>.from(json[_JsonKeys.friends]),
      incomingRequests: List<FriendshipRequest>.from(
        json[_JsonKeys.incomingRequests]
            .map((request) => FriendshipRequest.fromJson(request)),
      ),
      outgoingRequests: List<FriendshipRequest>.from(
        json[_JsonKeys.outgoingRequests]
            .map((request) => FriendshipRequest.fromJson(request)),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      _JsonKeys.id: id,
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
