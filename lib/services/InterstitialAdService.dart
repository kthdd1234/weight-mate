import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class InterstitialAdService {
  InterstitialAd? _interstitialAd;

  String get appInterstitialUnitId => Platform.isAndroid
      ? androidInterstitialAdUnitId
      : iosInterstitialAdUnitId;
  String get androidInterstitialAdUnitId {
    String? testId = dotenv.env['ANDROID_INTERSTITIAL_TEST_ID'] ?? '';
    String? realId = dotenv.env['ANDROID_INTERSTITIAL_REAL_ID'] ?? '';

    return kDebugMode ? testId : realId;
  }

  String get iosInterstitialAdUnitId {
    String? testId = dotenv.env['IOS_INTERSTITIAL_TEST_ID'] ?? '';
    String? realId = dotenv.env['IOS_INTERSTITIAL_REAL_ID'] ?? '';

    return kDebugMode ? testId : realId;
  }

  void loadAd() async {
    bool isPremium = await isPurchasePremium();

    if (isPremium == false) {
      InterstitialAd.load(
        adUnitId: appInterstitialUnitId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (ad) {
            ad.fullScreenContentCallback = FullScreenContentCallback(
              onAdFailedToShowFullScreenContent: (ad, err) {
                ad.dispose();
                _interstitialAd = null;
              },
              onAdDismissedFullScreenContent: (ad) {
                ad.dispose();
                _interstitialAd = null;
                loadAd();
              },
            );

            _interstitialAd = ad;
            showLog();
          },
          onAdFailedToLoad: (LoadAdError error) {
            debugPrint('InterstitialAd failed to load: $error');
          },
        ),
      );
    }
  }

  void showAd() async {
    if (_interstitialAd != null) {
      await _interstitialAd!.show();
    }
  }

  void showLog() {
    log('전면 광고 로드 체크 => $_interstitialAd');
  }
}
