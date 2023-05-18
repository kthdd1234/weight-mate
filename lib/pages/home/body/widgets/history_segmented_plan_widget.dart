import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/pages/home/body/widgets/history_segmented_empty_widget.dart';
import 'package:flutter_app_weight_management/pages/home/body/widgets/history_segmented_item_widget.dart';
import 'package:flutter_app_weight_management/provider/diet_Info_provider.dart';
import 'package:flutter_app_weight_management/utils/class.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';
import 'package:flutter_app_weight_management/widgets/history_edit_button_widget.dart';
import 'package:flutter_app_weight_management/widgets/history_sub_text_widget.dart';
import 'package:provider/provider.dart';

class HistorySegmentedPlanWidget extends StatelessWidget {
  const HistorySegmentedPlanWidget({super.key});

  @override
  Widget build(BuildContext context) {
    List<DietPlanClass> dietPlanList =
        context.watch<DietInfoProvider>().getDietPlanList();

    onTapSuffixWidget(String id) {
//
    }

    final dietActionList =
        dietPlanList.where((dietPlan) => dietPlan.isAction).toList();
    final dietActionWidgetList = dietActionList
        .map((dietAction) => HistorySegmentedItemWidget(
            icon: dietAction.icon,
            name: dietAction.plan,
            subWidget: HistorySubTextWidget(
              text: '2회째 실천 중!',
              color: disEnabledTypeColor,
            ),
            suffixWidget: HistoryEditButtonWidget(
              id: 'plan',
              onTap: onTapSuffixWidget,
            )))
        .toList();

    setWidget() {
      if (dietActionWidgetList.isEmpty) {
        return HistorySegmentedEmptyWidget(segmented: SegmentedTypes.actPlan);
      }

      return Column(children: dietActionWidgetList);
    }

    return Container(child: setWidget());
  }
}
