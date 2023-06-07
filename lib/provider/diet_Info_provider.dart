import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/utils/class.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';

class DietInfoProvider with ChangeNotifier {
  String userId = '';
  String _tallText = '';
  String _weightText = '';
  String _goalWeightText = '';
  PlanInfoClass _planInfo = PlanInfoClass(
    type: PlanTypeEnum.none,
    title: '',
    id: '',
    name: '',
    startDateTime: DateTime.now(),
    endDateTime: null,
    isAlarm: false,
    alarmTime: null,
  );
  DateTime _recordStartDateTime = DateTime.now();

  double convertToDouble(String str) {
    return double.parse(str);
  }

  UserInfoClass getUserInfo() {
    return UserInfoClass(
      userId: userId,
      tall: convertToDouble(_tallText),
      goalWeight: convertToDouble(_goalWeightText),
      recordStartDateTime: _recordStartDateTime,
    );
  }

  RecordInfoClass getRecordInfo() {
    return RecordInfoClass(
      recordDateTime: _recordStartDateTime,
      weight: convertToDouble(_weightText),
      actions: {},
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

  initDietInfoProvider() {
    _planInfo = PlanInfoClass(
      type: PlanTypeEnum.none,
      title: '',
      id: '',
      name: '',
      startDateTime: DateTime.now(),
      endDateTime: null,
      isAlarm: true,
      alarmTime: null,
    );

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
}
