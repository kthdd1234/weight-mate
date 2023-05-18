import 'package:flutter_app_weight_management/utils/class.dart';
import 'package:hive/hive.dart';

@HiveType(typeId: 2)
class UserInfoList {
  UserInfoList({required this.list});

  @HiveField(0)
  List<UserInfoClass> list;
}
