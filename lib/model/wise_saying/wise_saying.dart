import 'package:hive_flutter/hive_flutter.dart';

import 'wise_saying.g.dart';

class WiseSayingBox {
  WiseSayingBox({required this.wiseSayingList});

  @HiveField(0)
  List<Map<String, String>> wiseSayingList;
}
