import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:hive/hive.dart';

part 'user_box.g.dart';

@HiveType(typeId: 1)
class UserBox extends HiveObject {
  UserBox({
    required this.userId,
    required this.tall,
    required this.goalWeight,
    required this.createDateTime,
    required this.isAlarm,
    this.planViewType,
    this.alarmTime,
    this.alarmId,
    this.screenLockPasswords,
    this.filterList,
    this.displayList,
  });

  @HiveField(0)
  String userId;

  @HiveField(1)
  double tall;

  @HiveField(2)
  double goalWeight;

  @HiveField(3)
  DateTime createDateTime;

  @HiveField(4)
  bool isAlarm;

  @HiveField(5)
  DateTime? alarmTime;

  @HiveField(6)
  int? alarmId;

  @HiveField(7)
  String? screenLockPasswords;

  @HiveField(8)
  String? planViewType;

  @HiveField(9)
  List<String>? filterList;

  @HiveField(10)
  List<String>? displayList;

  @override
  String toString() {
    return '{userId: $userId, tall: $tall, goalWeight: $goalWeight, createDateTime: $createDateTime, isAlarm: $isAlarm, alarmTime: $alarmTime, alarmId: $alarmId, screenLockPasswords: $screenLockPasswords, planViewType: $planViewType, filterList: $filterList, displayList: $displayList }';
  }
}
