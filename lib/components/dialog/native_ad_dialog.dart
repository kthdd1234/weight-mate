import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/common/CommonBottomSheet.dart';
import 'package:flutter_app_weight_management/components/ads/native_widget.dart';
import 'package:flutter_app_weight_management/components/button/expanded_button_hori.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
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
    required this.onLeftClick,
    required this.onRightClick,
  });

  String title, leftText, rightText;
  Function() onLeftClick, onRightClick;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      shape: containerBorderRadious,
      backgroundColor: dialogBackgroundColor,
      elevation: 0.0,
      title: DialogTitle(
        text: title,
        onTap: () => closeDialog(context),
      ),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          NativeWidget(),
          SpaceHeight(height: smallSpace),
          Row(
            children: [
              ExpandedButtonHori(
                imgUrl: 'assets/images/t-23.png',
                text: leftText,
                onTap: onLeftClick,
              ),
              SpaceWidth(width: tinySpace),
              ExpandedButtonHori(
                imgUrl: 'assets/images/t-11.png',
                text: rightText,
                onTap: onRightClick,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
