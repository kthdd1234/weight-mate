import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import '../space/spaceWidth.dart';

class EmptyTextArea extends StatelessWidget {
  EmptyTextArea(
      {super.key,
      required this.text,
      required this.icon,
      required this.topHeight,
      required this.downHeight,
      required this.onTap,
      this.backgroundColor});

  String text;
  IconData icon;
  double topHeight;
  double downHeight;
  Color? backgroundColor;
  Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: ContentsBox(
        width: MediaQuery.of(context).size.width,
        backgroundColor: backgroundColor ?? dialogBackgroundColor,
        contentsWidget: Column(
          children: [
            SpaceHeight(height: topHeight),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: disEnabledTypeColor),
                SpaceWidth(width: tinySpace),
                Text(text, style: const TextStyle(color: disEnabledTypeColor))
              ],
            ),
            SpaceHeight(height: downHeight),
          ],
        ),
      ),
    );
  }
}
