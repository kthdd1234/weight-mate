import 'package:flutter_app_weight_management/model/plan_box/plan_box.dart';
import 'package:flutter_app_weight_management/model/record_box/record_box.dart';
import 'package:flutter_app_weight_management/model/user_box/user_box.dart';
import 'package:hive_flutter/hive_flutter.dart';

class MateHive {
  Future<void> initializeHive() async {
    await Hive.initFlutter();

    Hive.registerAdapter(UserBoxAdapter());
    Hive.registerAdapter(RecordBoxAdapter());
    Hive.registerAdapter(PlanBoxAdapter());

    await Hive.openBox<UserBox>(MateHiveBox.userBox);
    await Hive.openBox<RecordBox>(MateHiveBox.recordBox);
    await Hive.openBox<PlanBox>(MateHiveBox.planBox);
  }
}

class MateHiveBox {
  static const String userBox = 'userBox';
  static const String recordBox = 'recordBox';
  static const String planBox = 'planBox';
}
