import 'package:hive/hive.dart';

part 'record_box.g.dart';

@HiveType(typeId: 2)
class RecordBox extends HiveObject {
  RecordBox({
    required this.createDateTime,
    this.weightDateTime,
    this.actionDateTime,
    this.diaryDateTime,
    this.weight,
    this.actions,
    this.leftEyeBodyFilePath,
    this.rightEyeBodyFilePath,
    this.whiteText,
  });

  @HiveField(0)
  DateTime createDateTime;

  @HiveField(1)
  DateTime? weightDateTime;

  @HiveField(2)
  DateTime? actionDateTime;

  @HiveField(3)
  DateTime? diaryDateTime;

  @HiveField(4)
  double? weight;

  @HiveField(5)
  List<Map<String, dynamic>>? actions;

  @HiveField(6)
  String? leftEyeBodyFilePath;

  @HiveField(7)
  String? rightEyeBodyFilePath;

  @HiveField(8)
  String? whiteText;
}
