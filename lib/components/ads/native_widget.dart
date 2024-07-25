import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/common/CommonText.dart';
import 'package:flutter_app_weight_management/components/area/empty_area.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
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
            contentsWidget: AdWidget(ad: nativeAd!),
          )
        : ContentsBox(
            width: double.maxFinite,
            height: 0,
            contentsWidget: const EmptyArea(),
          );
  }
}
