import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/common/CommonText.dart';
import 'package:flutter_app_weight_management/components/area/empty_area.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/utils/variable.dart';

class WeightMaker extends StatelessWidget {
  WeightMaker({
    super.key,
    required this.weight,
    required this.weightUnit,
    this.icon,
    this.textColor,
    this.bgColor,
  });

  double weight;
  String weightUnit;
  IconData? icon;
  Color? textColor, bgColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 1.5),
      decoration: BoxDecoration(
        color: bgColor ?? indigo.s300,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon != null
              ? Icon(icon, color: Colors.white, size: 10)
              : const EmptyArea(),
          CommonText(
            text: '$weight',
            size: 8.5,
            color: textColor ?? Colors.white,
            isCenter: true,
            isNotTr: true,
            isBold: true,
          ),
        ],
      ),
    );
  }
}
