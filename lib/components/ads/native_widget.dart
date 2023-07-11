import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/provider/ads_provider.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

class NativeWidget extends StatefulWidget {
  NativeWidget({super.key});

  @override
  State<NativeWidget> createState() => _NativeWidgetState();
}

class _NativeWidgetState extends State<NativeWidget> {
  NativeAd? nativeAd;
  bool nativeAdIsLoaded = false;

  @override
  void dispose() {
    nativeAd = null;
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final adsState = Provider.of<AdsProvider>(context).adsState;

    adsState.initialization.then(
      (value) => {
        setState(() {
          nativeAd = NativeAd(
            adUnitId: adsState.nativeAdUnitId,
            listener: NativeAdListener(
              onAdLoaded: (ad) {
                debugPrint('$NativeAd loaded.');
                setState(() => nativeAdIsLoaded = true);
              },
              onAdFailedToLoad: (ad, error) {
                debugPrint('$NativeAd failed to load: $error');
                ad.dispose();
              },
            ),
            request: const AdRequest(),
            nativeTemplateStyle: NativeTemplateStyle(
              templateType: TemplateType.medium,
              mainBackgroundColor: typeBackgroundColor,
              cornerRadius: 5.0,
              callToActionTextStyle: NativeTemplateTextStyle(
                textColor: Colors.white,
                backgroundColor: buttonBackgroundColor,
                size: 16.0,
              ),
            ),
          )..load();
        })
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (nativeAdIsLoaded == false) {
      return const SizedBox(height: 50);
    }

    return SizedBox(height: 300, child: AdWidget(ad: nativeAd!));
  }
}

   // primaryTextStyle: NativeTemplateTextStyle(
              //   textColor: buttonBackgroundColor,
              //   backgroundColor: Colors.transparent,
              //   size: 13.0,
              // ),
              // secondaryTextStyle: NativeTemplateTextStyle(
              //   textColor: buttonBackgroundColor,
              //   backgroundColor: Colors.black,
              //   size: 16.0,
              // ),
              // tertiaryTextStyle: NativeTemplateTextStyle(
              //   textColor: buttonBackgroundColor,
              //   backgroundColor: Colors.amber,
              //   size: 16.0,
              // ),