import 'package:hive/hive.dart';

part 'user_box.g.dart';

@HiveType(typeId: 1)
class UserBox extends HiveObject {
  UserBox({
    required this.userId,
    required this.tall,
    required this.goalWeight,
    required this.recordStartDateTime,
    required this.isAlarm,
    this.alarmTime,
    this.alarmId,
  });

  @HiveField(0)
  String userId;

  @HiveField(1)
  double tall;

  @HiveField(2)
  double goalWeight;

  @HiveField(3)
  DateTime recordStartDateTime;

  @HiveField(4)
  bool isAlarm;

  @HiveField(5)
  DateTime? alarmTime;

  @HiveField(6)
  int? alarmId;
}
