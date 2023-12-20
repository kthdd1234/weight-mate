import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/area/empty_area.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/widget(etc)/widgets/plan_item_info.dart';
import 'package:flutter_app_weight_management/provider/diet_Info_provider.dart';
import 'package:flutter_app_weight_management/utils/class.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';
import 'package:flutter_app_weight_management/utils/variable.dart';
import 'package:provider/provider.dart';

class TodayPlanItems extends StatelessWidget {
  TodayPlanItems({
    super.key,
    required this.planInfoList,
  });

  List<PlanInfoClass> planInfoList;

  @override
  Widget build(BuildContext context) {
    onTap(PlanInfoClass item) {
      context.read<DietInfoProvider>().changePlanInfo(
            PlanInfoClass(
                type: item.type,
                title: item.title,
                id: item.id,
                name: item.name,
                priority: item.priority,
                isAlarm: item.isAlarm,
                alarmTime: item.alarmTime,
                alarmId: item.alarmId,
                createDateTime: item.createDateTime),
          );

      Navigator.pushNamed(
        context,
        '/add-plan-setting',
        arguments: ArgmentsTypeEnum.edit,
      );
    }

    setPlanListView() {
      return ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: planInfoList.length,
          itemBuilder: (context, index) {
            final item = planInfoList[index];

            return Column(
              children: [
                PlanItemInfo(
                  id: item.id,
                  title: item.title,
                  icon: planTypeDetailInfo[item.type]!.icon,
                  name: item.name,
                  onTap: (_) => onTap(item),
                  isAlarm: item.isAlarm,
                  alarmTime: item.alarmTime,
                ),
                SpaceHeight(height: tinySpace)
              ],
            );
          });
    }

    return setPlanListView();
  }
}
