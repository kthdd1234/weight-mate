import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/utils/class.dart';

class DietInfoProvider with ChangeNotifier {
  String _tallText = '';
  String _weightText = '';
  String _goalWeightText = '';
  List<DietPlanClass> _dietPlanList = [];
  DateTime _startDietDateTime = DateTime.now();
  DateTime? _endDietDateTime;
  DateTime _recordStartDateTime = DateTime.now();

  UserInfoClass getUserInfo() {
    double convertDouble(String str) {
      return double.parse(str);
    }

    return UserInfoClass(
      tall: convertDouble(_tallText),
      goalWeight: convertDouble(_goalWeightText),
      startDietDateTime: _startDietDateTime,
      endDietDateTime: _endDietDateTime,
      recordStartDateTime: _recordStartDateTime,
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

  changeTallText(String text) {
    _tallText = text;
    notifyListeners();
  }

  changeWeightText(String text) {
    _weightText = text;
    notifyListeners();
  }

  changeStartDietDateTime(DateTime dateTime) {
    _startDietDateTime = dateTime;
    notifyListeners();
  }

  changeEndDietDateTime(DateTime? dateTime) {
    _endDietDateTime = dateTime;
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

  changeRecordStartDateTime(DateTime dateTime) {
    _recordStartDateTime = dateTime;
    notifyListeners();
  }
}
