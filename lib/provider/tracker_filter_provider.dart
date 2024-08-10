import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';

class TrackerFilterProvider with ChangeNotifier {
  TrackerFilter trackerFilter = TrackerFilter.recent;

  setTrackerFilter(TrackerFilter type) {
    trackerFilter = type;
    notifyListeners();
  }
}
