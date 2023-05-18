import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class SpaceWidth extends StatelessWidget {
  SpaceWidth({super.key, required this.width});

  double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: width);
  }
}
