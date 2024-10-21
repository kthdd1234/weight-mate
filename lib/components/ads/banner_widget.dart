import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/common/CommonText.dart';
import 'package:flutter_app_weight_management/provider/ads_provider.dart';
import 'package:flutter_app_weight_management/services/ads_service.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:flutter_app_weight_management/utils/variable.dart';
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
  void didChangeDependencies() {
    AdsService adsState = Provider.of<AdsProvider>(context).adsState;

    checkHideAd() async {
      bool isHide = await isHideAd();

      if (mounted) {
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
    }

    checkHideAd();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    if (bannerAdIsLoaded == false) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: SizedBox(
          height: 50,
          child: CommonText(
              isNotTr: true,
              text: 'Ads',
              size: 12,
              isCenter: true,
              color: grey.original),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: SizedBox(height: 50, child: AdWidget(ad: bannerAd!)),
    );
  }
}
