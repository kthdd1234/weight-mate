import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/area/empty_area.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';

class HistorySegmentedItemWidget extends StatelessWidget {
  HistorySegmentedItemWidget({
    super.key,
    required this.icon,
    required this.name,
    this.suffixWidget,
    this.subWidget,
  });

  IconData icon;
  String name;
  Widget? suffixWidget;
  Widget? subWidget;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ContentsBox(
          backgroundColor: dialogBackgroundColor,
          contentsWidget: Row(
            children: [
              Container(
                width: 35,
                height: 35,
                decoration: BoxDecoration(
                  color: typeBackgroundColor,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Icon(icon, size: 20, color: buttonBackgroundColor),
              ),
              SpaceWidth(width: regularSapce),
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                          color: buttonBackgroundColor,
                          fontWeight: FontWeight.bold),
                    ),
                    subWidget != null
                        ? Column(
                            children: [
                              SpaceHeight(height: smallSpace),
                              subWidget!
                            ],
                          )
                        : const EmptyArea()
                  ],
                ),
              ),
              suffixWidget != null
                  ? Row(
                      children: [
                        SpaceWidth(width: regularSapce),
                        suffixWidget!
                      ],
                    )
                  : const EmptyArea(),
            ],
          ),
        ),
        SpaceHeight(height: smallSpace)
      ],
    );
  }
}
