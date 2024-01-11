import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/common/CommonBottomSheet.dart';
import 'package:flutter_app_weight_management/components/ads/native_widget.dart';
import 'package:flutter_app_weight_management/components/button/expanded_button_hori.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/provider/ads_provider.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:provider/provider.dart';

class NativeAdDialog extends StatelessWidget {
  NativeAdDialog({
    super.key,
    required this.title,
    required this.leftText,
    required this.rightText,
    required this.leftIcon,
    required this.rightIcon,
    required this.onLeftClick,
    required this.onRightClick,
  });

  String title, leftText, rightText;
  IconData leftIcon, rightIcon;
  Function() onLeftClick, onRightClick;

  @override
  Widget build(BuildContext context) {
    onPopInvoked(_) {
      context.read<AdsProvider>().setNativeAd();
    }

    return AlertDialog(
      shape: containerBorderRadious,
      backgroundColor: dialogBackgroundColor,
      elevation: 0.0,
      title: DialogTitle(
        text: title,
        onTap: () => closeDialog(context),
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            PopScope(onPopInvoked: onPopInvoked, child: NativeWidget()),
            Row(
              children: [
                ExpandedButtonHori(
                  imgUrl: 'assets/images/t-23.png',
                  icon: leftIcon,
                  text: leftText,
                  onTap: onLeftClick,
                ),
                SpaceWidth(width: tinySpace),
                ExpandedButtonHori(
                  imgUrl: 'assets/images/t-11.png',
                  icon: rightIcon,
                  text: rightText,
                  onTap: onRightClick,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
