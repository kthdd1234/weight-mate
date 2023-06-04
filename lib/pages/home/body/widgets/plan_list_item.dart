import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/icon/circular_icon.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/components/text/body_small_text.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/widgets/circle_progress.dart';
import 'package:percent_indicator/percent_indicator.dart';

class PlanListItem extends StatelessWidget {
  const PlanListItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ContentsBox(
          backgroundColor: dialogBackgroundColor,
          contentsWidget: Row(
            children: [
              CircleProgress(),
              SpaceWidth(width: regularSapce),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text('간헐적 단식'),
                      SpaceWidth(width: 93),
                      CircularIcon(
                        size: 30,
                        adjustSize: 15,
                        borderRadius: 7,
                        icon: Icons.notifications_active_rounded,
                        backgroundColor: typeBackgroundColor,
                      )
                    ],
                  ),
                  SpaceHeight(height: smallSpace),
                  BodySmallText(text: '실천 기간'),
                  SpaceHeight(height: tinySpace),
                  Text(
                    '23.04.13 ~ 23.06.31',
                    style: TextStyle(fontSize: 12),
                  ),
                  SpaceHeight(height: smallSpace),
                  // LinearPercentIndicator(
                  //   animateFromLastPercent: true,
                  //   animation: true,
                  //   padding: EdgeInsets.symmetric(horizontal: 0),
                  //   barRadius: Radius.circular(30),
                  //   width: MediaQuery.of(context).size.width - 240,
                  //   percent: 0.9,
                  //   progressColor: Colors.redAccent,
                  // )
                ],
              )
            ],
          ),
        ),
        SpaceHeight(height: smallSpace),
      ],
    );
  }
}
