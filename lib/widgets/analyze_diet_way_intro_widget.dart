import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/framework/app_framework.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';

class AnalyzeDietWayIntroWidget extends StatelessWidget {
  const AnalyzeDietWayIntroWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AppFramework(
      widget: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
            title: const Text(
              '다이어트 방법',
              style: TextStyle(fontSize: 18, color: themeColor),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            iconTheme: const IconThemeData(
              color: themeColor,
            )),
        body: SingleChildScrollView(
          child: Padding(
            padding: pagePadding,
            child: Column(
              children: [
                ContentsBox(contentsWidget: Text('')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
