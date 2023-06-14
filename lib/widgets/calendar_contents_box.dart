import 'package:flutter/cupertino.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/divider/height_divider.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';

class CalendarContentsBox extends StatelessWidget {
  CalendarContentsBox({
    super.key,
    required this.color,
    required this.rowWidgetList,
  });

  Color color;
  List<Widget> rowWidgetList;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ContentsBox(
          padding: const EdgeInsets.only(
            top: 20,
            right: 20,
            bottom: 20,
            left: 0,
          ),
          contentsWidget: Row(
            children: [
              HeightDivider(
                width: 3,
                height: 45,
                color: color,
                borderRadius: BorderRadius.circular(20),
              ),
              SpaceWidth(width: regularSapce),
              Expanded(child: Column(children: rowWidgetList))
            ],
          ),
        ),
        SpaceHeight(height: smallSpace)
      ],
    );
  }
}
