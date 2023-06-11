import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/utils/class.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';

final initAlarmDateTime = DateTime(
  DateTime.now().year,
  DateTime.now().month,
  DateTime.now().day,
  10,
  30,
);

final initPlanInfo = PlanInfoClass(
  type: PlanTypeEnum.none,
  title: '',
  id: '',
  name: '',
  startDateTime: DateTime.now(),
  endDateTime: null,
  isAlarm: true,
  alarmTime: initAlarmDateTime,
  alarmId: null,
);

class DietInfoProvider with ChangeNotifier {
  String userId = '';
  String _tallText = '';
  String _weightText = '';
  String _goalWeightText = '';
  bool _isAlarm = true;
  DateTime? _alarmTime = initAlarmDateTime;
  PlanInfoClass _planInfo = initPlanInfo;
  DateTime _recordStartDateTime = DateTime.now();

  UserInfoClass getUserInfo() {
    return UserInfoClass(
      userId: userId,
      tall: double.parse(_tallText),
      goalWeight: double.parse(_goalWeightText),
      recordStartDateTime: _recordStartDateTime,
      isAlarm: _isAlarm,
      alarmTime: _alarmTime,
      alarmId: -1,
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

  DateTime? getAlarmTime() {
    return _alarmTime;
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
}
