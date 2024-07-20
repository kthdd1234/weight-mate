import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app_weight_management/common/CommonBottomSheet.dart';
import 'package:flutter_app_weight_management/common/CommonText.dart';
import 'package:flutter_app_weight_management/components/area/empty_area.dart';
import 'package:flutter_app_weight_management/components/button/expanded_button_hori.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/function.dart';

class CommonPopup extends StatefulWidget {
  CommonPopup({
    super.key,
    required this.title,
    required this.height,
    required this.buttonText,
    required this.onTap,
    this.text1,
    this.text2,
    this.text3,
  });

  String title, buttonText;
  double height;
  String? text1, text2, text3;
  Function() onTap;

  @override
  State<CommonPopup> createState() => _CommonPopupState();
}

class _CommonPopupState extends State<CommonPopup> {
  wText(String? text) {
    return text != null
        ? CommonText(text: text, size: 14, isCenter: true)
        : const EmptyArea();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 30),
      shape: containerBorderRadious,
      backgroundColor: whiteBgBtnColor,
      title: DialogTitle(
        text: widget.title,
        onTap: () => closeDialog(context),
      ),
      content: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: widget.height,
        child: Column(
          children: [
            ContentsBox(
              contentsWidget: Column(
                children: [
                  wText(widget.text1),
                  SpaceHeight(height: widget.text2 != null ? 3 : 0),
                  wText(widget.text2),
                  SpaceHeight(height: widget.text3 != null ? 3 : 0),
                  wText(widget.text3)
                ],
              ),
            ),
            SpaceHeight(height: 10),
            Row(
              children: [
                ExpandedButtonHori(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  imgUrl: 'assets/images/t-23.png',
                  text: widget.buttonText,
                  onTap: widget.onTap,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
