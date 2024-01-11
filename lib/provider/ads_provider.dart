import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/services/ads_service.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdsProvider with ChangeNotifier {
  AdsProvider({
    required this.adsState,
    this.nativeAd,
  });

  AdsService adsState;
  NativeAd? nativeAd;

  String get nativeAdUnitId {
    return adsState.nativeAdUnitId;
  }

  NativeAd? get ad {
    return nativeAd;
  }

  void setNativeAd() async {
    nativeAd = loadNativeAd(adsState.nativeAdUnitId);
    notifyListeners();
  }
}
