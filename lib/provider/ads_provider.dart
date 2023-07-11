import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/services/ads_service.dart';

class AdsProvider with ChangeNotifier {
  AdsService adsState;

  AdsProvider({required this.adsState});
}
