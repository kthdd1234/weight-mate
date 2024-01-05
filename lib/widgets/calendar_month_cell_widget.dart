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
    required this.recordObject,
    required this.isSelectedDay,
    required this.currentView,
  });

  DateTime detailDateTime;
  Set<String> recordObject;
  bool isSelectedDay;
  String currentView;

  @override
  Widget build(BuildContext context) {
    final isMaxDateResult = isMaxDate(
      targetDateTime: DateTime.now(),
      detailDateTime: detailDateTime,
    );

    setCellTextColor() {
      if (isMaxDateResult) return Colors.grey;
      return isSelectedDay ? Colors.white : Colors.black;
    }

    setCellText() {
      if (currentView != 'month') return '';
      return detailDateTime.day.toString();
    }

    colorWidget(String type) {
      final dotColors = {
        'weight': weightColor,
        'action': actionColor,
        'memo': diaryColor,
      };

      return Column(
        children: [
          Dot(size: 7, color: dotColors[type]!),
          SpaceWidth(width: 10)
        ],
      );
    }

    setRecordDots(Set<String> object) {
      final children = object.map((element) => colorWidget(element)).toList();

      if (isMaxDateResult || currentView != 'month' || children.isEmpty) {
        return const EmptyArea();
      }

      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: children,
      );
    }

    return Column(
      children: [
        SpaceHeight(height: smallSpace),
        Container(
          width: 33,
          height: 33,
          decoration: BoxDecoration(
            color: isSelectedDay ? themeColor : null,
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
        setRecordDots(recordObject),
      ],
    );
  }
}
