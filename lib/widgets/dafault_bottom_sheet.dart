import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/area/empty_area.dart';
import 'package:flutter_app_weight_management/components/button/bottom_submit_button.dart';
import 'package:flutter_app_weight_management/components/icon/circular_icon.dart';
import 'package:flutter_app_weight_management/components/icon/default_icon.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/text/contents_title_text.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/function.dart';

class DefaultBottomSheet extends StatelessWidget {
  DefaultBottomSheet({
    super.key,
    required this.title,
    required this.height,
    required this.contents,
    this.submitText,
    this.onSubmit,
    this.isEnabled,
    this.titleLeftWidget,
  });

  String title;
  double height;
  Widget contents;
  String? submitText;
  bool? isEnabled;
  Function()? onSubmit;
  Widget? titleLeftWidget;

  @override
  Widget build(BuildContext context) {
    onCloseIcon(Color color) {
      return GestureDetector(
        onTap: () => closeDialog(context),
        child: Icon(Icons.close, color: color),
      );
    }

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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                titleLeftWidget ?? onCloseIcon(Colors.transparent),
                ContentsTitleText(text: title),
                onCloseIcon(themeColor),
              ],
            ),
            SpaceHeight(height: regularSapce),
            contents,
            SpaceHeight(height: regularSapce),
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
