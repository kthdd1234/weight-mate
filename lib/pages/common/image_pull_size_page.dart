import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/common/CommonBackground.dart';
import 'package:flutter_app_weight_management/common/CommonScaffold.dart';
import 'package:flutter_app_weight_management/utils/class.dart';

class ImagePullSizePage extends StatelessWidget {
  ImagePullSizePage({super.key, required this.binaryData});

  Uint8List binaryData;

  @override
  Widget build(BuildContext context) {
    return CommonBackground(
      child: CommonScaffold(
        appBarInfo: AppBarInfoClass(title: '', leading: const CloseButton()),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        body: Center(child: Image.memory(binaryData)),
      ),
    );
  }
}
