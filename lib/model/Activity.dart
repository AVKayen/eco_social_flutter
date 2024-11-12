import 'package:bson/bson.dart';
import 'package:image_input/image_input.dart';
import '/constants.dart';

class _JsonKeys {
  static const String id = '_id';
  static const String activityType = 'activity_type';
  static const String title = 'title';
  static const String caption = 'caption';
  static const String createdAt = 'created_at';
  static const String images = 'images';
  static const String userId = 'user_id';
  static const String streak = 'streak_snapshot';
  static const String points = 'points_gained';
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

class ActivityName {
  static const String trashPicking = 'Trash Picking';

  static const String pubTransportInsteadOfCar =
      'Public Transport Instead of Car';
  static const String bikeInsteadOfCar = 'Bike Instead of Car';
  static const String walkInsteadOfCar = 'Walk Instead of Car';
  static const String trainInsteadOfPlane = 'Train Instead of Plane';

  static const String plantTree = 'Plant a Tree';
  static const String plantOther = 'Plant Other';

  static const String buyLocal = 'Buy Local';
  static const String buySecondHand = 'Buy Second Hand';
  static const String sellUnused = 'Sell Unused';

  static const String reduceWater = 'Reduce Water';
  static const String reduceEnergy = 'Reduce Energy';
  static const String reduceFoodWaste = 'Reduce Food Waste';

  static const String other = 'Other';
}

Map<int, String> activityNameFromType = {
  ActivityType.trashPicking: ActivityName.trashPicking,
  ActivityType.pubTransportInsteadOfCar: ActivityName.pubTransportInsteadOfCar,
  ActivityType.bikeInsteadOfCar: ActivityName.bikeInsteadOfCar,
  ActivityType.walkInsteadOfCar: ActivityName.walkInsteadOfCar,
  ActivityType.trainInsteadOfPlane: ActivityName.trainInsteadOfPlane,
  ActivityType.plantTree: ActivityName.plantTree,
  ActivityType.plantOther: ActivityName.plantOther,
  ActivityType.buyLocal: ActivityName.buyLocal,
  ActivityType.buySecondHand: ActivityName.buySecondHand,
  ActivityType.sellUnused: ActivityName.sellUnused,
  ActivityType.reduceWater: ActivityName.reduceWater,
  ActivityType.reduceEnergy: ActivityName.reduceEnergy,
  ActivityType.reduceFoodWaste: ActivityName.reduceFoodWaste,
  ActivityType.other: ActivityName.other,
};

Map<String, int> activityTypeFromName = {
  ActivityName.trashPicking: ActivityType.trashPicking,
  ActivityName.pubTransportInsteadOfCar: ActivityType.pubTransportInsteadOfCar,
  ActivityName.bikeInsteadOfCar: ActivityType.bikeInsteadOfCar,
  ActivityName.walkInsteadOfCar: ActivityType.walkInsteadOfCar,
  ActivityName.trainInsteadOfPlane: ActivityType.trainInsteadOfPlane,
  ActivityName.plantTree: ActivityType.plantTree,
  ActivityName.plantOther: ActivityType.plantOther,
  ActivityName.buyLocal: ActivityType.buyLocal,
  ActivityName.buySecondHand: ActivityType.buySecondHand,
  ActivityName.sellUnused: ActivityType.sellUnused,
  ActivityName.reduceWater: ActivityType.reduceWater,
  ActivityName.reduceEnergy: ActivityType.reduceEnergy,
  ActivityName.reduceFoodWaste: ActivityType.reduceFoodWaste,
  ActivityName.other: ActivityType.other,
};

class ActivityForm {
  final int activityType;
  final String title;
  final String? caption;
  final List<XFile> images;

  ActivityForm({
    required this.activityType,
    required this.title,
    this.caption,
    required this.images,
  });

  Map<String, dynamic> toJson() {
    return {
      _JsonKeys.activityType: activityType,
      _JsonKeys.title: title,
      _JsonKeys.caption: caption,
      _JsonKeys.images: images,
    };
  }
}

class Activity {
  final ObjectId id;
  final String activityName;
  final String title;
  final ObjectId userId;
  final DateTime createdAt;
  final int streak;
  final int points;
  final String? caption;
  final List<String> images;

  Activity({
    required this.id,
    required this.activityName,
    required this.title,
    required this.userId,
    required this.createdAt,
    required this.streak,
    required this.points,
    this.caption,
    required this.images,
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      id: ObjectId.fromHexString(json[_JsonKeys.id]),
      activityName: activityNameFromType[json[_JsonKeys.activityType]]!,
      title: json[_JsonKeys.title],
      userId: ObjectId.fromHexString(json[_JsonKeys.userId]),
      createdAt: DateTime.parse(json[_JsonKeys.createdAt]),
      streak: json[_JsonKeys.streak],
      points: json[_JsonKeys.points],
      caption: json[_JsonKeys.caption],
      images: List<String>.from(json[_JsonKeys.images]).map((filename) {
        return '${Constants.imageUrl}$filename';
      }).toList(),
    );
  }
}
