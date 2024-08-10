import 'package:flutter/material.dart';

class PictureMaker extends StatelessWidget {
  PictureMaker({super.key, required this.path, required this.size});

  String path;
  double size;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: Image.asset(
        'assets/images/$path.png',
        width: size,
        height: size,
        fit: BoxFit.cover,
      ),
    );
  }
}
