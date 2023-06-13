import 'package:hive/hive.dart';

part 'record_box.g.dart';

@HiveType(typeId: 2)
class RecordBox extends HiveObject {
  RecordBox({
    required this.recordDateTime,
    this.weight,
    required this.actions,
    this.leftEyeBodyFilePath,
    this.rightEyeBodyFilePath,
    this.whiteText,
  });

  @HiveField(0)
  DateTime recordDateTime;

  @HiveField(1)
  double? weight;

  @HiveField(2)
  List<String> actions;

  @HiveField(3)
  String? leftEyeBodyFilePath;

  @HiveField(4)
  String? rightEyeBodyFilePath;

  @HiveField(5)
  String? whiteText;
}
