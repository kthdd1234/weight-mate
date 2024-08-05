import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/common/CommonBackground.dart';
import 'package:flutter_app_weight_management/widgets/area/empty_area.dart';
import 'package:flutter_app_weight_management/widgets/button/bottom_submit_button.dart';
import 'package:flutter_app_weight_management/widgets/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';

class CommonBottomSheet extends StatelessWidget {
  CommonBottomSheet({
    super.key,
    required this.title,
    required this.height,
    required this.contents,
    this.submitText,
    this.onSubmit,
    this.isEnabled,
    this.titleLeftWidget,
    this.subContents,
    this.padding,
    this.isRemoveBottom,
  });

  String title;
  double height;
  Widget contents;
  Widget? subContents;
  String? submitText;
  bool? isEnabled;
  Function()? onSubmit;
  Widget? titleLeftWidget;
  EdgeInsets? padding;
  bool? isRemoveBottom;

  @override
  Widget build(BuildContext context) {
    return CommonBackground(
      height: height,
      isRadius: true,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(10),
        topRight: Radius.circular(10),
      ),
      child: Padding(
        padding: padding ?? pagePadding,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  color: textColor,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            SpaceHeight(height: 15),
            contents,
            SpaceHeight(height: smallSpace),
            subContents ?? const EmptyArea(),
            SpaceHeight(height: subContents != null ? regularSapce : 0),
            isEnabled != null
                ? BottomSubmitButton(
                    padding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                    width: MediaQuery.of(context).size.width,
                    text: submitText ?? '',
                    onPressed: onSubmit!,
                    isEnabled: isEnabled!,
                  )
                : const EmptyArea()
          ],
        ),
      ),
    );
  }
}
