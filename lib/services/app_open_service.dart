import 'package:flutter/foundation.dart';
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

// class AppLifecycleReactor {
//   AppLifecycleReactor({required this.appOpenAdManager});
//   final AppOpenAdManager appOpenAdManager;

//   void listenToAppStateChanges() {
//     AppStateEventNotifier.startListening();
//     AppStateEventNotifier.appStateStream
//         .forEach((state) => _onAppStateChanged(state));
//   }

//   void _onAppStateChanged(AppState appState) {
//     if (appState == AppState.foreground) {
//       appOpenAdManager.showAdIfAvailable();
//     }
//   }
// }
