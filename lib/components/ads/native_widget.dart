import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/area/empty_area.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
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
    if (nativeAdIsLoaded == false) return const EmptyArea();

    return Column(
      children: [
        ContentsBox(
          padding: const EdgeInsets.all(10),
          width: double.maxFinite,
          height: 300,
          contentsWidget: AdWidget(ad: nativeAd!),
        ),
        SpaceHeight(height: smallSpace),
      ],
    );
  }
}
