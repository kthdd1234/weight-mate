import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AdsService {
  Future<InitializationStatus> initialization;

  AdsService({required this.initialization});

  String get bannerAdUnitId =>
      Platform.isAndroid ? androidBannerAdUnitId : iosBannerAdUnitId;
  String get nativeAdUnitId =>
      Platform.isAndroid ? androidNativeAdUnitId : iosNativeAdUnitId;
  String get rewardedInterstitialAdUnitId => Platform.isAndroid
      ? androidRewardedInterstitialAdUnitId
      : iosRewardedInterstitialAdUnitId;
  String get appOpeningUnitId =>
      Platform.isAndroid ? androidAppOpeningAdUnitId : iosAppOpeningAdUnitId;

  String get androidBannerAdUnitId {
    String? testId = dotenv.env['ANDROID_BANNER_TEST_ID'] ?? '';
    String? realId = dotenv.env['ANDROID_BANNER_REAL_ID'] ?? '';

    // return testId;
    return kDebugMode ? testId : realId;
  }

  String get iosBannerAdUnitId {
    String? testId = dotenv.env['IOS_BANNER_TEST_ID'] ?? '';
    String? realId = dotenv.env['IOS_BANNER_REAL_ID'] ?? '';

    // return testId;
    return kDebugMode ? testId : realId;
  }

  String get androidNativeAdUnitId {
    String? testId = dotenv.env['ANDROID_NATIVE_TEST_ID'] ?? '';
    String? realId = dotenv.env['ANDROID_NATIVE_REAL_ID'] ?? '';

    // return testId;
    return kDebugMode ? testId : realId;
  }

  String get iosNativeAdUnitId {
    String? testId = dotenv.env['IOS_NATIVE_TEST_ID'] ?? '';
    String? realId = dotenv.env['IOS_NATIVE_REAL_ID'] ?? '';

    // return testId;
    return kDebugMode ? testId : realId;
  }

  String get androidRewardedInterstitialAdUnitId {
    String? testId = dotenv.env['ANDROID_REWARDED_INTERSTITIAL_TEST_ID'] ?? '';
    String? realId = dotenv.env['ANDROID_REWARDED_INTERSTITIAL_REAL_ID'] ?? '';

    // return testId;
    return kDebugMode ? testId : realId;
  }

  String get iosRewardedInterstitialAdUnitId {
    String? testId = dotenv.env['IOS_REWARDED_INTERSTITIAL_TEST_ID'] ?? '';
    String? realId = dotenv.env['IOS_REWARDED_INTERSTITIAL_REAL_ID'] ?? '';

    // return testId;
    return kDebugMode ? testId : realId;
  }

  String get androidAppOpeningAdUnitId {
    String? testId = dotenv.env['ANDROID_APP_OPENING_TEST_ID'] ?? '';
    String? realId = dotenv.env['ANDROID_APP_OPENING_REAL_ID'] ?? '';

    return kDebugMode ? testId : realId;
  }

  String get iosAppOpeningAdUnitId {
    String? testId = dotenv.env['IOS_APP_OPENING_TEST_ID'] ?? '';
    String? realId = dotenv.env['IOS_APP_OPENING_REAL_ID'] ?? '';

    return kDebugMode ? testId : realId;
  }
}
