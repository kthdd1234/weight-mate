import 'package:flutter/material.dart';

class HistorySegmentedPlanWidget extends StatelessWidget {
  const HistorySegmentedPlanWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // List<DietPlanClass> dietPlanList =
    //     context.watch<DietInfoProvider>().getDietPlanList();

    // onTapSuffixWidget(String id) {
    //
    //    }

    // final dietActionList =
    //     dietPlanList.where((dietPlan) => dietPlan.isAction).toList();
    // final dietActionWidgetList = dietActionList
    //     .map((dietAction) => HistorySegmentedItemWidget(
    //         icon: dietAction.icon,
    //         name: dietAction.plan,
    //         subWidget: HistorySubTextWidget(
    //           text: '2회째 실천 중!',
    //           color: disEnabledTypeColor,
    //         ),
    //         suffixWidget: HistoryEditButtonWidget(
    //           id: 'plan',
    //           onTap: onTapSuffixWidget,
    //         )))
    //     .toList();

    setWidget() {
      // if (dietActionWidgetList.isEmpty) {
      //   return HistorySegmentedEmptyWidget(segmented: SegmentedTypes.actPlan);
      // }

      // return Column(children: dietActionWidgetList);
    }

    return Container(child: setWidget());
  }
}
