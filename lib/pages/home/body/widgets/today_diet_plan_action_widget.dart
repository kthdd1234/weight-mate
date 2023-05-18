import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/button/ok_and_cancel_button.dart';
import 'package:flutter_app_weight_management/components/check/action_diet_plan_check.dart';
import 'package:flutter_app_weight_management/components/divider/width_divider.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/provider/diet_Info_provider.dart';
import 'package:flutter_app_weight_management/provider/record_sub_type_provider.dart';
import 'package:flutter_app_weight_management/utils/class.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';
import 'package:provider/provider.dart';

class TodayDietPlanActionWidget extends StatefulWidget {
  TodayDietPlanActionWidget({super.key, required this.dietPlanList});

  List<DietPlanClass> dietPlanList;

  @override
  State<TodayDietPlanActionWidget> createState() =>
      _TodayDietPlanActionWidgetState();
}

class _TodayDietPlanActionWidgetState extends State<TodayDietPlanActionWidget> {
  List<String> actionIds = [];

  @override
  void initState() {
    for (var dietPlan in widget.dietPlanList) {
      if (dietPlan.isAction) {
        actionIds.add(dietPlan.id);
      }
    }
    super.initState();
  }

  @override
  void dispose() {
    actionIds = [];
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    onTapAction({id, isSelected}) {
      setState(() {
        isSelected ? actionIds.add(id) : actionIds.remove(id);
      });
    }

    setOkText() {
      return actionIds.isNotEmpty ? '(${actionIds.length})' : '';
    }

    onPressedOk() {
      var actionList = widget.dietPlanList.map((dietPlan) {
        if (actionIds.contains(dietPlan.id)) {
          dietPlan.isAction = true;
          return dietPlan;
        }

        dietPlan.isAction = false;
        return dietPlan;
      }).toList();

      context.read<DietInfoProvider>().changeDietPlanList(actionList);
      context
          .read<RecordSubTypeProvider>()
          .setSeletedRecordSubType(RecordSubTypes.none);
    }

    onPressedCancel() {
      context
          .read<RecordSubTypeProvider>()
          .setSeletedRecordSubType(RecordSubTypes.none);
    }

    List<ActionDietPlanCheck> todayDietPlanList = widget.dietPlanList
        .map((DietPlanClass dietPlan) => ActionDietPlanCheck(
              id: dietPlan.id,
              text: dietPlan.plan,
              isAction: dietPlan.isAction,
              onTap: onTapAction,
            ))
        .toList();

    return Column(
      children: [
        ...todayDietPlanList,
        WidthDivider(width: double.infinity),
        SpaceHeight(height: smallSpace),
        OkAndCancelButton(
          okText: '완료 ${setOkText()}',
          cancelText: '취소',
          onPressedOk: actionIds.isNotEmpty ? onPressedOk : null,
          onPressedCancel: onPressedCancel,
        )
      ],
    );
  }
}
