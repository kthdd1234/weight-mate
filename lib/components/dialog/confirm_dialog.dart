import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/common/CommonBottomSheet.dart';
import 'package:flutter_app_weight_management/common/CommonText.dart';
import 'package:flutter_app_weight_management/components/button/ok_and_cancel_button.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/function.dart';

class ConfirmDialog extends StatelessWidget {
  ConfirmDialog({
    super.key,
    required this.titleText,
    required this.contentIcon,
    required this.contentText1,
    required this.contentText2,
    required this.onPressedOk,
    required this.width,
    this.onPressedCancel,
  });

  String titleText;
  IconData contentIcon;
  String contentText1;
  String contentText2;
  double width;
  Function() onPressedOk;
  Function()? onPressedCancel;

  @override
  Widget build(BuildContext context) {
    onClose() {
      closeDialog(context);
    }

    setOnPressedOk() {
      closeDialog(context);
      onPressedOk();
    }

    setOnPressedCancel() {
      closeDialog(context);

      if (onPressedCancel != null) {
        onPressedCancel!();
      }
    }

    return AlertDialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 30),
      shape: containerBorderRadious,
      backgroundColor: dialogBackgroundColor,
      title: DialogTitle(text: titleText, onTap: onClose),
      content: SizedBox(
          height: 200,
          child: Column(
            children: [
              ContentsBox(
                width: width,
                height: 130,
                contentsWidget: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        contentIcon,
                        size: 30,
                        color: themeColor,
                      ),
                      SpaceHeight(height: smallSpace),
                      CommonText(
                        text: contentText1,
                        size: 14,
                        color: primaryColor,
                        isCenter: true,
                      ),
                      CommonText(
                        text: contentText2,
                        size: 14,
                        color: primaryColor,
                        isCenter: true,
                      ),
                      SpaceHeight(height: tinySpace),
                    ]),
              ),
              SpaceHeight(height: regularSapce),
              OkAndCancelButton(
                okText: '확인',
                cancelText: '취소',
                onPressedOk: setOnPressedOk,
                onPressedCancel: setOnPressedCancel,
              )
            ],
          )),
    );
  }
}
