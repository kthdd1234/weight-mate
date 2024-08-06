import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/common/CommonText.dart';

class BarMaker extends StatelessWidget {
  BarMaker({
    super.key,
    required this.weight,
    required this.weightUnit,
    required this.color,
  });

  double weight;
  String weightUnit;
  Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 1),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(3),
      ),
      child: CommonText(
        text: '$weight$weightUnit',
        size: 8.5,
        color: Colors.white,
        isCenter: true,
        isNotTr: true,
        isBold: true,
      ),
    );
  }
}
