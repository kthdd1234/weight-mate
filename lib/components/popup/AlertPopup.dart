import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app_weight_management/common/CommonName.dart';
import 'package:flutter_app_weight_management/common/CommonPopup.dart';
import 'package:flutter_app_weight_management/common/CommonText.dart';
import 'package:flutter_app_weight_management/components/area/empty_area.dart';
import 'package:flutter_app_weight_management/components/button/expanded_button_hori.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/utils/function.dart';

class AlertPopup extends StatelessWidget {
  AlertPopup({
    super.key,
    required this.height,
    required this.buttonText,
    required this.onTap,
    this.title,
    this.text1,
    this.text2,
    this.text3,
    this.containerChild,
    this.nameArgs,
    this.isCancel,
    this.buttonChild,
    this.insetPaddingHorizontal,
  });

  String buttonText;
  String? title;
  double height;
  String? text1, text2, text3;
  bool? isCancel;
  Widget? containerChild, buttonChild;
  Map<String, String>? nameArgs;
  Function() onTap;
  double? insetPaddingHorizontal;

  wText(String? text) {
    return text != null
        ? CommonText(text: text, size: 14, isCenter: true, nameArgs: nameArgs)
        : const EmptyArea();
  }

  @override
  Widget build(BuildContext context) {
    return CommonPopup(
      insetPaddingHorizontal: insetPaddingHorizontal,
      height: height,
      child: Column(
        children: [
          title != null
              ? Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: CommonName(text: title!),
                )
              : const EmptyArea(),
          ContentsBox(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            contentsWidget: Column(
              children: [
                wText(text1),
                SpaceHeight(height: text2 != null ? 3 : 0),
                wText(text2),
                SpaceHeight(height: text3 != null ? 3 : 0),
                wText(text3),
                containerChild != null ? containerChild! : const EmptyArea()
              ],
            ),
          ),
          buttonChild != null ? buttonChild! : const EmptyArea(),
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
          ),
        ],
      ),
    );
  }
}
