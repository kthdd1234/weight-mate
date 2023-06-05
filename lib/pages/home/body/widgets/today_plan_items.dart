import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/pages/home/body/widgets/plan_item_info.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';

class TodayPlanItems extends StatelessWidget {
  const TodayPlanItems({super.key});

  @override
  Widget build(BuildContext context) {
    onTapPlanItem(String id) {
      Navigator.pushNamed(
        context,
        '/add-act-setting',
        arguments: argmentsTypeEnum.edit,
      );
      // context.read<DietInfoProvider>().changeActInfo(
      //       ActInfoClass(
      //         mainActType: ,
      //         mainActTitle: ,
      //         subActType: ,
      //         subActTitle: ,
      //         startActDateTime: ,
      //         isAlarm: ,
      //       ),
      //     );
    }

    return Column(
      children: [
        PlanItemInfo(
          id: 'plan-1',
          groupName: '식이요법',
          icon: Icons.self_improvement,
          itemName: '간헐적 단식 16:8',
          startDateTime: DateTime.now(),
          endDateTime: DateTime.now(),
          isAct: false,
          onTap: onTapPlanItem,
        ),
      ],
    );
  }
}
