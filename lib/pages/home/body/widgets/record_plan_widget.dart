import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/icon/default_icon.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/text/contents_title_text.dart';
import 'package:flutter_app_weight_management/pages/home/body/widgets/today_diet_plan_action_widget.dart';
import 'package:flutter_app_weight_management/pages/home/body/widgets/today_diet_plan_delete_widget.dart';
import 'package:flutter_app_weight_management/pages/home/body/widgets/today_diet_plan_list_widget.dart';
import 'package:flutter_app_weight_management/provider/diet_Info_provider.dart';
import 'package:flutter_app_weight_management/provider/record_sub_type_provider.dart';
import 'package:flutter_app_weight_management/utils/class.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';
import 'package:provider/provider.dart';

class RecordPlanWidget extends StatelessWidget {
  RecordPlanWidget({
    super.key,
    required this.seletedRecordSubType,
  });

  RecordSubTypes seletedRecordSubType;

  @override
  Widget build(BuildContext context) {
    var dietPlanList = context.watch<DietInfoProvider>().getDietPlanList();
    var seletedRecordSubType =
        context.watch<RecordSubTypeProvider>().getSeletedRecordSubType();

    List<RecordSubTypeClass> subClassList = [
      RecordSubTypeClass(
        enumId: RecordSubTypes.addDietPlan,
        icon: Icons.add,
      ),
      RecordSubTypeClass(
        enumId: RecordSubTypes.actDietPlan,
        icon: Icons.check,
      ),
      RecordSubTypeClass(
        enumId: RecordSubTypes.removeDietPlan,
        icon: Icons.delete,
      )
    ];

    List<DefaultIcon> subWidgets = subClassList
        .map((element) => DefaultIcon(
              id: element.enumId,
              icon: element.icon,
              onTap: (id) {},
            ))
        .toList();

    Widget setRouteTodayOfDietPlanWidget() {
      if (RecordSubTypes.actDietPlan == seletedRecordSubType) {
        return TodayDietPlanActionWidget(dietPlanList: dietPlanList);
      } else if (RecordSubTypes.removeDietPlan == seletedRecordSubType) {
        return TodayDietPlanDeleteWdiget(dietPlanList: dietPlanList);
      }

      return TodayDietPlanListWidget(dietPlanList: dietPlanList);
    }

    return ContentsBox(
      contentsWidget: Column(
        children: [
          ContentsTitleText(
            text: '오늘의 실천',
            icon: Icons.task_alt_rounded,
            sub: subWidgets,
          ),
          SpaceHeight(height: regularSapce),
          setRouteTodayOfDietPlanWidget()
        ],
      ),
    );
  }
}
