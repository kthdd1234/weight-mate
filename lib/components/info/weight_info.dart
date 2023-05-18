import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/text/body_small_text.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';

class WeightInfo extends StatelessWidget {
  WeightInfo({
    super.key,
    required this.name,
    required this.value,
  });

  String name;
  String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BodySmallText(text: name),
        SpaceHeight(height: smallSpace),
        Text(value, style: const TextStyle(fontSize: 15))
      ],
    );
  }
}
