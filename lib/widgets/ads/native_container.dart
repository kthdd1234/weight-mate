import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/common/CommonText.dart';
import 'package:flutter_app_weight_management/widgets/ads/native_widget.dart';
import 'package:flutter_app_weight_management/widgets/popup/LoadingPopup.dart';
import 'package:flutter_app_weight_management/widgets/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/provider/ads_provider.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

class NativeContainer extends StatefulWidget {
  NativeContainer({super.key});

  @override
  State<NativeContainer> createState() => _NativeContainerState();
}

class _NativeContainerState extends State<NativeContainer> {
  NativeAd? nativeAd;
  bool isLoaded = false;
  bool isNotAdShow = false;

  @override
  void didChangeDependencies() {
    final adsState = Provider.of<AdsProvider>(context).adsState;

    checkHideAd() async {
      bool isHide = await isHideAd();

      if (isHide == true) {
        setState(() => isNotAdShow = isHide);
      } else if (isHide == false) {
        nativeAd = loadNativeAd(
          adUnitId: adsState.nativeAdUnitId,
          onAdLoaded: () {
            setState(() => isLoaded = true);
          },
          onAdFailedToLoad: () {
            setState(() {
              isLoaded = false;
              nativeAd = null;
            });
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
      return const Row(children: []);
    }

    return Column(
      children: [
        CommonText(text: '광고', size: 12, isBold: true),
        SpaceHeight(height: smallSpace),
        isLoaded
            ? NativeWidget(padding: 0, height: 340, nativeAd: nativeAd)
            : SizedBox(
                height: 340,
                child: LoadingPopup(text: '', color: Colors.transparent),
              )
      ],
    );
  }
}
