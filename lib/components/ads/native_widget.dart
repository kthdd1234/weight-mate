import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/common/CommonText.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/provider/ads_provider.dart';
import 'package:flutter_app_weight_management/services/ads_service.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

class NativeWidget extends StatefulWidget {
  NativeWidget({super.key, this.height, this.padding});

  double? padding, height;

  @override
  State<NativeWidget> createState() => _NativeWidgetState();
}

class _NativeWidgetState extends State<NativeWidget> {
  NativeAd? nativeAd;
  bool nativeAdIsLoaded = false;

  @override
  void didChangeDependencies() {
    final adsState = Provider.of<AdsProvider>(context).adsState;

    nativeAd = NativeAd(
      adUnitId: adsState.nativeAdUnitId,
      listener: NativeAdListener(
        onAdLoaded: (adLoaded) {
          log('$adLoaded loaded~~~!!');
          setState(() {
            nativeAdIsLoaded = true;
          });
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
        cornerRadius: 10.0,
        callToActionTextStyle: NativeTemplateTextStyle(
          textColor: Colors.white,
          backgroundColor: themeColor,
          style: NativeTemplateFontStyle.bold,
        ),
        primaryTextStyle: NativeTemplateTextStyle(
          textColor: themeColor,
          style: NativeTemplateFontStyle.bold,
        ),
      ),
    )..load();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    nativeAd = null;
    nativeAdIsLoaded = false;

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ContentsBox(
          padding: EdgeInsets.all(widget.padding ?? 10),
          width: double.maxFinite,
          height: widget.height ?? 320,
          contentsWidget: nativeAdIsLoaded
              ? AdWidget(ad: nativeAd!)
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(strokeWidth: 3),
                    SpaceHeight(height: smallSpace),
                    CommonText(
                      text: '광고 로드 중...',
                      size: 11,
                      isCenter: true,
                      color: Colors.grey,
                    )
                  ],
                ),
        ),
        SpaceHeight(height: smallSpace),
      ],
    );
  }
}
