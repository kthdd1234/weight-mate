import 'dart:developer';
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

  BannerAdListener get bannerAdListener => _bannerAdListener;
  NativeAdListener get nativeAdListener => _nativeAdListener;

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

  final BannerAdListener _bannerAdListener = BannerAdListener(
    onAdLoaded: (ad) => log('Ad loaded: ${ad.adUnitId}'),
    onAdClicked: (ad) => log('ad clicked: ${ad.adUnitId}'),
    onAdFailedToLoad: (ad, error) =>
        log('Ad failed to load: ${ad.adUnitId}, $error'),
    onAdOpened: (ad) => log('Ad opened: ${ad.adUnitId}'),
    onAdClosed: (ad) => log('Ad opened: ${ad.adUnitId}'),
    onAdImpression: (ad) => log('ad impresstion: ${ad.adUnitId}'),
    onAdWillDismissScreen: (ad) => log('log willDismissScreen: ${ad.adUnitId}'),
  );

  final NativeAdListener _nativeAdListener = NativeAdListener(
    onAdLoaded: (ad) => log('Ad loaded: ${ad.adUnitId}'),
    onAdClicked: (ad) => log('ad clicked: ${ad.adUnitId}'),
    onAdFailedToLoad: (ad, error) =>
        log('Ad failed to load: ${ad.adUnitId}, $error'),
    onAdOpened: (ad) => log('Ad opened: ${ad.adUnitId}'),
    onAdClosed: (ad) => log('Ad opened: ${ad.adUnitId}'),
    onAdImpression: (ad) => log('ad impresstion: ${ad.adUnitId}'),
    onAdWillDismissScreen: (ad) => log('log willDismissScreen: ${ad.adUnitId}'),
  );
}
