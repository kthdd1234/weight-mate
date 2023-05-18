import 'package:flutter_app_weight_management/components/check/action_diet_plan_check.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/divider/width_divider.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/provider/diet_Info_provider.dart';
import 'package:flutter_app_weight_management/provider/record_sub_type_provider.dart';
import 'package:flutter_app_weight_management/utils/class.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';
import 'package:flutter_app_weight_management/widgets/today_diet_plan_item_widget.dart';
import 'package:flutter_app_weight_management/widgets/touch_and_check_input_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class TodayDietPlanListWidget extends StatefulWidget {
  TodayDietPlanListWidget({
    super.key,
    required this.dietPlanList,
  });

  List<DietPlanClass> dietPlanList;

  @override
  State<TodayDietPlanListWidget> createState() =>
      _TodayDietPlanListWidgetState();
}

class _TodayDietPlanListWidgetState extends State<TodayDietPlanListWidget> {
  bool showEmptyTouchArea = true;

  @override
  Widget build(BuildContext context) {
    RecordSubTypes seletedRecordSubType =
        context.watch<RecordSubTypeProvider>().seletedRecordSubType;

    if (seletedRecordSubType == RecordSubTypes.addDietPlan) {
      setState(() => showEmptyTouchArea = false);
    }

    onTapEmptyArea() {
      setState(() => showEmptyTouchArea = false);
    }

    onPressedOk({text, iconData}) {
      setState(() {
        final newDietPlan = DietPlanClass(
          id: const Uuid().v4(),
          icon: iconData,
          plan: text,
          isChecked: true,
          isAction: true,
        );
        showEmptyTouchArea = true;
        widget.dietPlanList.add(newDietPlan);
        context
            .read<DietInfoProvider>()
            .changeDietPlanList(widget.dietPlanList);
        context
            .read<RecordSubTypeProvider>()
            .setSeletedRecordSubType(RecordSubTypes.none);
      });
    }

    onPressedCancel() {
      setState(() {
        showEmptyTouchArea = true;
        context
            .read<RecordSubTypeProvider>()
            .setSeletedRecordSubType(RecordSubTypes.none);
      });
    }

    onTapTodayDietPlanList() {
      context
          .read<RecordSubTypeProvider>()
          .setSeletedRecordSubType(RecordSubTypes.actDietPlan);
    }

    List<TodayDietPlanItemWidget> todayDietPlanList = widget.dietPlanList
        .map((DietPlanClass dietPlan) => TodayDietPlanItemWidget(
              icon: dietPlan.icon,
              text: dietPlan.plan,
              isAction: dietPlan.isAction,
            ))
        .toList();

    return Column(
      children: [
        InkWell(
          onTap: onTapTodayDietPlanList,
          child: ContentsBox(
            backgroundColor: dialogBackgroundColor,
            contentsWidget: Column(children: [...todayDietPlanList]),
          ),
        ),
        SpaceHeight(height: smallSpace),
        TouchAndCheckInputWidget(
          checkBoxEnabledIcon: Icons.check_box,
          checkBoxDisEnabledIcon: Icons.check_box,
          showEmptyTouchArea: showEmptyTouchArea,
          onTapEmptyArea: onTapEmptyArea,
          onPressedOk: onPressedOk,
          onPressedCancel: onPressedCancel,
        )
      ],
    );
  }
}
