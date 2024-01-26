import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/common/CommonText.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class NativeWidget extends StatelessWidget {
  NativeWidget({
    super.key,
    required this.nativeAd,
    this.height,
    this.padding,
  });

  NativeAd nativeAd;
  double? padding, height;

  @override
  Widget build(BuildContext context) {
    return ContentsBox(
      padding: EdgeInsets.all(padding ?? 10),
      width: double.maxFinite,
      height: height ?? 320,
      contentsWidget: AdWidget(ad: nativeAd),
    );
  }
}

class NativeAdLoading extends StatelessWidget {
  NativeAdLoading({super.key, required this.text, required this.color});

  String text;
  Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const CircularProgressIndicator(strokeWidth: 3),
        SpaceHeight(height: smallSpace),
        CommonText(
          text: text,
          size: 11,
          isCenter: true,
          color: color,
        )
      ],
    );
  }
}
