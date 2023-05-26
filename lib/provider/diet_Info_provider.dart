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

  double convertToDouble(String str) {
    return double.parse(str);
  }

  UserInfoClass getUserInfo() {
    return UserInfoClass(
      tall: convertToDouble(_tallText),
      goalWeight: convertToDouble(_goalWeightText),
      startDietDateTime: _startDietDateTime,
      endDietDateTime: _endDietDateTime,
      recordStartDateTime: _recordStartDateTime,
    );
  }

  List<Map<String, dynamic>> getDietPlanListData() {
    final list = _dietPlanList.map((obj) => obj.getMapData()).toList();
    return list;
  }

  Map<String, dynamic> getRecordInfoData() {
    return {
      'recordDateTime': DateTime.now(),
      'weight': convertToDouble(_weightText),
      'bodyFat': null,
      'dietPlanList': getDietPlanListData(),
      'memo': null,
    };
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
