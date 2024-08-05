import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app_weight_management/common/CommonPopup.dart';
import 'package:flutter_app_weight_management/common/CommonText.dart';
import 'package:flutter_app_weight_management/widgets/area/empty_area.dart';
import 'package:flutter_app_weight_management/widgets/button/expanded_button_hori.dart';
import 'package:flutter_app_weight_management/widgets/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/widgets/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/widgets/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/utils/function.dart';

class AlertPopup extends StatelessWidget {
  AlertPopup({
    super.key,
    required this.height,
    required this.buttonText,
    required this.onTap,
    this.text1,
    this.text2,
    this.text3,
    this.isCancel,
  });

  String buttonText;
  double height;
  String? text1, text2, text3;
  bool? isCancel;
  Function() onTap;

  wText(String? text) {
    return text != null
        ? CommonText(text: text, size: 14, isCenter: true)
        : const EmptyArea();
  }

  @override
  Widget build(BuildContext context) {
    return CommonPopup(
      height: height,
      child: Column(
        children: [
          ContentsBox(
            child: Column(
              children: [
                wText(text1),
                SpaceHeight(height: text2 != null ? 3 : 0),
                wText(text2),
                SpaceHeight(height: text3 != null ? 3 : 0),
                wText(text3)
              ],
            ),
          ),
          SpaceHeight(height: 10),
          Row(
            children: [
              ExpandedButtonHori(
                padding: const EdgeInsets.symmetric(vertical: 15),
                imgUrl: 'assets/images/t-4.png',
                text: buttonText,
                onTap: onTap,
              ),
              SpaceWidth(width: isCancel == true ? 7 : 0),
              isCancel == true
                  ? ExpandedButtonHori(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      imgUrl: 'assets/images/t-3.png',
                      text: '취소',
                      onTap: () => closeDialog(context),
                    )
                  : const EmptyArea()
            ],
          )
        ],
      ),
    );
  }
}
