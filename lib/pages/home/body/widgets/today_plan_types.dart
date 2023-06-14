import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/pages/home/body/widgets/plan_group_item.dart';
import 'package:flutter_app_weight_management/utils/class.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:flutter_app_weight_management/utils/variable.dart';

class GroupItemClass {
  GroupItemClass({
    required this.type,
    required this.icon,
    required this.title,
    required this.planLength,
    required this.actionLength,
    required this.percent,
  });

  PlanTypeEnum type;
  IconData icon;
  String title;
  int planLength;
  int actionLength;
  double percent;
}

class TodayPlanTypes extends StatelessWidget {
  TodayPlanTypes({
    super.key,
    required this.actions,
    required this.planInfoList,
  });

  List<String>? actions;
  List<PlanInfoClass> planInfoList;

  @override
  Widget build(BuildContext context) {
    setTypeItems() {
      Map<PlanTypeEnum, GroupItemClass> map = {};

      for (var info in planInfoList) {
        if (map.containsKey(info.type) == false) {
          // ??
          map[info.type] = GroupItemClass(
            type: info.type,
            icon: planTypeDetailInfo[info.type]!.icon,
            title: info.title,
            planLength: 1,
            actionLength: 0,
            percent: 0.0,
          );
        } else {
          map[info.type]!.planLength += 1;
        }

        if (actions != null && actions!.contains(info.id)) {
          map[info.type]!.actionLength += 1;
        }
      }

      List<GroupItemClass> groupItemList = map.values.toList();

      return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: groupItemList.length,
        itemBuilder: (context, index) {
          final groupItem = groupItemList[index];

          return Column(
            children: [
              PlanGroupItem(
                icon: groupItem.icon,
                title: groupItem.title,
                length: groupItem.planLength,
                percent: planToActionPercent(
                  a: groupItem.actionLength,
                  b: groupItem.planLength,
                ),
              ),
              SpaceHeight(height: smallSpace)
            ],
          );
        },
      );
    }

    return setTypeItems();
  }
}
