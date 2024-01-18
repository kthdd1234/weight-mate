import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/common/CommonText.dart';
import 'package:flutter_app_weight_management/components/area/empty_area.dart';
import 'package:flutter_app_weight_management/components/button/bottom_submit_button.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/text/contents_title_text.dart';
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
  });

  String title;
  double height;
  Widget contents;
  Widget? subContents;
  String? submitText;
  bool? isEnabled;
  Function()? onSubmit;
  Widget? titleLeftWidget;

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
        padding: pagePadding,
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
  DialogTitle({super.key, required this.text, required this.onTap});

  String text;
  Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          text,
          style: const TextStyle(fontSize: 18, color: themeColor),
        ),
        InkWell(
          onTap: onTap,
          child: const Icon(Icons.close, color: disabledButtonTextColor),
        )
      ],
    );
  }
}
