import 'dart:typed_data';
import 'package:flutter/material.dart';

class DefaultImage extends StatelessWidget {
  DefaultImage({
    super.key,
    required this.data,
    required this.height,
  });

  Uint8List data;
  double height;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: Image.memory(
        fit: BoxFit.cover,
        width: double.infinity,
        height: height,
        data,
      ),
    );
  }
}
