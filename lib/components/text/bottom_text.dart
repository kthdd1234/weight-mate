import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/text/body_small_text.dart';

class BottomText extends StatelessWidget {
  BottomText({super.key, required this.bottomText});

  String bottomText;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [BodySmallText(text: bottomText)],
    );
  }
}
