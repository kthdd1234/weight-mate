import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';

class OkAndCancelButton extends StatelessWidget {
  OkAndCancelButton({
    super.key,
    required this.okText,
    required this.cancelText,
    required this.onPressedOk,
    required this.onPressedCancel,
  });

  String okText;
  String cancelText;
  Function()? onPressedOk;
  Function() onPressedCancel;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ElevatedButton(
          onPressed: onPressedOk,
          child: Text(okText),
        ),
        TextButton(
          onPressed: onPressedCancel,
          child: Text(cancelText),
        ),
      ],
    );
  }
}
