import 'package:flutter_app_weight_management/utils/class.dart';
import 'package:hive/hive.dart';

part 'user_info.g.dart';

@HiveType(typeId: 1)
class UserInfoBox {
  UserInfoBox({
    required this.tall,
    required this.goalWeight,
    required this.startDietDateTime,
    required this.endDietDateTime,
    required this.recordStartDateTime,
    this.recordInfoList,
  });

  @HiveField(0)
  double tall;

  @HiveField(1)
  double goalWeight;

  @HiveField(2)
  DateTime startDietDateTime;

  @HiveField(3)
  DateTime? endDietDateTime;

  @HiveField(4)
  DateTime recordStartDateTime;

  @HiveField(5)
  List<Map<String, dynamic>>? recordInfoList;
}
