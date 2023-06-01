import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/utils/class.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';
import 'package:uuid/uuid.dart';

class DietInfoProvider with ChangeNotifier {
  String userId = '';
  String _tallText = '';
  String _weightText = '';
  String _goalWeightText = '';
  ActInfoClass _actInfo = ActInfoClass(
    id: const Uuid().v4(),
    mainActType: MainActTypes.none,
    mainActTitle: '',
    subActType: '',
    subActTitle: '',
    startActDateTime: DateTime.now(),
    endActDateTime: null,
    isAlarm: true,
    alarmTime: DateTime.now(),
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
      actList: [],
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

  ActInfoClass getActInfo() {
    return _actInfo;
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

  changeActInfo(ActInfoClass info) {
    _actInfo = info;
    notifyListeners();
  }
}
