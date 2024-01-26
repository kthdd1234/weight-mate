import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/services/ads_service.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdsProvider with ChangeNotifier {
  AdsProvider({
    required this.adsState,
  });

  AdsService adsState;

  String get nativeAdUnitId {
    return adsState.nativeAdUnitId;
  }

  // void setNativeAd(Function(NativeAd) callbackNativeAd) async {
  //   NativeAd nativeAd = loadNativeAd(adsState.nativeAdUnitId);

  //   callbackNativeAd(nativeAd);
  //   notifyListeners();
  // }
}
