import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/area/empty_area.dart';
import 'package:flutter_app_weight_management/components/divider/width_divider.dart';
import 'package:flutter_app_weight_management/components/icon/circular_icon.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';

class AnalyzeProgressItemWidget extends StatelessWidget {
  AnalyzeProgressItemWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.sub,
    required this.isLastIndex,
  });

  IconData icon;
  String title;
  String sub;
  bool isLastIndex;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 0,
          child: CircularIcon(
            widthAndHeight: 45,
            borderRadius: 10,
            icon: icon,
            backgroundColor: typeBackgroundColor,
          ),
        ),
        SpaceWidth(width: regularSapce),
        Expanded(
            flex: 4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SpaceHeight(height: tinySpace),
                Text(
                  title,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 13),
                ),
                SpaceHeight(height: smallSpace),
                Text(sub, style: const TextStyle(fontSize: 12)),
                isLastIndex == false
                    ? Column(
                        children: [
                          SpaceHeight(height: regularSapce),
                          WidthDivider(
                            width: double.infinity,
                            color: Colors.grey[300],
                          ),
                          SpaceHeight(height: regularSapce),
                        ],
                      )
                    : SpaceHeight(height: tinySpace)
              ],
            ))
      ],
    );
  }
}
