import 'package:flutter_app_weight_management/utils/class.dart';
import 'package:hive/hive.dart';

part 'record_info_list.g.dart';

@HiveType(typeId: 2)
class RecordInfoListBox {
  RecordInfoListBox({required this.list});

  @HiveField(0)
  List<Map<String, dynamic>> list;
}
