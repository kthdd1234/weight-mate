import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/framework/app_framework.dart';

class ImagePullSizePage extends StatelessWidget {
  ImagePullSizePage({super.key, required this.binaryData});

  Uint8List binaryData;

  @override
  Widget build(BuildContext context) {
    return AppFramework(
      widget: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          leading: const CloseButton(),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          foregroundColor: Colors.white,
        ),
        body: Center(child: Image.memory(binaryData)),
      ),
    );
  }
}
