import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/utils/class.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:uuid/uuid.dart';

final initPlanInfo = PlanInfoClass(
  type: PlanTypeEnum.diet,
  title: '식단',
  id: const Uuid().v1(),
  name: '간헐적 단식 16:8',
  priority: PlanPriorityEnum.medium,
  isAlarm: true,
  alarmTime: initDateTime(),
  alarmId: null,
  createDateTime: DateTime.now(),
  planItemList: [],
);

class DietInfoProvider with ChangeNotifier {
  String userId = '';
  String _tallText = '';
  String _weightText = '';
  String _goalWeightText = '';
  bool _isAlarm = false;
  DateTime? _alarmTime;
  int? _alarmId;
  PlanInfoClass _planInfo = initPlanInfo;
  DateTime _recordStartDateTime = DateTime.now();
  List<String> planItemList = [];

  UserInfoClass getUserInfo() {
    return UserInfoClass(
      userId: userId,
      tall: double.parse(_tallText),
      goalWeight: double.parse(_goalWeightText),
      recordStartDateTime: _recordStartDateTime,
      isAlarm: _isAlarm,
      alarmTime: _alarmTime,
      alarmId: _alarmId,
    );
  }

  RecordInfoClass getRecordInfo() {
    return RecordInfoClass(
      recordDateTime: _recordStartDateTime,
      weight: double.parse(_weightText),
      actions: [],
      memo: null,
    );
  }

  String getTallText() {
    return _tallText;
  }

  String getWeightText() {
    return _weightText;
  }

  String getGoalWeightText() {
    return _goalWeightText;
  }

  PlanInfoClass getPlanInfo() {
    return _planInfo;
  }

  bool getIsAlarm() {
    return _isAlarm;
  }

  int? getAlarmId() {
    return _alarmId;
  }

  DateTime? getAlarmTime() {
    return _alarmTime;
  }

  List<String> getPlanItemList() {
    return planItemList;
  }

  setInitPlanInfo() {
    _planInfo = initPlanInfo;
    notifyListeners();
  }

  changeTallText(String text) {
    _tallText = text;
    notifyListeners();
  }

  changeWeightText(String text) {
    _weightText = text;
    notifyListeners();
  }

  changeGoalWeightText(String text) {
    _goalWeightText = text;
    notifyListeners();
  }

  changeRecordStartDateTime(DateTime dateTime) {
    _recordStartDateTime = dateTime;
    notifyListeners();
  }

  changePlanInfo(PlanInfoClass info) {
    _planInfo = info;
    notifyListeners();
  }

  changeIsAlarm(bool value) {
    _isAlarm = value;
    notifyListeners();
  }

  changeAlarmTime(DateTime? time) {
    _alarmTime = time;
    notifyListeners();
  }

  changeAlarmId(int id) {
    _alarmId = id;
    notifyListeners();
  }

  changeIsPlanAlarm(bool value) {
    _planInfo.isAlarm = value;
    notifyListeners();
  }

  changePlanItemList(List<String> list) {
    planItemList = list;
    notifyListeners();
  }
}
