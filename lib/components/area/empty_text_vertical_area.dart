import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import '../contents_box/contents_box.dart';
import '../space/spaceHeight.dart';

class EmptyTextVerticalArea extends StatelessWidget {
  EmptyTextVerticalArea({
    super.key,
    required this.icon,
    required this.title,
    this.height,
  });

  IconData icon;
  String title;
  double? height;

  @override
  Widget build(BuildContext context) {
    return ContentsBox(
      backgroundColor: dialogBackgroundColor,
      width: MediaQuery.of(context).size.width,
      height: height ?? 150,
      contentsWidget: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, color: disEnabledTypeColor, size: 30),
          SpaceHeight(height: smallSpace),
          Text(
            title,
            style: const TextStyle(color: disEnabledTypeColor),
          )
        ],
      ),
    );
  }
}
