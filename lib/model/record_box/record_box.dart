import 'package:hive/hive.dart';

part 'record_box.g.dart';

@HiveType(typeId: 2)
class RecordBox {
  RecordBox({
    required this.recordDateTime,
    this.weight,
    this.actList,
    this.memo,
  });

  @HiveField(0)
  DateTime recordDateTime;

  @HiveField(1)
  double? weight;

  @HiveField(2)
  List<String>? actList;

  @HiveField(3)
  String? memo;
}
