import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/variable.dart';

class BottomSubmitButton extends StatelessWidget {
  BottomSubmitButton({
    super.key,
    required this.onPressed,
    required this.text,
    required this.isEnabled,
    this.padding,
    this.width,
    this.height,
    this.borderRadius,
  });

  final VoidCallback onPressed;
  final String text;
  final bool isEnabled;
  final EdgeInsetsGeometry? padding;
  double? width, height, borderRadius;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          padding ?? const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: SizedBox(
        width: width,
        height: height ?? submitButtonHeight,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            elevation: isEnabled ? 2.0 : 0.0,
            backgroundColor:
                isEnabled ? themeColor : disabledButtonBackgroundColor,
            foregroundColor: isEnabled ? buttonTextColor : grey.s400,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius ?? 30.0),
            ),
            textStyle: Theme.of(context).textTheme.labelLarge,
          ),
          onPressed: onPressed,
          child: Text(text),
        ),
      ),
    );
  }
}
