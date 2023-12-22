import 'dart:typed_data';
import 'package:hive/hive.dart';

part 'record_box.g.dart';

@HiveType(typeId: 2)
class RecordBox extends HiveObject {
  RecordBox(
      {required this.createDateTime,
      this.weightDateTime,
      this.actionDateTime,
      this.diaryDateTime,
      this.weight,
      this.actions,
      this.leftFile,
      this.rightFile,
      this.whiteText,
      this.emotion});

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
  Uint8List? leftFile;

  @HiveField(7)
  Uint8List? rightFile;

  @HiveField(8)
  String? whiteText;

  @HiveField(9)
  String? emotion;

  @override
  String toString() {
    return '{ createDateTime: $createDateTime, weightDateTime: $weightDateTime, actionDateTime: $actionDateTime, diaryDateTime: $diaryDateTime, weight: $weight, actions: $actions, leftFile: $leftFile, rightFile: $rightFile, whiteText: $whiteText, emotion: $emotion }';
  }
}
