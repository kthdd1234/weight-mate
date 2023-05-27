import 'package:hive/hive.dart';

part 'record_info.g.dart';

@HiveType(typeId: 3)
class RecordInfoBox {
  RecordInfoBox({
    this.recordDateTime,
    this.weight,
    this.dietPlanList,
    this.memo,
  });

  @HiveField(0)
  DateTime? recordDateTime;

  @HiveField(1)
  double? weight;

  @HiveField(2)
  List<Map<String, dynamic>>? dietPlanList;

  @HiveField(3)
  String? memo;
}
