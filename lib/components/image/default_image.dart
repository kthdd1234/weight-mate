import 'dart:io';
import 'package:flutter/material.dart';

class DefaultImage extends StatelessWidget {
  DefaultImage({
    super.key,
    required this.path,
    required this.height,
  });

  String path;
  double height;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: Image(
        fit: BoxFit.cover,
        width: double.infinity,
        height: height,
        image: FileImage(File(path)),
      ),
    );
  }
}
