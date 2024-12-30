import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_app_weight_management/model/user_box/user_box.dart';
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

  void loadAd({required UserBox user}) async {
    bool isPremium = await isPurchasePremium();

    int nowKey = getDateTimeToInt(DateTime.now());
    int? adDateTimeKey = user.adDateTimeKey;

    bool isNotPremium = isPremium == false;
    bool isDateTimeKey = (adDateTimeKey == null) || (nowKey != adDateTimeKey);

    log('loadAd: $nowKey, $adDateTimeKey');

    if (isNotPremium && isDateTimeKey) {
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
                loadAd(user: user);
              },
            );

            _interstitialAd = ad;
          },
          onAdFailedToLoad: (LoadAdError error) {
            debugPrint('InterstitialAd failed to load: $error');
          },
        ),
      );
    }
  }

  void showAd({required bool isPremium, required UserBox user}) async {
    int nowKey = getDateTimeToInt(DateTime.now());
    int? adDateTimeKey = user.adDateTimeKey;

    bool isLoadAd = _interstitialAd != null;
    bool isNotPremium = isPremium == false;
    bool isDateTimeKey = (adDateTimeKey == null) || (nowKey != adDateTimeKey);

    log('showAd: $nowKey, $adDateTimeKey');

    if (isLoadAd && isNotPremium && isDateTimeKey) {
      await _interstitialAd!.show();

      user.adDateTimeKey = nowKey;
      await user.save();
    }
  }
}
