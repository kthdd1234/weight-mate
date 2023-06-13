import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';

class TodayDiaryDataWidget extends StatelessWidget {
  TodayDiaryDataWidget({super.key, required this.text});

  String text;

  @override
  Widget build(BuildContext context) {
    return ContentsBox(
      width: MediaQuery.of(context).size.width,
      backgroundColor: typeBackgroundColor,
      contentsWidget: Text(text),
    );
  }
}
 //   
 