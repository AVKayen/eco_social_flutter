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

Map<int, String> activityTypeName = {
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

class Activity {
  final ObjectId id;
  final String activityName;
  final String title;
  final String? caption;
  final List<String>? images;

  Activity({
    required this.id,
    required this.activityName,
    required this.title,
    this.caption,
    this.images,
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      id: ObjectId.fromHexString(json[_JsonKeys.id]),
      activityName: activityTypeName[json[_JsonKeys.activityType]]!,
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
      _JsonKeys.activityType: activityTypeName.entries
          .firstWhere((entry) => entry.value == activityName)
          .key,
      _JsonKeys.title: title,
      _JsonKeys.caption: caption,
      _JsonKeys.images: images,
    };
  }
}
