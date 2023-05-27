import 'package:flutter/material.dart';

class SpaceHeight extends StatelessWidget {
  SpaceHeight({super.key, required this.height});

  double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: height);
  }
}
