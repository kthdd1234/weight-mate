import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/icon/circular_icon.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/components/text/body_small_text.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class PlanGroupItem extends StatelessWidget {
  PlanGroupItem({
    super.key,
    required this.icon,
    required this.title,
    required this.length,
    required this.percent,
  });

  IconData icon;
  String title;
  int length;
  double percent;

  @override
  Widget build(BuildContext context) {
    return ContentsBox(
      backgroundColor: Colors.white,
      contentsWidget: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircularIcon(
                size: 45,
                borderRadius: 10,
                icon: icon,
                backgroundColor: typeBackgroundColor,
              ),
              SpaceWidth(width: regularSapce),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 15),
                  ),
                  SpaceHeight(height: tinySpace),
                  BodySmallText(text: '총 $length개의 계획')
                ],
              )
            ],
          ),
          CircularPercentIndicator(
            radius: 30.0,
            lineWidth: 5.0,
            animation: true,
            percent: percent * 0.01,
            center: Text(
              '$percent%',
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 10.0,
                  color: Color(0xff6237E2)),
            ),
            circularStrokeCap: CircularStrokeCap.round,
            backgroundColor: enableBackgroundColor,
            progressColor: enableTextColor,
          )
        ],
      ),
    );
  }
}
