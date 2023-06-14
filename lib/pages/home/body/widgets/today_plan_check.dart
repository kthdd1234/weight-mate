import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/model/record_box/record_box.dart';
import 'package:flutter_app_weight_management/pages/home/body/widgets/plan_check_item.dart';
import 'package:flutter_app_weight_management/utils/class.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:flutter_app_weight_management/utils/variable.dart';
import 'package:hive_flutter/hive_flutter.dart';

class TodayPlanCheck extends StatelessWidget {
  TodayPlanCheck({
    super.key,
    required this.recordBox,
    required this.recordInfo,
    required this.planInfoList,
    required this.importDateTime,
  });

  Box<RecordBox> recordBox;
  RecordBox? recordInfo;
  List<PlanInfoClass> planInfoList;
  DateTime importDateTime;

  @override
  Widget build(BuildContext context) {
    onTap({required String id, required bool checked}) {
      if (checked) {
        if (recordInfo == null) {
          recordBox.put(
            getDateTimeToInt(importDateTime),
            RecordBox(createDateTime: importDateTime, actions: [id]),
          );
        } else {
          recordInfo!.actions == null
              ? recordInfo!.actions = [id]
              : recordInfo!.actions!.add(id);

          recordInfo!.save();
        }
      } else {
        recordInfo!.actions!.remove(id);

        if (recordInfo!.actions!.isEmpty) {
          recordInfo!.actions = null;
        }

        recordInfo!.save();
      }
    }

    setListView() {
      return ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: planInfoList.length,
          itemBuilder: (context, index) {
            final item = planInfoList[index];

            setIsChecked() {
              if (recordInfo?.actions == null) return false;
              return recordInfo!.actions!.contains(item.id);
            }

            return Column(
              children: [
                PlanCheckItem(
                  id: item.id,
                  icon: planTypeDetailInfo[item.type]!.icon,
                  groupName: item.title,
                  itemName: item.name,
                  isChecked: setIsChecked(),
                  onTap: onTap,
                ),
                SpaceHeight(height: smallSpace)
              ],
            );
          });
    }

    return setListView();
  }
}
