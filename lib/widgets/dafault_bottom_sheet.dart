import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/button/bottom_submit_button.dart';
import 'package:flutter_app_weight_management/components/icon/default_icon.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/text/contents_title_text.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';

class DefaultBottomSheet extends StatelessWidget {
  DefaultBottomSheet({
    super.key,
    required this.title,
    required this.widgets,
    required this.isEnabled,
    required this.submitText,
    required this.onSubmit,
  });

  String title;
  List<Widget> widgets;
  String submitText;
  bool isEnabled;
  Function() onSubmit;

  @override
  Widget build(BuildContext context) {
    onCloseButton(String id) {
      //
    }

    return Container(
      height: 380,
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [ContentsTitleText(text: title)],
            ),
            SpaceHeight(height: regularSapce),
            Column(children: widgets),
            SpaceHeight(height: regularSapce),
            BottomSubmitButton(
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
              width: MediaQuery.of(context).size.width,
              text: submitText,
              onPressed: onSubmit,
              isEnabled: isEnabled,
            )
          ],
        ),
      ),
    );
  }
}
