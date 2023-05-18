import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';

class ContentsBoxExp extends StatelessWidget {
  ContentsBoxExp({
    super.key,
    required this.height,
    required this.backgroundColor,
    required this.widget,
  });

  double height;
  Color backgroundColor;
  Widget widget;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ContentsBox(
        height: height,
        backgroundColor: backgroundColor,
        contentsWidget: widget,
      ),
    );
  }
}
