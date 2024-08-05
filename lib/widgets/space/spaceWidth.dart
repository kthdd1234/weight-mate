import 'package:flutter/material.dart';

class SpaceWidth extends StatelessWidget {
  SpaceWidth({super.key, required this.width});

  double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: width);
  }
}
