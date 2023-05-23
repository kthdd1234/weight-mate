import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/area/empty_area.dart';
import 'package:flutter_app_weight_management/components/dot/color_dot.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/function.dart';

class CalendarMonthCellWidget extends StatelessWidget {
  CalendarMonthCellWidget({
    super.key,
    required this.detailDateTime,
    required this.isSelectedDay,
    required this.currentView,
  });

  DateTime detailDateTime;
  bool isSelectedDay;
  String currentView;

  @override
  Widget build(BuildContext context) {
    final isMaxDateResult = isMaxDate(
      targetDateTime: DateTime.now(),
      detailDateTime: detailDateTime,
    );

    setCellTextColor() {
      if (isMaxDateResult) {
        return Colors.grey[300];
      }

      return isSelectedDay ? Colors.white : Colors.black;
    }

    setCellText() {
      if (currentView != 'month') {
        return '';
      }

      return detailDateTime.day.toString();
    }

    colorWidget(String type) {
      final colorData = {
        'weight': weightDotColor,
        'plan': planDotColor,
        'memo': memoDotColor
      };

      return Column(
        children: [
          ColorDot(width: 7, height: 7, color: colorData[type]!),
          SpaceWidth(width: 2)
        ],
      );
    }

    setRecordDots(Set<String> object) {
      if (isMaxDateResult || currentView != 'month') {
        return const EmptyArea();
      }

      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [], //
      );
    }

    return Column(
      children: [
        SpaceHeight(height: smallSpace),
        Container(
          width: 33,
          height: 33,
          decoration: BoxDecoration(
            color: isSelectedDay ? buttonBackgroundColor : null,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              setCellText(),
              style: TextStyle(fontFamily: '', color: setCellTextColor()),
            ),
          ),
        ),
        SpaceHeight(height: 3),
        setRecordDots({}),
      ],
    );
  }
}
