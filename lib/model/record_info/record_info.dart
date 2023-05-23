import 'package:flutter_app_weight_management/utils/class.dart';
import 'package:hive/hive.dart';

part 'record_info.g.dart';

@HiveType(typeId: 3)
class RecordInfoBox {
  RecordInfoBox({
    required this.recordDateTime,
    required this.weight,
    required this.bodyFat,
    required this.dietPlanList,
    required this.memo,
  });

  @HiveField(0)
  DateTime recordDateTime;

  @HiveField(1)
  double weight;

  @HiveField(2)
  double bodyFat;

  @HiveField(3)
  List<DietPlanClass> dietPlanList;

  @HiveField(4)
  String memo;
}
