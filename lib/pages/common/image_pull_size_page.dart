import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/framework/app_framework.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';

class ImagePullSizePage extends StatelessWidget {
  ImagePullSizePage({
    super.key,
    required this.binaryData,
  });

  Uint8List binaryData;

  @override
  Widget build(BuildContext context) {
    return AppFramework(
        widget: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              leading: const CloseButton(),
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              foregroundColor: buttonBackgroundColor,
            ),
            body: Center(child: Image.memory(binaryData))));
  }
}

// AppFramework

    