import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';

class SearchFilterProvider with ChangeNotifier {
  SearchFilter searchFilter = SearchFilter.recent;

  setSearchFilter(SearchFilter newType) {
    searchFilter = newType;
    notifyListeners();
  }
}
