import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_app_weight_management/components/area/empty_area.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';

class SubText extends StatelessWidget {
  SubText({super.key, required this.text, required this.value});

  String text;
  String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(text, style: const TextStyle(color: disEnabledTypeColor)),
        value != '' ? SpaceWidth(width: tinySpace) : EmptyArea(),
        Text(value, style: const TextStyle(color: disEnabledTypeColor)),
      ],
    );
  }
}
