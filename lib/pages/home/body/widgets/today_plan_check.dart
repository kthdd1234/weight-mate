import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/pages/home/body/widgets/plan_check_item.dart';

class TodayPlanCheck extends StatelessWidget {
  const TodayPlanCheck({super.key});

  @override
  Widget build(BuildContext context) {
    onTapCheckItem(String id) {}

    return Column(
      children: [
        PlanCheckItem(
          id: 'item-1',
          icon: Icons.alarm,
          groupName: '생활습관',
          itemName: '아침에 체중 기록하기',
          isChecked: true,
          onTap: onTapCheckItem,
        ),
      ],
    );
  }
}
