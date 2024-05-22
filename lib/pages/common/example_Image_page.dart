import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/common/CommonText.dart';
import 'package:flutter_app_weight_management/components/framework/app_framework.dart';

class ExampleImagePage extends StatelessWidget {
  ExampleImagePage({super.key, required this.title, required this.assetName});

  String title, assetName;

  @override
  Widget build(BuildContext context) {
    return AppFramework(
      widget: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: CommonText(
            text: title,
            size: 14,
            color: Colors.white,
            isBold: true,
          ),
          leading: const CloseButton(),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          foregroundColor: Colors.white,
        ),
        body: SafeArea(
          child: Center(
            child: Image.asset(assetName),
          ),
        ),
      ),
    );
  }
}
