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
    this.calendarFormat,
    this.calendarMaker,
    this.dietOrderList,
    this.exerciseOrderList,
    this.lifeOrderList,
    this.language,
    this.tallUnit,
    this.weightUnit,
    this.isShowPreviousGraph,
    this.historyForamt,
    this.historyDisplayList,
    this.historyCalendarFormat,
    this.isDietExerciseRecordDateTime,
    this.fontFamily,
    this.googleDriveInfo,
    this.isDietExerciseRecordDateTime2,
    this.customerInfoJson,
    this.graphType,
    this.cutomGraphStartDateTime,
    this.cutomGraphEndDateTime,
    this.hashTagList,
    this.searchDisplayList,
    this.appStartIndex,
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

  @HiveField(11)
  String? calendarMaker;

  @HiveField(12)
  String? calendarFormat;

  @HiveField(13)
  List<String>? dietOrderList;

  @HiveField(14)
  List<String>? exerciseOrderList;

  @HiveField(15)
  List<String>? lifeOrderList;

  @HiveField(16)
  String? language;

  @HiveField(17)
  String? weightUnit;

  @HiveField(18)
  String? tallUnit;

  @HiveField(19)
  bool? isShowPreviousGraph;

  @HiveField(20)
  String? historyForamt;

  @HiveField(21)
  List<String>? historyDisplayList;

  @HiveField(22)
  String? historyCalendarFormat;

  @HiveField(23)
  bool? isDietExerciseRecordDateTime;

  @HiveField(24)
  String? fontFamily;

  @HiveField(25)
  Map<String, dynamic>? googleDriveInfo;

  @HiveField(26)
  bool? isDietExerciseRecordDateTime2;

  @HiveField(27)
  Map<String, dynamic>? customerInfoJson;

  @HiveField(28)
  String? graphType;

  @HiveField(29)
  DateTime? cutomGraphStartDateTime;

  @HiveField(30)
  DateTime? cutomGraphEndDateTime;

  @HiveField(31)
  List<Map<String, String>>? hashTagList;

  @HiveField(32)
  List<String>? searchDisplayList;

  @HiveField(33)
  int? appStartIndex;

  @override
  String toString() {
    return '';
  }
}
