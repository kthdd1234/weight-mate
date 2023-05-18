import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';

class SpaceHeight extends StatelessWidget {
  SpaceHeight({super.key, required this.height});

  double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: height);
  }
}
