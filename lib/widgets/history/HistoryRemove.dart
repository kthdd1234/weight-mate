import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/common/CommonIcon.dart';

class HistoryRemove extends StatelessWidget {
  HistoryRemove({super.key, required this.onTap});

  Function() onTap;

  @override
  Widget build(BuildContext context) {
    return CommonIcon(
      icon: Icons.remove_circle,
      size: 15,
      color: Colors.red,
      onTap: onTap,
    );
  }
}
