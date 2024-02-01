import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import '../contents_box/contents_box.dart';
import '../space/spaceHeight.dart';

class EmptyTextVerticalArea extends StatelessWidget {
  EmptyTextVerticalArea(
      {super.key,
      required this.icon,
      required this.title,
      this.mainColor,
      this.height,
      this.backgroundColor,
      this.titleSize,
      this.iconSize,
      this.isBold});

  IconData icon;
  String title;
  double? titleSize, iconSize;
  double? height;
  Color? mainColor;
  Color? backgroundColor;
  bool? isBold;

  @override
  Widget build(BuildContext context) {
    return ContentsBox(
      backgroundColor: backgroundColor,
      width: MediaQuery.of(context).size.width,
      height: height ?? 150,
      contentsWidget: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: mainColor ?? disEnabledTypeColor,
            size: iconSize ?? 30,
          ),
          SpaceHeight(height: smallSpace),
          Text(
            title.tr(),
            style: TextStyle(
              fontSize: titleSize,
              color: mainColor ?? disEnabledTypeColor,
              height: 1.5,
              fontWeight: isBold == true ? FontWeight.bold : null,
            ),
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
