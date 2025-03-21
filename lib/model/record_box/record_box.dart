import 'dart:typed_data';
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
    this.leftFile,
    this.rightFile,
    this.whiteText,
    this.emotion,
    this.bottomFile,
    this.topFile,
    this.dietRecordOrderList,
    this.exerciseRecordOrderList,
    this.recordHashTagList,
    this.leftFileTime,
    this.rightFileTime,
    this.bottomFileTime,
    this.topFileTime,
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
  Uint8List? leftFile;

  @HiveField(7)
  Uint8List? rightFile;

  @HiveField(8)
  String? whiteText;

  @HiveField(9)
  String? emotion;

  @HiveField(10)
  Uint8List? bottomFile;

  @HiveField(11)
  Uint8List? topFile;

  @HiveField(12)
  List<String>? dietRecordOrderList;

  @HiveField(13)
  List<String>? exerciseRecordOrderList;

  @HiveField(14)
  List<Map<String, String>>? recordHashTagList;

  @HiveField(15)
  DateTime? leftFileTime;

  @HiveField(16)
  DateTime? rightFileTime;

  @HiveField(17)
  DateTime? bottomFileTime;

  @HiveField(18)
  DateTime? topFileTime;
}
