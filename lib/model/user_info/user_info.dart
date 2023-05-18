import 'package:flutter_app_weight_management/utils/class.dart';
import 'package:hive/hive.dart';

part 'user_info.g.dart';

@HiveType(typeId: 1)
class UserInfo {
  UserInfo({
    required this.recordDateTime,
    required this.tall,
    required this.weight,
    required this.goalWeight,
    required this.startDietDateTime,
    required this.endDietDateTime,
    required this.dietPlanList,
    required this.bodyFat,
    required this.memo,
  });

  @HiveField(0)
  DateTime recordDateTime;

  @HiveField(1)
  double tall;

  @HiveField(2)
  double weight;

  @HiveField(3)
  double goalWeight;

  @HiveField(4)
  double bodyFat;

  @HiveField(5)
  DateTime startDietDateTime;

  @HiveField(6)
  DateTime endDietDateTime;

  @HiveField(7)
  List<DietPlanClass> dietPlanList;

  @HiveField(8)
  String memo;
}
