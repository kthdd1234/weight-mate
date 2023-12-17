import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/area/empty_text_area.dart';
import 'package:flutter_app_weight_management/components/area/empty_text_vertical_area.dart';
import 'package:flutter_app_weight_management/components/check/plan_contents.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/icon/text_icon.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/text/contents_title_text.dart';
import 'package:flutter_app_weight_management/utils/class.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';
import 'package:flutter_app_weight_management/utils/variable.dart';

class TodayPlanDetailItem extends StatelessWidget {
  TodayPlanDetailItem({
    super.key,
    required this.planType,
    required this.title,
    required this.emptyString,
    required this.addString,
    required this.contentsList,
    required this.onTap,
    required this.actionPercent,
  });

  PlanTypeEnum planType;
  String title, emptyString, addString, actionPercent;
  List<PlanContents> contentsList;
  Function() onTap;

  @override
  Widget build(BuildContext context) {
    PlanTypeDetailClass planInfo = planTypeDetailInfo[planType]!;

    return Column(
      children: [
        SpaceHeight(height: smallSpace),
        ContentsBox(
          contentsWidget: Column(
            children: [
              ContentsTitleText(
                text: title,
                sub: [
                  TextIcon(
                    iconSize: 12,
                    iconColor: planInfo.mainColor,
                    backgroundColor: planInfo.shadeColor,
                    text: '실천율: $actionPercent%',
                    borderRadius: 5,
                    textColor: planInfo.mainColor,
                    fontSize: 10,
                    padding: 7,
                  )
                ],
              ),
              SpaceHeight(height: smallSpace),
              Column(
                  children: contentsList.isNotEmpty
                      ? contentsList
                      : [
                          EmptyTextVerticalArea(
                            height: 130,
                            backgroundColor: Colors.transparent,
                            icon: planInfo.icon,
                            title: '$emptyString\n${planInfo.counterText}',
                          ),
                        ]),
              EmptyTextArea(
                text: addString,
                icon: Icons.add,
                topHeight: smallSpace,
                downHeight: smallSpace,
                onTap: onTap,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
