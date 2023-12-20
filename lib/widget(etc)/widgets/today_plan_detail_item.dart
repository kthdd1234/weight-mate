import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/area/empty_text_area.dart';
import 'package:flutter_app_weight_management/components/area/empty_text_vertical_area.dart';
import 'package:flutter_app_weight_management/components/button/expanded_button_hori.dart';
import 'package:flutter_app_weight_management/components/check/delete_diet_plan_check.dart';
import 'package:flutter_app_weight_management/components/check/plan_contents.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/icon/text_icon.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/components/text/contents_title_text.dart';
import 'package:flutter_app_weight_management/model/plan_box/plan_box.dart';
import 'package:flutter_app_weight_management/services/notifi_service.dart';
import 'package:flutter_app_weight_management/utils/class.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:flutter_app_weight_management/utils/variable.dart';
import 'package:hive/hive.dart';

class TodayPlanDetailItem extends StatefulWidget {
  TodayPlanDetailItem({
    super.key,
    required this.planBox,
    required this.planType,
    required this.title,
    required this.emptyString,
    required this.addString,
    required this.contentsList,
    required this.actionPercent,
    required this.onTapAddItem,
  });

  Box<PlanBox> planBox;
  PlanTypeEnum planType;
  String title, emptyString, addString, actionPercent;
  List<PlanContents> contentsList;
  Function(PlanTypeEnum planType) onTapAddItem;

  @override
  State<TodayPlanDetailItem> createState() => _TodayPlanDetailItemState();
}

class _TodayPlanDetailItemState extends State<TodayPlanDetailItem> {
  bool isRemove = false;

  @override
  Widget build(BuildContext context) {
    PlanTypeDetailClass planInfo = planTypeDetailInfo[widget.planType]!;

    onTapRemoveState(bool state) {
      if (widget.contentsList.isEmpty) {
        showSnackBar(
          context: context,
          text: '삭제할 ${widget.title}이 없어요.',
          buttonName: '확인',
          onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
        );
      } else {
        setState(() => isRemove = state);
      }
    }

    onTapRemoveButton({required String id}) {
      PlanContents contents =
          widget.contentsList.firstWhere((element) => element.id == id);

      if (widget.contentsList.length == 1) {
        setState(() => isRemove = false);
      }

      widget.planBox.delete(contents.id);
      if (contents.alarmId != null) {
        NotificationService().deleteAlarm(contents.alarmId!);
      }
    }

    onInitRemoveList() {
      return widget.contentsList
          .map(
            (contents) => DeleteDietPlanCheck(
              id: contents.id,
              text: contents.text,
              onTap: onTapRemoveButton,
            ),
          )
          .toList();
    }

    return Column(
      children: [
        SpaceHeight(height: smallSpace),
        ContentsBox(
          contentsWidget: Column(
            children: [
              ContentsTitleText(
                text: widget.title,
                sub: [
                  TextIcon(
                    iconSize: 12,
                    iconColor: planInfo.mainColor,
                    backgroundColor: planInfo.shadeColor,
                    text: '실천율: ${widget.actionPercent}%',
                    borderRadius: 5,
                    textColor: planInfo.mainColor,
                    fontSize: 10,
                    padding: 7,
                    onTap: () => null,
                  ),
                  SpaceWidth(width: tinySpace),
                  TextIcon(
                    iconSize: 12,
                    iconColor: Colors.pink.shade400,
                    backgroundColor: Colors.pink.shade50,
                    text: '삭제',
                    borderRadius: 5,
                    textColor: Colors.pink.shade400,
                    fontSize: 10,
                    padding: 7,
                    onTap: () => onTapRemoveState(true),
                  )
                ],
              ),
              SpaceHeight(height: smallSpace),
              widget.contentsList.isNotEmpty
                  ? Column(
                      children:
                          isRemove ? onInitRemoveList() : widget.contentsList)
                  : EmptyTextVerticalArea(
                      height: 130,
                      backgroundColor: Colors.transparent,
                      icon: planInfo.icon,
                      title: '${widget.emptyString}\n${planInfo.counterText}',
                    ),
              widget.contentsList.isNotEmpty && isRemove
                  ? Row(
                      children: [
                        ExpandedButtonHori(
                          padding: 9,
                          imgUrl: 'assets/images/t-9.png',
                          text: '취소',
                          onTap: () => onTapRemoveState(false),
                        ),
                      ],
                    )
                  : EmptyTextArea(
                      text: widget.addString,
                      icon: Icons.add,
                      topHeight: smallSpace,
                      downHeight: smallSpace,
                      onTap: () => widget.onTapAddItem(widget.planType),
                    ),
            ],
          ),
        ),
      ],
    );
  }
}
