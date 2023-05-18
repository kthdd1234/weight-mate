import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';

class TodayMemoWidget extends StatelessWidget {
  TodayMemoWidget({super.key, required this.text});

  String text;

  @override
  Widget build(BuildContext context) {
    return ContentsBox(
      backgroundColor: dialogBackgroundColor,
      contentsWidget: Text(text),
    );
  }
}
 //   
 