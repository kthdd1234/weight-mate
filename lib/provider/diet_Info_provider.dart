import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/utils/class.dart';

class DietInfoProvider with ChangeNotifier {
  String _tallText = '';
  String _weightText = '';
  String _goalWeightText = '';
  List<String> planItemList = [];
  String _tallUnit = '';
  String _weightUnit = '';

  UserInfoClass getUserInfo() {
    return UserInfoClass(
      weight: double.parse(_weightText),
      tall: double.parse(_tallText),
      goalWeight: double.parse(_goalWeightText),
      tallUnit: _tallUnit,
      weightUnit: _weightUnit,
    );
  }

  changeTallUnit(String unit) {
    _tallUnit = unit;
    notifyListeners();
  }

  changeWeightUnit(String unit) {
    _weightUnit = unit;
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

  changePlanItemList(List<String> list) {
    planItemList = list;
    notifyListeners();
  }
}
