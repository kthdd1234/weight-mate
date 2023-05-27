import 'package:hive/hive.dart';

part 'record_info_list.g.dart';

@HiveType(typeId: 4)
class RecordInfoListBox {
  RecordInfoListBox({required this.list});

  @HiveField(0)
  List<Map<String, dynamic>> list;
}
