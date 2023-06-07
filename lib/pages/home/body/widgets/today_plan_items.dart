import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/area/empty_area.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/pages/home/body/widgets/plan_item_info.dart';
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
              startDateTime: item.startDateTime,
              endDateTime: item.endDateTime,
              isAlarm: item.isAlarm,
              alarmTime: item.alarmTime,
            ),
          );

      Navigator.pushNamed(
        context,
        '/add-plan-setting',
        arguments: argmentsTypeEnum.edit,
      );
    }

    setPlanListView() {
      // return EmptyArea();
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
                  startDateTime: item.startDateTime,
                  endDateTime: item.endDateTime,
                  onTap: (_) => onTap(item),
                  isAlarm: item.isAlarm,
                  alarmTime: item.alarmTime,
                ),
                SpaceHeight(height: smallSpace)
              ],
            );
          });
    }

    return setPlanListView();
  }
}
