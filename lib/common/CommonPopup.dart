import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/common/CommonBackground.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';

class CommonPopup extends StatelessWidget {
  CommonPopup({
    super.key,
    required this.height,
    required this.child,
    this.insetPaddingHorizontal,
  });

  double height;
  Widget child;
  double? insetPaddingHorizontal;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(0),
      insetPadding: EdgeInsets.symmetric(
        horizontal: insetPaddingHorizontal ?? 30,
      ),
      shape: roundedRectangleBorder,
      content: CommonBackground(
        isRadius: true,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        padding: const EdgeInsets.all(20),
        height: height,
        child: child,
      ),
    );
  }
}
