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
  double? padding;
  Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: ContentsBox(
          padding: padding != null ? EdgeInsets.all(padding!) : null,
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
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     icon != null
          //         ? Row(
          //             children: [
          //               Icon(icon, color: Colors.white, size: 18),
          //               SpaceWidth(width: tinySpace),
          //             ],
          //           )
          //         : const EmptyArea(),
          //     Text(
          //       text,
          //       style: const TextStyle(
          //         fontSize: 14,
          //         fontWeight: FontWeight.bold,
          //         color: Colors.white,
          //       ),
          //     ),
          //   ],
          // ),
        ),
      ),
    );
  }
}
