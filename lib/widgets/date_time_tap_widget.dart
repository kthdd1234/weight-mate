import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/function.dart';

class TimeChipWidget extends StatelessWidget {
  TimeChipWidget(
      {super.key,
      required this.id,
      required this.onTap,
      required this.time,
      required this.backgroundColor});

  String id;
  DateTime time;
  Function(String id) onTap;
  Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Column(
          children: [
            SpaceHeight(height: smallSpace),
            InkWell(
              onTap: () => onTap(id),
              child: Container(
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    timeToString(time),
                    style: TextStyle(
                      color: buttonBackgroundColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
