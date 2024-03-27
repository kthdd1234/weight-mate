import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/common/CommonBottomSheet.dart';
import 'package:flutter_app_weight_management/common/CommonButton.dart';
import 'package:flutter_app_weight_management/components/ads/banner_widget.dart';
import 'package:flutter_app_weight_management/components/ads/native_widget.dart';
import 'package:flutter_app_weight_management/components/area/empty_area.dart';
import 'package:flutter_app_weight_management/components/button/expanded_button_hori.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/provider/ads_provider.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

class NativeAdDialog extends StatefulWidget {
  NativeAdDialog({
    super.key,
    required this.loadingText,
    required this.title,
    required this.leftText,
    required this.rightText,
    required this.onLeftClick,
    required this.onRightClick,
    this.nameArgs,
  });

  String loadingText, title, leftText, rightText;
  Map<String, String>? nameArgs;
  Function() onLeftClick, onRightClick;

  @override
  State<NativeAdDialog> createState() => _NativeAdDialogState();
}

class _NativeAdDialogState extends State<NativeAdDialog> {
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
              nativeAd = null;
              isLoaded = true;
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
      closeDialog(context);
      return const EmptyArea();
    }

    return isLoaded
        ? AlertDialog(
            insetPadding: const EdgeInsets.symmetric(horizontal: 30),
            scrollable: true,
            shape: containerBorderRadious,
            backgroundColor: dialogBackgroundColor,
            elevation: 0.0,
            title: DialogTitle(
              text: widget.title,
              nameArgs: widget.nameArgs,
              onTap: () => closeDialog(context),
            ),
            content: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                NativeWidget(nativeAd: nativeAd),
                SpaceHeight(height: smallSpace),
                Row(
                  children: [
                    ExpandedButtonHori(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 10),
                      imgUrl: 'assets/images/t-23.png',
                      text: widget.leftText,
                      onTap: widget.onLeftClick,
                    ),
                    SpaceWidth(width: tinySpace),
                    ExpandedButtonHori(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 10),
                      imgUrl: 'assets/images/t-11.png',
                      text: widget.rightText,
                      onTap: widget.onRightClick,
                    ),
                    SpaceWidth(width: tinySpace),
                    ExpandedButtonHori(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 10),
                      imgUrl: 'assets/images/t-22.png',
                      text: '창 닫기',
                      onTap: () => closeDialog(context),
                    ),
                  ],
                ),
              ],
            ),
          )
        : LoadingDialog(text: widget.loadingText, color: Colors.white);
  }
}
