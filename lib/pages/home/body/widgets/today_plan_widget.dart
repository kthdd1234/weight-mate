import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_weight_management/components/area/empty_area.dart';
import 'package:flutter_app_weight_management/components/area/empty_text_vertical_area.dart';
import 'package:flutter_app_weight_management/components/button/expanded_button_verti.dart';
import 'package:flutter_app_weight_management/components/check/plan_contents.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/icon/text_icon.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/components/text/contents_title_text.dart';
import 'package:flutter_app_weight_management/model/plan_box/plan_box.dart';
import 'package:flutter_app_weight_management/model/record_box/record_box.dart';
import 'package:flutter_app_weight_management/pages/home/body/widgets/record_contents_title_icon.dart';
import 'package:flutter_app_weight_management/provider/diet_Info_provider.dart';
import 'package:flutter_app_weight_management/services/notifi_service.dart';
import 'package:flutter_app_weight_management/utils/class.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:flutter_app_weight_management/utils/variable.dart';
import 'package:flutter_app_weight_management/widgets/dafault_bottom_sheet.dart';
import 'package:flutter_app_weight_management/widgets/touch_and_check_input_widget.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

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
    RecordBox? recordInfo =
        recordBox.get(getDateTimeToInt(widget.importDateTime));
    List<PlanBox> planInfoList = planBox.values.toList();
    List<RecordIconClass> recordIconClassList = [
      RecordIconClass(
        enumId: RecordIconTypes.removePlan,
        icon: Icons.delete,
      ),
    ];
    List<Widget> iconWidgets = recordIconClassList
        .map(
          (element) => RecordContentsTitleIcon(
            id: element.enumId,
            icon: element.icon,
            onTap: (enumId) {
              if (RecordIconTypes.removePlan == enumId) {
                if (planInfoList.isEmpty) {
                  return showSnackBar(
                    context: context,
                    text: '삭제할 계획이 없어요.',
                    buttonName: '확인',
                  );
                }

                // showModalBottomSheet(
                //   backgroundColor: Colors.transparent,
                //   context: context,
                //   builder: (context) {
                //     return null;
                //   },
                // );
              }
            },
          ),
        )
        .toList();

    onTapEmptyArea(PlanTypeEnum type) {
      setState(() => curType = type);
    }

    onTapCheck({required String id, required bool isSelected}) async {
      DateTime now = DateTime.now();
      DateTime actionDateTime = DateTime(
        widget.importDateTime.year,
        widget.importDateTime.month,
        widget.importDateTime.day,
        now.hour,
        now.minute,
      );
      Map<String, dynamic> actionItem = {'id': id, 'time': actionDateTime};

      if (isSelected) {
        HapticFeedback.mediumImpact();

        if (recordInfo == null) {
          recordBox.put(
            getDateTimeToInt(widget.importDateTime),
            RecordBox(
              createDateTime: widget.importDateTime,
              actions: [actionItem],
            ),
          );
        } else {
          recordInfo.actions == null
              ? recordInfo.actions = [actionItem]
              : recordInfo.actions!.add(actionItem);

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

    onEditingComplete({
      required String text,
      required bool isAction,
      required String title,
      required PlanTypeEnum type,
    }) {
      if (text == '') {
        showSnackBar(
          context: context,
          text: '한 글자 이상 입력해주세요.',
          buttonName: '확인',
          width: 270,
        );
      } else {
        String planId = getUUID();
        planBox.put(
          planId,
          PlanBox(
            id: planId,
            type: type.toString(),
            title: title,
            name: text,
            startDateTime: DateTime.now(),
            isAlarm: false,
          ),
        );

        if (isAction) {
          onTapCheck(id: planId, isSelected: isAction);
        }
      }

      FocusScope.of(context).unfocus();
      setState(() => curType = PlanTypeEnum.none);
    }

    onTapEditPlan(PlanBox planInfo) async {
      context.read<DietInfoProvider>().changePlanInfo(
            PlanInfoClass(
              type: planType[planInfo.type]!,
              title: planInfo.title,
              id: planInfo.id,
              name: planInfo.name,
              startDateTime: planInfo.startDateTime,
              endDateTime: planInfo.endDateTime,
              isAlarm: planInfo.isAlarm,
              alarmTime: planInfo.alarmTime,
              alarmId: planInfo.alarmId,
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
      NotificationService()
          .deleteMultipleAlarm([planInfo!.alarmId.toString()]); // 알림 id 삭제

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
                title: '이름, 기간, 알림 설정',
                onTap: () => onTapEditPlan(planInfo),
              ),
              SpaceWidth(width: tinySpace),
              ExpandedButtonVerti(
                mainColor: Colors.red,
                icon: Icons.delete_forever,
                title: '계획 삭제하기',
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

    setContentWidgets({
      required PlanTypeEnum type,
      required String title,
      required Color mainColor,
      required Color backgroundColor,
      required String counterText,
    }) {
      List<PlanContents> planContentsList = [];

      for (var i = 0; i < planInfoList.length; i++) {
        PlanBox planInfo = planInfoList[i];

        actionData() {
          if (recordInfo == null || recordInfo.actions == null) {
            return null;
          }

          Map<String, dynamic> data = recordInfo.actions!.firstWhere(
            (element) => element['id'] == planInfo.id,
            orElse: () => {'id': null, 'time': null},
          );

          return data;
        }

        if (planInfo.type == type.toString()) {
          planContentsList.add(
            PlanContents(
              id: planInfo.id,
              text: planInfo.name,
              isAction: actionData()?['id'] != null,
              mainColor: mainColor,
              startDateTime: planInfo.startDateTime,
              endDateTime: planInfo.endDateTime,
              alarmTime: planInfo.alarmTime,
              recordTime: actionData()?['time'],
              onTapCheck: onTapCheck,
              onTapContents: onTapContents,
              onTapMore: onTapContents,
            ),
          );
        }
      }

      setActionPercent() {
        return '실천율: 30%';
      }

      return Column(
        children: [
          SpaceHeight(height: smallSpace),
          ContentsBox(
            contentsWidget: Column(
              children: [
                ContentsTitleText(
                  text: title,
                  sub: [
                    TextIcon(
                      backgroundColor: backgroundColor,
                      text: setActionPercent(),
                      borderRadius: 5,
                      textColor: mainColor,
                      fontSize: 10,
                      padding: 7,
                    )
                  ],
                ),
                SpaceHeight(height: smallSpace),
                Column(
                    children: planContentsList.isNotEmpty
                        ? planContentsList
                        : [
                            EmptyTextVerticalArea(
                              height: 130,
                              backgroundColor: Colors.transparent,
                              icon: planTypeDetailInfo[type]!.icon,
                              title: '$title 계획이 없어요. \n (ex. $counterText)',
                            ),
                          ]),
                SpaceHeight(height: smallSpace),
                TouchAndCheckInputWidget(
                  type: type,
                  mainColor: mainColor,
                  title: title,
                  checkBoxEnabledIcon: Icons.check_box,
                  checkBoxDisEnabledIcon: Icons.check_box_outlined,
                  showEmptyTouchArea: curType != type,
                  onTapEmptyArea: onTapEmptyArea,
                  onEditingComplete: onEditingComplete,
                )
              ],
            ),
          ),
        ],
      );
    }

    return Column(
      children: [
        ContentsTitleText(text: '오늘의 계획', icon: Icons.list, sub: iconWidgets),
        setContentWidgets(
            type: PlanTypeEnum.diet,
            title: '식이요법',
            mainColor: dietColor,
            backgroundColor: dietColor.shade100,
            counterText: '간헐적 단식, 저탄코지 다이어트'),
        setContentWidgets(
            type: PlanTypeEnum.exercise,
            title: '운동',
            mainColor: exerciseColor,
            backgroundColor: exerciseColor.shade100,
            counterText: '헬스, 필라테스, 홈 트레이닝'),
        setContentWidgets(
            type: PlanTypeEnum.lifestyle,
            title: '생활습관',
            mainColor: lifeStyleColor,
            backgroundColor: lifeStyleColor.shade100,
            counterText: '야식 금지, 다이어트 동기부여 영상 보기'),
      ],
    );
  }
}

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
