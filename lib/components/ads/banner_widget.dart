import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/common/CommonText.dart';
import 'package:flutter_app_weight_management/components/area/empty_area.dart';
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
  bool isNoAdShow = false;

  @override
  void dispose() {
    bannerAd = null;
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    AdsService adsState = Provider.of<AdsProvider>(context).adsState;
    adsState.initialization.then(
      (value) => {
        setState(() {
          bannerAd = BannerAd(
            adUnitId: adsState.bannerAdUnitId,
            size: AdSize.banner,
            request: const AdRequest(),
            listener: BannerAdListener(
              onAdLoaded: (ad) {
                debugPrint('$NativeAd loaded.');
                setState(() => bannerAdIsLoaded = true);
              },
              onAdFailedToLoad: (ad, error) {
                debugPrint('$NativeAd failed to load: $error');
                setState(() => isNoAdShow = true);
                ad.dispose();
              },
            ),
          )..load();
        })
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (bannerAdIsLoaded == false) {
      return Padding(
        padding: EdgeInsets.only(top: 5),
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
      padding: const EdgeInsets.only(top: 5),
      child: SizedBox(height: 50, child: AdWidget(ad: bannerAd!)),
    );
  }
}
