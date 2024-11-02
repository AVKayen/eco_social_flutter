import 'package:bson/bson.dart';

class _JsonKeys {
  static const String id = '_id';
  static const String activityType = 'activity_type';
  static const String title = 'title';
  static const String caption = 'caption';
  static const String images = 'images';
}

class ActivityType {
  static const int trashPicking = 1;

  static const int pubTransportInsteadOfCar = 11;
  static const int bikeInsteadOfCar = 12;
  static const int walkInsteadOfCar = 13;
  static const int trainInsteadOfPlane = 14;

  static const int plantTree = 21;
  static const int plantOther = 22;

  static const int buyLocal = 31;
  static const int buySecondHand = 32;
  static const int sellUnused = 33;

  static const int reduceWater = 41;
  static const int reduceEnergy = 42;
  static const int reduceFoodWaste = 43;

  static const int other = 0;
}

class Activity {
  final ObjectId id;
  final int activityType;
  final String title;
  final String? caption;
  final List<String>? images;

  Activity({
    required this.id,
    required this.activityType,
    required this.title,
    this.caption,
    this.images,
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      id: json[_JsonKeys.id],
      activityType: json[_JsonKeys.activityType],
      title: json[_JsonKeys.title],
      caption: json[_JsonKeys.caption],
      images: json[_JsonKeys.images] != null
          ? List<String>.from(json[_JsonKeys.images])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      _JsonKeys.id: id,
      _JsonKeys.activityType: activityType,
      _JsonKeys.title: title,
      _JsonKeys.caption: caption,
      _JsonKeys.images: images,
    };
  }
}
