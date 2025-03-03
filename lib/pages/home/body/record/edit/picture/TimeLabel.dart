import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/common/CommonText.dart';
import 'package:flutter_app_weight_management/components/area/empty_area.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/function.dart';

class TimeLabel extends StatelessWidget {
  TimeLabel({super.key, this.time, this.size});

  DateTime? time;
  double? size;

  @override
  Widget build(BuildContext context) {
    String locale = context.locale.toString();

    return time != null
        ? Positioned(
            left: 0,
            bottom: 0,
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: textColor.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: CommonText(
                  text: hm(locale: locale, dateTime: time!),
                  size: size ?? 12,
                  color: Colors.white,
                  isBold: true,
                  isNotTr: true,
                ),
              ),
            ),
          )
        : const EmptyArea();
  }
}
