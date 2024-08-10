import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/utils/variable.dart';

class GraphCategoryProvider extends ChangeNotifier {
  String graphCategory = cGraphWeight;

  setGraphCategory(String category) {
    graphCategory = category;
    notifyListeners();
  }
}
