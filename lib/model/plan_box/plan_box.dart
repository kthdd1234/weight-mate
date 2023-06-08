import 'package:hive/hive.dart';

part 'plan_box.g.dart';

@HiveType(typeId: 3)
class PlanBox extends HiveObject {
  PlanBox({
    required this.id,
    required this.type,
    required this.title,
    required this.name,
    required this.startDateTime,
    this.endDateTime,
    required this.isAlarm,
    this.alarmTime,
  });

  @HiveField(0)
  String id;

  @HiveField(1)
  String type;

  @HiveField(2)
  String title;

  @HiveField(4)
  String name;

  @HiveField(5)
  DateTime startDateTime;

  @HiveField(6)
  DateTime? endDateTime;

  @HiveField(7)
  bool isAlarm;

  @HiveField(8)
  DateTime? alarmTime;
}
