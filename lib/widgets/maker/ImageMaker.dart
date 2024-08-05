import 'package:flutter/material.dart';

class ImageMaker extends StatelessWidget {
  const ImageMaker({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: Image.asset(
        'assets/images/saled.png',
        width: 22.5,
        height: 22.5,
        fit: BoxFit.cover,
      ),
    );
  }
}
