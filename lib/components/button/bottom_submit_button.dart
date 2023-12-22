import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';

class BottomSubmitButton extends StatelessWidget {
  const BottomSubmitButton({
    super.key,
    required this.onPressed,
    required this.text,
    required this.isEnabled,
    this.padding,
    this.width,
    this.height,
  });

  final VoidCallback onPressed;
  final String text;
  final bool isEnabled;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;

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
            foregroundColor:
                isEnabled ? buttonTextColor : disabledButtonTextColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
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
