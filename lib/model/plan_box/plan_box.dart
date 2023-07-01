import 'package:hive/hive.dart';

part 'plan_box.g.dart';

@HiveType(typeId: 3)
class PlanBox extends HiveObject {
  PlanBox({
    required this.id,
    required this.type,
    required this.title,
    required this.name,
    required this.priority,
    required this.isAlarm,
    this.alarmTime,
    this.alarmId,
    required this.createDateTime,
  });

  @HiveField(0)
  String id;

  @HiveField(1)
  String type;

  @HiveField(2)
  String title;

  @HiveField(3)
  String priority;

  @HiveField(4)
  String name;

  @HiveField(5)
  bool isAlarm;

  @HiveField(6)
  DateTime? alarmTime;

  @HiveField(7)
  int? alarmId;

  @HiveField(8)
  DateTime createDateTime;
}
