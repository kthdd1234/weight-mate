import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';

class AlertDialogTitleWidget extends StatelessWidget {
  AlertDialogTitleWidget({
    super.key,
    required this.text,
    required this.onTap,
  });

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
