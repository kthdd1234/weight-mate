import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/common/CommonText.dart';
import 'package:flutter_app_weight_management/components/area/empty_area.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';

import '../space/spaceWidth.dart';

class ExpandedButtonHori extends StatelessWidget {
  ExpandedButtonHori({
    super.key,
    this.imgUrl,
    this.color,
    this.icon,
    this.padding,
    required this.text,
    required this.onTap,
  });

  String? imgUrl;
  Color? color;
  IconData? icon;
  String text;
  EdgeInsets? padding;
  Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: ContentsBox(
          padding: padding ?? pagePadding,
          imgUrl: imgUrl,
          backgroundColor: color,
          contentsWidget: CommonText(
            text: text,
            size: 14,
            leftIcon: icon,
            isBold: true,
            isCenter: true,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
