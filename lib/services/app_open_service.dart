import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/main.dart';
import 'package:flutter_app_weight_management/pages/common/enter_screen_lock_page.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'dart:io' show Platform;

const Duration maxCacheDuration = Duration(hours: 4);

DateTime? _appOpenLoadTime;

class AppOpenAdManager {
  AppOpenAd? _appOpenAd;
  bool _isShowingAd = false;

  String get appOpeningUnitId =>
      Platform.isAndroid ? androidAppOpeningAdUnitId : iosAppOpeningAdUnitId;
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

  void loadAd() {
    AppOpenAd.load(
      adUnitId: appOpeningUnitId,
      orientation: AppOpenAd.orientationPortrait,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          _appOpenLoadTime = DateTime.now();
          _appOpenAd = ad;

          print('AppOpenAd !!');
        },
        onAdFailedToLoad: (error) {
          print('AppOpenAd failed to load: $error');
        },
      ),
    );
  }

  bool get isAdAvailable {
    return _appOpenAd != null;
  }

  void showAdIfAvailable() {
    if (!isAdAvailable) {
      loadAd();
      return;
    }

    if (_isShowingAd) {
      return;
    }

    if (DateTime.now().subtract(maxCacheDuration).isAfter(_appOpenLoadTime!)) {
      _appOpenAd!.dispose();
      _appOpenAd = null;
      loadAd();
      return;
    }

    _appOpenAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) {
        _isShowingAd = true;
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        _isShowingAd = false;
        ad.dispose();
        _appOpenAd = null;
      },
      onAdDismissedFullScreenContent: (ad) {
        _isShowingAd = false;
        ad.dispose();
        _appOpenAd = null;
        loadAd();
      },
    );

    _appOpenAd!.show();
  }
}

class AppLifecycleReactor {
  AppLifecycleReactor(
      {required this.context}); // , required this.appOpenAdManager

  BuildContext context;

  void listenToAppStateChanges() {
    AppStateEventNotifier.startListening();
    AppStateEventNotifier.appStateStream.forEach((state) {
      // _onAppStateChangedAd(state);
      _onAppStateChangedPassword(state);
    });
  }

  // void _onAppStateChangedAd(AppState appState) async {
  //   bool isPurchase = await isPurchasePremium();

  //   if (appState == AppState.foreground && isPurchase == false) {
  //     log('들오 오는거 체크용');
  //     appOpenAdManager.showAdIfAvailable();
  //   }
  // }

  void _onAppStateChangedPassword(AppState appState) async {
    String? passwords = userRepository.user.screenLockPasswords;

    try {
      if (passwords != null) {
        if (appState == AppState.foreground) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => EnterScreenLockPage(),
              fullscreenDialog: true,
            ),
          );
        }
      }
    } catch (e) {
      log('e => $e');
    }
  }
}
