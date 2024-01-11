import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/common/CommonText.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/provider/ads_provider.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

class NativeWidget extends StatelessWidget {
  NativeWidget({super.key, this.padding});

  double? padding;

  @override
  Widget build(BuildContext context) {
    NativeAd? nativeAd = context.read<AdsProvider>().ad;

    return Column(
      children: [
        ContentsBox(
          padding: EdgeInsets.all(padding ?? 10),
          width: double.maxFinite,
          height: 300,
          contentsWidget: nativeAd != null
              ? AdWidget(ad: nativeAd)
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
