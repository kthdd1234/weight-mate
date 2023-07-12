import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/ads/native_widget.dart';
import 'package:flutter_app_weight_management/components/button/expanded_button_hori.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:flutter_app_weight_management/widgets/alert_dialog_title_widget.dart';

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
    return AlertDialog(
      shape: containerBorderRadious,
      backgroundColor: dialogBackgroundColor,
      elevation: 0.0,
      title: AlertDialogTitleWidget(
        text: title,
        onTap: () => closeDialog(context),
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            NativeWidget(),
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
