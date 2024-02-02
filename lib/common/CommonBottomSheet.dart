import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/common/CommonIcon.dart';
import 'package:flutter_app_weight_management/common/CommonText.dart';
import 'package:flutter_app_weight_management/components/area/empty_area.dart';
import 'package:flutter_app_weight_management/components/button/bottom_submit_button.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/function.dart';

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

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10.0),
        image: const DecorationImage(
          image: AssetImage('assets/images/Cloudy_Apple.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Padding(
        padding: padding ?? pagePadding,
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(
                  fontSize: 15, color: themeColor, fontWeight: FontWeight.bold),
            ),
            SpaceHeight(height: regularSapce),
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

class DialogTitle extends StatelessWidget {
  DialogTitle({
    super.key,
    required this.text,
    required this.onTap,
    this.nameArgs,
  });

  String text;
  Map<String, String>? nameArgs;
  Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CommonText(text: text, size: 18, nameArgs: nameArgs),
        CommonIcon(
          icon: Icons.close,
          size: 25,
          color: disabledButtonTextColor,
          onTap: onTap,
        ),
      ],
    );
  }
}
