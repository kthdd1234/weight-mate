import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/model/user_info/user_info.dart';
import 'package:flutter_app_weight_management/utils/class.dart';

class DietInfoProvider with ChangeNotifier {
  DateTime recordDateTime = DateTime.now();
  String _tallText = '';
  String _weightText = '';
  String _goalWeightText = '';
  List<DateTime?> _startAndEndDateTime = [];
  List<DietPlanClass> _dietPlanList = [];
  String _todayMemoText = '';
  String _bodyFatText = '';

  UserInfoClass getUserInfo() {
    double convertDouble(String str) {
      return double.parse(str);
    }

    return UserInfoClass(
      recordDateTime: recordDateTime,
      tall: convertDouble(_tallText),
      weight: convertDouble(_weightText),
      goalWeight: convertDouble(_goalWeightText),
      startDietDateTime: DateTime.now(),
      endDietDateTime: DateTime.now(),
      dietPlanList: _dietPlanList,
      bodyFat: 0.0,
      memo: '',
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

  List<DietPlanClass> getDietPlanList() {
    return _dietPlanList;
  }

  String getTodayMemoText() {
    return _todayMemoText;
  }

  String getBodyFatText() {
    return _bodyFatText;
  }

  changeTallText(String text) {
    _tallText = text;
    notifyListeners();
  }

  changeWeightText(String text) {
    _weightText = text;
    notifyListeners();
  }

  changeStartAndEndDateTime(List<DateTime?> dateTimeList) {
    _startAndEndDateTime = dateTimeList;
    notifyListeners();
  }

  changeGoalWeightText(String text) {
    _goalWeightText = text;
    notifyListeners();
  }

  changeDietPlanList(List<DietPlanClass> checkList) {
    _dietPlanList = checkList;
    notifyListeners();
  }

  changeTodayMemoText(String text) {
    _todayMemoText = text;
    notifyListeners();
  }

  changeBodyFatText(String text) {
    _bodyFatText = text;
    notifyListeners();
  }
}
