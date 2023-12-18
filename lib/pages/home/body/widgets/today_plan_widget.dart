import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_weight_management/components/area/empty_area.dart';
import 'package:flutter_app_weight_management/components/area/empty_text_area.dart';
import 'package:flutter_app_weight_management/components/area/empty_text_vertical_area.dart';
import 'package:flutter_app_weight_management/components/button/expanded_button_verti.dart';
import 'package:flutter_app_weight_management/components/check/plan_contents.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/dialog/confirm_dialog.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/components/text/contents_title_text.dart';
import 'package:flutter_app_weight_management/model/plan_box/plan_box.dart';
import 'package:flutter_app_weight_management/model/record_box/record_box.dart';
import 'package:flutter_app_weight_management/model/user_box/user_box.dart';
import 'package:flutter_app_weight_management/pages/home/body/widgets/record_contents_title_icon.dart';
import 'package:flutter_app_weight_management/pages/home/body/widgets/today_plan_detail_item.dart';
import 'package:flutter_app_weight_management/provider/diet_Info_provider.dart';
import 'package:flutter_app_weight_management/services/notifi_service.dart';
import 'package:flutter_app_weight_management/utils/class.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:flutter_app_weight_management/utils/variable.dart';
import 'package:flutter_app_weight_management/widgets/dafault_bottom_sheet.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

class TodayPlanWidget extends StatefulWidget {
  TodayPlanWidget({
    super.key,
    required this.seletedRecordIconType,
    required this.importDateTime,
  });

  RecordIconTypes seletedRecordIconType;
  DateTime importDateTime;

  @override
  State<TodayPlanWidget> createState() => _TodayPlanWidgetState();
}

class _TodayPlanWidgetState extends State<TodayPlanWidget> {
  late Box<RecordBox> recordBox;
  late Box<PlanBox> planBox;

  SegmentedTypes selectedSegment = SegmentedTypes.planCheck;
  PlanTypeEnum curType = PlanTypeEnum.none;

  @override
  void initState() {
    recordBox = Hive.box<RecordBox>('recordBox');
    planBox = Hive.box<PlanBox>('planBox');

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DietInfoProvider dietInfoProvider = context.read<DietInfoProvider>();
    int currentDateTimeInt = getDateTimeToInt(widget.importDateTime);
    RecordBox? recordInfo = recordBox.get(currentDateTimeInt);
    List<PlanBox> planInfoList = planBox.values.toList();

    onTapRemoveAll(enumId) {
      if (planInfoList.isEmpty) {
        showSnackBar(
          context: context,
          text: '삭제할 계획이 없어요.',
          buttonName: '확인',
        );
      } else {
        showDialog(
          context: context,
          builder: (context) {
            return ConfirmDialog(
              width: 230,
              titleText: '계획 삭제',
              contentIcon: Icons.delete_forever,
              contentText1: '모든 계획을',
              contentText2: '삭제하시겠습니까?',
              onPressedOk: () {
                planInfoList.forEach((element) {
                  if (element.alarmId != null) {
                    NotificationService().deleteAlarm(element.alarmId!);
                  }
                });

                planBox.clear();
              },
            );
          },
        );
      }
    }

    onTapCheck({required String id, required bool isSelected}) async {
      PlanBox? planInfo = planBox.get(id);
      DateTime now = DateTime.now();
      DateTime actionDateTime = DateTime(
        widget.importDateTime.year,
        widget.importDateTime.month,
        widget.importDateTime.day,
        now.hour,
        now.minute,
      );

      if (planInfo == null) return;

      ActionItemClass actionItem = ActionItemClass(
        id: id,
        title: planInfo.title,
        type: planInfo.type,
        name: planInfo.name,
        priority: planInfo.priority,
        actionDateTime: actionDateTime,
        createDateTime: planInfo.createDateTime,
      );

      if (isSelected) {
        HapticFeedback.mediumImpact();

        if (recordInfo == null) {
          recordBox.put(
            currentDateTimeInt,
            RecordBox(
              createDateTime: widget.importDateTime,
              actions: [actionItem.setObject()],
            ),
          );
        } else {
          recordInfo.actions == null
              ? recordInfo.actions = [actionItem.setObject()]
              : recordInfo.actions!.add(actionItem.setObject());

          recordInfo.save();
        }
      } else {
        recordInfo!.actions!.removeWhere((element) => element['id'] == id);

        if (recordInfo.actions!.isEmpty) {
          recordInfo.actions = null;
        }

        recordInfo.save();
      }
    }

    onTapEditPlan(PlanBox planInfo) async {
      dietInfoProvider.changePlanInfo(
        PlanInfoClass(
          type: planType[planInfo.type]!,
          title: planInfo.title,
          id: planInfo.id,
          name: planInfo.name,
          priority: planPrioritys[planInfo.priority]!.id,
          isAlarm: planInfo.isAlarm,
          alarmTime: planInfo.alarmTime,
          alarmId: planInfo.alarmId,
          createDateTime: planInfo.createDateTime,
        ),
      );

      closeDialog(context);

      await Navigator.pushNamed(
        context,
        '/add-plan-setting',
        arguments: ArgmentsTypeEnum.edit,
      );
    }

    onTapRemovePlan(id) {
      PlanBox? planInfo = planBox.get(id);

      planBox.delete(id); // 계획 삭제

      if (planInfo!.alarmId != null) {
        NotificationService()
            .deleteMultipleAlarm([planInfo.alarmId.toString()]);
      }

      closeDialog(context);
    }

    onTapContents(id) {
      PlanBox? planInfo = planBox.get(id);

      if (planInfo == null) return;

      showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) => DefaultBottomSheet(
          title: planInfo.name,
          height: 220,
          contents: Row(
            children: [
              ExpandedButtonVerti(
                mainColor: buttonBackgroundColor,
                icon: Icons.edit_note,
                title: '수정하기',
                onTap: () => onTapEditPlan(planInfo),
              ),
              SpaceWidth(width: tinySpace),
              ExpandedButtonVerti(
                mainColor: Colors.red,
                icon: Icons.delete_forever,
                title: '삭제하기',
                onTap: () => onTapRemovePlan(id),
              ),
            ],
          ),
          isEnabled: null,
          submitText: '',
          onSubmit: () {},
        ),
      );
    }

    onTapAddPlan(PlanTypeEnum planType) async {
      DateTime now = DateTime.now();

      initPlanInfo.id = '';
      initPlanInfo.name = '';
      initPlanInfo.type = planType;
      initPlanInfo.title = planTypeDetailInfo[planType]!.title;
      initPlanInfo.isAlarm = true;
      initPlanInfo.alarmId = null;
      initPlanInfo.alarmTime = DateTime(now.year, now.month, now.day, 10, 30);
      initPlanInfo.createDateTime = now;

      dietInfoProvider.changePlanInfo(initPlanInfo);

      await Navigator.pushNamed(
        context,
        '/add-plan-setting',
        arguments: ArgmentsTypeEnum.add,
      );
    }

    planContainer({
      required PlanTypeEnum planType,
    }) {
      List<PlanContents> planContentsList = [];
      String emptyTitle = PlanTypeEnum.all == planType
          ? '계획'
          : planTypeDetailInfo[planType]!.title;

      for (var i = 0; i < planInfoList.length; i++) {
        PlanBox planInfo = planInfoList[i];

        actionData() {
          if (recordInfo?.actions == null) {
            return null;
          }

          return recordInfo!.actions!.firstWhere(
            (element) => element['id'] == planInfo.id,
            orElse: () => {'id': null, 'actionDateTime': null},
          );
        }

        PlanContents data = PlanContents(
          id: planInfo.id,
          text: planInfo.name,
          type: planInfo.type,
          isShowType: planType == PlanTypeEnum.all,
          priority: planInfo.priority,
          isChecked: actionData()?['id'] != null,
          alarmTime: planInfo.alarmTime,
          checkIcon: Icons.check_box,
          notCheckIcon: Icons.check_box,
          notCheckColor: Colors.grey.shade300,
          recordTime: actionData()?['actionDateTime'],
          onTapCheck: onTapCheck,
          onTapContents: onTapContents,
          onTapMore: onTapContents,
        );

        if (planType == PlanTypeEnum.all) {
          planContentsList.add(data);
        } else if (planType.toString() == planInfo.type) {
          planContentsList.add(data);
        }
      }

      actionPercent() {
        if (recordInfo?.actions == null) {
          return '0.0';
        }

        final actions = recordInfo!.actions!.where((element) {
          bool isPlanType = planType.toString() == element['type'];
          bool isAction =
              currentDateTimeInt == getDateTimeToInt(element['actionDateTime']);
          bool isShowPlan = planBox.get(element['id']) != null;

          return isPlanType && isAction && isShowPlan;
        });

        return planToActionPercent(
          a: actions.length,
          b: planContentsList.length,
        ).toString();
      }

      return TodayPlanDetailItem(
        planType: planType,
        title: planTypeDetailInfo[planType]!.title,
        actionPercent: actionPercent(),
        emptyString: '$emptyTitle이 없어요.',
        addString: '$emptyTitle을 추가해보세요.',
        contentsList: planContentsList,
        onTapAddItem: onTapAddPlan,
        onTapRemoveItem: ,
      );
    }

    return Column(
      children: [
        ContentsTitleText(
          text: '${dateTimeToTitle(widget.importDateTime)} 계획',
        ),
        planContainer(planType: PlanTypeEnum.diet),
        planContainer(planType: PlanTypeEnum.exercise),
        planContainer(planType: PlanTypeEnum.lifestyle),
      ],
    );
  }
}
// RecordIconTypes.removePlan, icon: Icons.delete
// setBodyWidgets() {
//   return planInfoList.isEmpty
//       ? Column(
//           children: [
//             SpaceHeight(height: smallSpace + 5),
//             EmptyTextArea(
//               text: '오늘의 계획을 추가해보세요.',
//               icon: Icons.add,
//               topHeight: 30,
//               downHeight: 30,
//               onTap: navigateToPage,
//             ),
//           ],
//         )
//       : Column(
//           children: [
//             SpaceHeight(height: smallSpace + 5),
//             DefaultSegmented(
//               backgroundColor: Colors.white,
//               thumbColor: dialogBackgroundColor,
//               selectedSegment: selectedSegment,
//               children: segmentedTypes,
//               onSegmentedChanged: onSegmentedChanged,
//             ),
//             SpaceHeight(height: smallSpace),
//             setSegmenteItem(),
//           ],
//         );
// }

// setSegmenteItem() {
//   Map<SegmentedTypes, StatelessWidget> segmentedInfo = {
//     SegmentedTypes.planCheck: TodayPlanCheck(
//       recordBox: recordBox,
//       recordInfo: recordInfo,
//       importDateTime: widget.importDateTime,
//       planInfoList: planInfoList,
//     ),
//     SegmentedTypes.planItems: TodayPlanItems(
//       planInfoList: planInfoList,
//     ),
//     SegmentedTypes.planTypes: TodayPlanTypes(
//       actions: recordInfo?.actions,
//       planInfoList: planInfoList,
//     ),
//   };

//   return segmentedInfo[selectedSegment]!;
// }

// Map<SegmentedTypes, Widget> segmentedTypes = {
//   SegmentedTypes.planCheck: segmentedItem(
//     type: SegmentedTypes.planCheck,
//     text: '실천 체크',
//     icon: Icons.check_outlined,
//   ),
//   SegmentedTypes.planItems: segmentedItem(
//     type: SegmentedTypes.planItems,
//     text: '나의 계획',
//     icon: Icons.abc,
//   ),
//   SegmentedTypes.planTypes: segmentedItem(
//     type: SegmentedTypes.planTypes,
//     text: '그룹 목록',
//     icon: Icons.format_list_bulleted_outlined,
//   ),
// };
// onSegmentedChanged(SegmentedTypes? type) {
//     setState(() => selectedSegment = type!);
//   }
// navigateToPage() {
//   Navigator.pushNamed(
//     context,
//     '/add-plan-type',
//     arguments: ArgmentsTypeEnum.add,
//   );
// }

//     segmentedItem({
//   required SegmentedTypes type,
//   required String text,
//   required IconData icon,
// }) {
//   int count = 0;

//   switch (type) {
//     case SegmentedTypes.planTypes:
//       Set<PlanTypeEnum> set = {};

//       for (var element in planInfoList) {
//         set.add(element.type);
//       }

//       count = set.length;
//       break;

//     case SegmentedTypes.planItems:
//       count = planInfoList.length;
//       break;

//     case SegmentedTypes.planCheck:
//       if (recordInfo?.actions != null) count = recordInfo!.actions!.length;
//       break;
//     default:
//   }

//   return Padding(
//     padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
//     child: Text(
//       '$text $count',
//       style: const TextStyle(fontSize: 12, color: buttonBackgroundColor),
//     ),
//   );
// }
// ContentsTitleText(
//   text: title,
//   sub: [
//     TextIcon(
//       iconSize: 12,
//       iconColor: mainColor,
//       backgroundColor: backgroundColor,
//       text: '실천율: ${setActionPercent()}%',
//       borderRadius: 5,
//       textColor: mainColor,
//       fontSize: 10,
//       padding: 7,
//     ),
//     SpaceWidth(width: tinySpace),
//     InkWell(
//       onTap: onTapBeforePlanList,
//       child: TextIcon(
//         iconSize: 12,
//         iconColor: enableTextColor,
//         backgroundColor: enableBackgroundColor,
//         text: '이전 계획: ${setBeforePlanList()}개',
//         borderRadius: 5,
//         textColor: enableTextColor,
//         fontSize: 10,
//         padding: 7,
//       ),
//     ),
//     //
//   ],
// ),
// SpaceHeight(height: smallSpace),
// getWherePlanList() {
//   return planBox.values
//       .toList()
//       .where(
//         (element) =>
//             element.type == type.toString() &&
//             getDateTimeToInt(element.createDateTime) < currentDateTimeInt,
//       )
//       .toList();
// }



// setBeforePlanList() {
//   return getWherePlanList().length;
// }

// onPressedOk(List<String> idList) {
//   for (var i = 0; i < idList.length; i++) {
//     PlanBox? planInfo = planBox.get(idList[i]);

//     if (planInfo != null) {
//       final uuid = getUUID();

//       planBox.put(
//         uuid,
//         PlanBox(
//           id: uuid,
//           type: planInfo.type,
//           title: planInfo.title,
//           name: planInfo.name,
//           priority: planInfo.priority,
//           isAlarm: planInfo.isAlarm,
//           alarmId: planInfo.alarmId,
//           alarmTime: planInfo.alarmTime,
//           createDateTime: widget.importDateTime,
//         ),
//       );

//       if (planInfo.isAlarm) {
//         NotificationService().addNotification(
//           id: planInfo.alarmId!,
//           dateTime: widget.importDateTime,
//           alarmTime: planInfo.alarmTime!,
//           title: planNotifyTitle(),
//           body: planNotifyBody(title: title, body: planInfo.name),
//           payload: 'plan',
//         );
//       }
//     }
//   }

//   closeDialog(context);
// }

// onTapBeforePlanList() {
//   showDialog(
//     context: context,
//     builder: (context) {
//       return BeforePlanListDialog(
//         title: title,
//         planList: getWherePlanList(),
//         onPressedOk: onPressedOk,
//         emptyIcon: planTypeDetailInfo[type]!.icon,
//       );
//     },
//   );
// }
// onEditingComplete({
//   required String text,
//   required bool isAction,
//   required String title,
//   required PlanTypeEnum type,
// }) {
//   if (text == '') {
//     showSnackBar(
//       context: context,
//       text: '한 글자 이상 입력해주세요.',
//       buttonName: '확인',
//       width: 270,
//     );
//   } else {
//     String planId = getUUID();
//     planBox.put(
//       planId,
//       PlanBox(
//         id: planId,
//         type: type.toString(),
//         title: title,
//         name: text,
//         priority: PlanPriorityEnum.medium.toString(),
//         isAlarm: false,
//         createDateTime: widget.importDateTime,
//       ),
//     );

//     if (isAction) {
//       onTapCheck(id: planId, isSelected: isAction);
//     }
//   }

//   FocusScope.of(context).unfocus();
//   setState(() => curType = PlanTypeEnum.none);
// }

// onTapEmptyArea(PlanTypeEnum type) {
//   setState(() => curType = type);
// }
      // setContentWidgets(
        //     type: PlanTypeEnum.exercise,
        //     title: '운동',
        //     mainColor: exerciseColor,
        //     backgroundColor: exerciseColor.shade100,
        //     counterText: '헬스, 필라테스, 홈 트레이닝'),
        // setContentWidgets(
        //     type: PlanTypeEnum.lifestyle,
        //     title: '생활습관',
        //     mainColor: lifeStyleColor,
        //     backgroundColor: lifeStyleColor.shade100,
        //     counterText: '야식 금지, 다이어트 동기부여 영상 보기'),
