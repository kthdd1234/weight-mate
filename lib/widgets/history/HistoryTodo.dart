import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/common/CommonIcon.dart';
import 'package:flutter_app_weight_management/widgets/area/empty_area.dart';
import 'package:flutter_app_weight_management/widgets/history/HistoryRemove.dart';
import 'package:flutter_app_weight_management/widgets/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/model/record_box/record_box.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:flutter_app_weight_management/utils/variable.dart';

class HistoryTodo extends StatelessWidget {
  HistoryTodo({
    super.key,
    required this.isRemoveMode,
    required this.recordInfo,
    required this.isDietRecord,
    required this.isExerciseRecord,
    required this.isDietGoal,
    required this.isExerciseGoal,
    required this.isLife,
  });

  RecordBox recordInfo;
  bool isRemoveMode,
      isDietRecord,
      isExerciseRecord,
      isDietGoal,
      isExerciseGoal,
      isLife;

  @override
  Widget build(BuildContext context) {
    List<String>? dietRecordOrderList = recordInfo.dietRecordOrderList;
    List<String>? exerciseRecordOrderList = recordInfo.exerciseRecordOrderList;

    onIcon(String type, bool? isRecord, String title) {
      MaterialColor color = categoryColors[type]!;

      return CommonIcon(
        icon: isRecord == true ? categoryIcons[title]! : Icons.check_rounded,
        size: 11,
        color: color.shade300,
        bgColor: color.shade50,
      );
    }

    onTapRemoveAction(Map<String, dynamic> selectedAction) async {
      String actionId = selectedAction['id'];
      bool isRecord = selectedAction['isRecord'] == true;
      int? index = recordInfo.actions?.indexWhere(
        (action) => action['id'] == actionId,
      );

      if (index != null) {
        recordInfo.actions?.removeAt(index);
      }

      if (selectedAction['type'] == eDiet && isRecord) {
        dietRecordOrderList?.remove(actionId);
      } else if (selectedAction['type'] == eExercise && isRecord) {
        exerciseRecordOrderList?.remove(actionId);
      }

      await recordInfo.save();
    }

    Iterable<Map<String, dynamic>>? todoDisplayList =
        recordInfo.actions?.where((action) {
      String planType = action['type'];

      bool isTypeDietRecord = planType == eDiet && action['isRecord'] == true;
      bool isTypeExerciseRecord =
          planType == eExercise && action['isRecord'] == true;
      bool isTypeDietGoal = planType == eDiet && action['isRecord'] == null;
      bool isTypeExerciseGoal =
          planType == eExercise && action['isRecord'] == null;
      bool isTypeLife = planType == eLife;

      if (isTypeDietRecord && isDietRecord) {
        return true;
      } else if (isTypeExerciseRecord && isExerciseRecord) {
        return true;
      } else if (isTypeDietGoal && isDietGoal) {
        return true;
      } else if (isTypeExerciseGoal && isExerciseGoal) {
        return true;
      } else if (isTypeLife && isLife) {
        return true;
      }

      return false;
    });

    // 1
    List<Map<String, dynamic>>? todoResultList = todoDisplayList
        ?.where(
          (action) =>
              getDateTimeToInt(action['actionDateTime']) ==
              getDateTimeToInt(recordInfo.createDateTime),
        )
        .toList();

    // 2
    List<Map<String, dynamic>> tempDietRecordOrderList = [];
    List<Map<String, dynamic>> tempExerciseRecordOrderList = [];

    todoResultList = todoResultList?.where((action) {
      bool isTypeDietRecord =
          action['type'] == eDiet && action['isRecord'] == true;
      bool isTypeExerciseRecord =
          action['type'] == eExercise && action['isRecord'] == true;

      if (isTypeDietRecord) {
        tempDietRecordOrderList.add(action);
        return false;
      } else if (isTypeExerciseRecord) {
        tempExerciseRecordOrderList.add(action);
        return false;
      }

      return true;
    }).toList();

    tempDietRecordOrderList = onOrderList(
          actions: tempDietRecordOrderList,
          type: eDiet,
          dietRecordOrderList: dietRecordOrderList,
        ) ??
        [];
    tempExerciseRecordOrderList = onOrderList(
          actions: tempExerciseRecordOrderList,
          type: eExercise,
          exerciseRecordOrderList: exerciseRecordOrderList,
        ) ??
        [];

    List<Map<String, dynamic>> combineRecordOrderList = [
      ...tempDietRecordOrderList,
      ...tempExerciseRecordOrderList
    ];
    todoResultList = [...combineRecordOrderList, ...todoResultList ?? []];

    // 3
    todoResultList.sort((A, B) {
      int order1 = planOrder[A['type']]!;
      int order2 = planOrder[B['type']]!;

      return order1.compareTo(order2);
    });

    return todoResultList.isNotEmpty
        ? Column(
            children: todoResultList
                .map(
                  (todo) => Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Row(
                      children: [
                        isRemoveMode
                            ? Expanded(
                                flex: 0,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(top: 2, right: 7),
                                  child: HistoryRemove(
                                      onTap: () => onTapRemoveAction(todo)),
                                ),
                              )
                            : const EmptyArea(),
                        Expanded(
                          flex: 0,
                          child: onIcon(
                              todo['type'], todo['isRecord'], todo['title']),
                        ),
                        SpaceWidth(width: smallSpace),
                        Expanded(
                          flex: 1,
                          child: Text(
                            todo['name'],
                            style:
                                const TextStyle(fontSize: 14, color: textColor),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          )
        : const EmptyArea();
  }
}
