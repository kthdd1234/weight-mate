import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/common/CommonText.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/provider/ads_provider.dart';
import 'package:flutter_app_weight_management/services/ads_service.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

class BannerWidget extends StatefulWidget {
  BannerWidget({super.key});

  @override
  State<BannerWidget> createState() => _BannerWidgetState();
}

class _BannerWidgetState extends State<BannerWidget> {
  BannerAd? bannerAd;
  bool bannerAdIsLoaded = false;
  bool isNotAdShow = false;

  @override
  void dispose() {
    bannerAd = null;
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    AdsService adsState = Provider.of<AdsProvider>(context).adsState;

    checkHideAd() async {
      bool isHide = await isHideAd();

      if (isHide == true) {
        setState(() => isNotAdShow = isHide);
      } else if (isHide == false) {
        adsState.initialization.then(
          (value) => {
            setState(() {
              bannerAd = BannerAd(
                adUnitId: adsState.bannerAdUnitId,
                size: AdSize.banner,
                request: const AdRequest(),
                listener: BannerAdListener(
                  onAdLoaded: (ad) {
                    debugPrint('$ad loaded.');
                    setState(() => bannerAdIsLoaded = true);
                  },
                  onAdFailedToLoad: (ad, error) {
                    debugPrint('$NativeAd failed to load: $error');
                    ad.dispose();
                  },
                ),
              )..load();
            })
          },
        );
      }
    }

    checkHideAd();

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    if (isNotAdShow) {
      return SpaceHeight(height: 10);
    }

    if (bannerAdIsLoaded == false) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(0, 5, 0, 10),
        child: SizedBox(
          height: 50,
          child: CommonText(
            isNotTr: true,
            text: 'Ads',
            size: 12,
            isCenter: true,
            color: Colors.grey,
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 5, 0, 10),
      child: SizedBox(height: 50, child: AdWidget(ad: bannerAd!)),
    );
  }
}

Future<bool> isHideAd() async {
  TrackingStatus status =
      await AppTrackingTransparency.trackingAuthorizationStatus;

  if (status == TrackingStatus.authorized) {
    String advertisingId =
        await AppTrackingTransparency.getAdvertisingIdentifier();

    if (advertisingId == '5E188ADD-3D54-4140-97F7-AA5FAA0AD3B2') {
      return true;
    }
  }

  return true;
}
