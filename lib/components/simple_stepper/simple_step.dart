import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';

class SimpleStep extends StatelessWidget {
  SimpleStep({
    super.key,
    required this.index,
    required this.step,
  });

  int index;
  int step;

  @override
  Widget build(BuildContext context) {
    var icons = [
      null,
      step == 1 ? Icons.looks_one_rounded : Icons.looks_one_outlined,
      step == 2 ? Icons.looks_two_rounded : Icons.looks_two_outlined,
      step == 3 ? Icons.looks_3_rounded : Icons.looks_3_outlined,
      step == 4 ? Icons.looks_4_rounded : Icons.looks_4_outlined,
    ];
    return Icon(
      icons[index],
      color: themeColor,
    );
  }
}
