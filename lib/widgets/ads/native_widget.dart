import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/widgets/area/empty_area.dart';
import 'package:flutter_app_weight_management/widgets/contents_box/contents_box.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class NativeWidget extends StatelessWidget {
  NativeWidget({
    super.key,
    this.nativeAd,
    this.height,
    this.padding,
  });

  NativeAd? nativeAd;
  double? padding, height;

  @override
  Widget build(BuildContext context) {
    return nativeAd != null
        ? ContentsBox(
            padding: EdgeInsets.all(padding ?? 10),
            width: double.maxFinite,
            height: height ?? 320,
            child: AdWidget(ad: nativeAd!),
          )
        : ContentsBox(
            width: double.maxFinite,
            height: 0,
            child: const EmptyArea(),
          );
  }
}
