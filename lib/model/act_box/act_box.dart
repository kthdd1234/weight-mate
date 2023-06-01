import 'package:hive/hive.dart';

part 'act_box.g.dart';

@HiveType(typeId: 3)
class ActBox {
  ActBox({
    required this.id,
    required this.mainActType,
    required this.mainActTitle,
    required this.subActType,
    required this.subActTitle,
    required this.startActDateTime,
    this.endActDateTime,
    required this.isAlarm,
    this.alarmTime,
  });

  @HiveField(0)
  String id;

  @HiveField(1)
  String mainActType;

  @HiveField(2)
  String mainActTitle;

  @HiveField(3)
  String subActType;

  @HiveField(4)
  String subActTitle;

  @HiveField(5)
  DateTime startActDateTime;

  @HiveField(6)
  DateTime? endActDateTime;

  @HiveField(7)
  bool isAlarm;

  @HiveField(8)
  DateTime? alarmTime;
}
