import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';

class HistoryFilterProvider with ChangeNotifier {
  HistoryFilter historyFilter = HistoryFilter.recent;

  setHistoryFilter(HistoryFilter type) {
    historyFilter = type;
    notifyListeners();
  }
}
