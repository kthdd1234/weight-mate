import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';

import '../space/spaceWidth.dart';

class ExpandedButtonHori extends StatelessWidget {
  ExpandedButtonHori({
    super.key,
    this.imgUrl,
    this.color,
    required this.icon,
    required this.text,
    required this.onTap,
  });

  String? imgUrl;
  Color? color;
  IconData icon;
  String text;
  Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: ContentsBox(
          imgUrl: imgUrl,
          backgroundColor: color,
          contentsWidget: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 18),
              SpaceWidth(width: tinySpace),
              Text(
                text,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
