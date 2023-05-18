import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';

class HistorySubTextWidget extends StatelessWidget {
  HistorySubTextWidget({super.key, required this.text, required this.color});

  String text;
  Color color;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: color,
        fontSize: 13,
      ),
    );
  }
}
