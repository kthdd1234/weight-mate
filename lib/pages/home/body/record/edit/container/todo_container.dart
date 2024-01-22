// ignore_for_file: use_build_context_synchronously, avoid_function_literals_in_foreach_calls
import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_weight_management/common/CommonBottomSheet.dart';
import 'package:flutter_app_weight_management/common/CommonButton.dart';
import 'package:flutter_app_weight_management/common/CommonCheckBox.dart';
import 'package:flutter_app_weight_management/common/CommonIcon.dart';
import 'package:flutter_app_weight_management/common/CommonText.dart';
import 'package:flutter_app_weight_management/components/area/empty_area.dart';
import 'package:flutter_app_weight_management/components/button/expanded_button_hori.dart';
import 'package:flutter_app_weight_management/components/button/expanded_button_verti.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box_exp.dart';
import 'package:flutter_app_weight_management/components/dialog/native_ad_dialog.dart';
import 'package:flutter_app_weight_management/components/segmented/default_segmented.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/main.dart';
import 'package:flutter_app_weight_management/model/plan_box/plan_box.dart';
import 'package:flutter_app_weight_management/model/record_box/record_box.dart';
import 'package:flutter_app_weight_management/model/user_box/user_box.dart';
import 'package:flutter_app_weight_management/pages/home/body/record/edit/container/alarm_container.dart';
import 'package:flutter_app_weight_management/pages/home/body/record/edit/container/title_container.dart';
import 'package:flutter_app_weight_management/pages/home/body/record/edit/edit_todo.dart';
import 'package:flutter_app_weight_management/provider/bottom_navigation_provider.dart';
import 'package:flutter_app_weight_management/provider/import_date_time_provider.dart';
import 'package:flutter_app_weight_management/services/notifi_service.dart';
import 'package:flutter_app_weight_management/utils/class.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:flutter_app_weight_management/utils/variable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive/hive.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

String eDiet = PlanTypeEnum.diet.toString();
String eExercise = PlanTypeEnum.exercise.toString();
String eLife = PlanTypeEnum.lifestyle.toString();

class TodoContainer extends StatefulWidget {
  TodoContainer({
    super.key,
    required this.filterId,
    required this.type,
    required this.color,
    required this.title,
    required this.icon,
  });

  String filterId, color, title, type;
  IconData icon;

  @override
  State<TodoContainer> createState() => _TodoContainerState();
}

class _TodoContainerState extends State<TodoContainer> {
  bool isShowInput = false;

  @override
  Widget build(BuildContext context) {
    DateTime importDateTime =
        context.watch<ImportDateTimeProvider>().getImportDateTime();

    UserBox user = userRepository.user;
    bool? isDisplay = user.displayList?.contains(widget.filterId) == true;
    bool? isOpen = user.filterList?.contains(widget.filterId) == true;

    Box<PlanBox> planBox = planRepository.planBox;
    Box<RecordBox> recordBox = recordRepository.recordBox;
    int recordKey = getDateTimeToInt(importDateTime);
    RecordBox? recordInfo = recordBox.get(recordKey);
    List<Map<String, dynamic>>? actions = recordInfo?.actions;
    List<PlanBox> planList =
        planBox.values.where((element) => element.type == widget.type).toList();
    Map<String, Color> tagColor = tagColors[widget.color]!;
    Color mainColor = tagColor['textColor']!;
    Color bgColor = tagColor['bgColor']!;

    bool isLife = widget.filterId == FILITER.lifeStyle.toString();

    onCheckBox({required dynamic id, required bool newValue}) async {
      PlanBox? planInfo = planBox.get(id);
      DateTime now = DateTime.now();
      DateTime actionDateTime = DateTime(
        importDateTime.year,
        importDateTime.month,
        importDateTime.day,
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

      // 체크 on
      if (newValue == true) {
        HapticFeedback.mediumImpact();

        if (recordInfo == null) {
          await recordBox.put(
            recordKey,
            RecordBox(
              createDateTime: importDateTime,
              actions: [actionItem.setObject()],
            ),
          );
        } else {
          recordInfo.actions == null
              ? recordInfo.actions = [actionItem.setObject()]
              : recordInfo.actions!.add(actionItem.setObject());
        }
      }

      // 체크 off
      if (newValue == false) {
        recordInfo!.actions!.removeWhere((element) => element['id'] == id);

        if (recordInfo.actions!.isEmpty) {
          recordInfo.actions = null;
        }
      }

      await recordInfo?.save();
    }

    onGoalComplete({
      required String completedType,
      required dynamic id,
      required String text,
      required bool newValue,
      String? priority,
      bool? isAlarm,
      DateTime? createDateTime,
      DateTime? alarmTime,
      int? alarmId,
    }) async {
      await planBox.put(
        id,
        PlanBox(
          id: id,
          type: widget.type,
          title: widget.title,
          name: text,
          priority: priority ?? PlanPriorityEnum.medium.toString(),
          isAlarm: isAlarm ?? false,
          createDateTime: createDateTime ?? DateTime.now(),
          alarmTime: alarmTime,
          alarmId: alarmId,
        ),
      );

      if (isAlarm == true) {
        await NotificationService().addNotification(
          id: alarmId!,
          dateTime: DateTime.now(),
          alarmTime: alarmTime!,
          title: planNotifyTitle(),
          body: planNotifyBody(title: widget.title, body: text),
          payload: 'plan',
        );
      }
    }

    onRecordComplete({
      required String completedType,
      required String id,
      required String name,
      required DateTime actionDateTime,
      required String title,
    }) async {
      ActionItemClass actionItem = ActionItemClass(
        id: id,
        title: title,
        type: widget.type,
        name: name,
        priority: '',
        isRecord: true,
        actionDateTime: actionDateTime,
        createDateTime: actionDateTime,
      );

      if (completedType == '추가') {
        if (recordInfo == null) {
          await recordBox.put(
            recordKey,
            RecordBox(
              createDateTime: importDateTime,
              actions: [actionItem.setObject()],
            ),
          );
        } else {
          recordInfo.actions == null
              ? recordInfo.actions = [actionItem.setObject()]
              : recordInfo.actions!.add(actionItem.setObject());
        }
      } else {
        int? idx = recordInfo?.actions?.indexWhere((item) => item['id'] == id);
        if (idx != null && idx != -1) {
          recordInfo?.actions![idx] = actionItem.setObject();
        }
      }

      await recordInfo?.save();
    }

    actionPercent() {
      if (actions == null) {
        return '0.0';
      }

      final result = actions.where((element) {
        bool isPlanType = widget.type == element['type'];
        bool isAction =
            recordKey == getDateTimeToInt(element['actionDateTime']);
        bool isShowPlan = planBox.get(element['id']) != null;

        return isPlanType && isAction && isShowPlan;
      });

      return planToActionPercent(
        a: result.length,
        b: planList.length,
      ).toString();
    }

    onTapActionPercent() {
      //
    }

    onTapOpen() {
      isOpen
          ? user.filterList?.remove(widget.filterId)
          : user.filterList?.add(widget.filterId);
      user.save();
    }

    TagClass commonTag = TagClass(
      icon: isOpen
          ? Icons.keyboard_arrow_down_rounded
          : Icons.keyboard_arrow_right_rounded,
      color: widget.color,
      onTap: onTapOpen,
    );

    List<TagClass> dietExerciseTags = [
      TagClass(
        text: '기록 ${onActionList(
              actions: actions,
              type: widget.type,
              onRecordUpdate: onRecordComplete,
            )?.length ?? 0}개',
        color: widget.color,
        isHide: isOpen,
        onTap: onTapOpen,
      ),
      TagClass(
        text: '목표 ${planList.length}개',
        color: widget.color,
        isHide: isOpen,
        onTap: onTapOpen,
      ),
      commonTag
    ];

    List<TagClass> lifeTags = [
      TagClass(
        text: '목표 ${planList.length}개',
        color: widget.color,
        isHide: isOpen,
        onTap: onTapOpen,
      ),
      TagClass(
        text: '실천율 ${actionPercent()}%',
        color: widget.color,
        onTap: onTapActionPercent,
      ),
      commonTag
    ];

    return isDisplay
        ? Column(
            children: [
              ContentsBox(
                contentsWidget: Column(
                  children: [
                    TitleContainer(
                      isDivider: isOpen,
                      title: widget.title,
                      icon: widget.icon,
                      tags: isLife ? lifeTags : dietExerciseTags,
                      onTap: onTapOpen,
                    ),
                    isLife
                        ? LifeContainer(
                            type: widget.type,
                            isOpen: isOpen,
                            title: widget.title,
                            actions: actions,
                            mainColor: mainColor,
                            planList: planList,
                            onCheckBox: onCheckBox,
                            onGoalComplete: onGoalComplete,
                          )
                        : DietExerciseContainer(
                            type: widget.type,
                            isOpen: isOpen,
                            bgColor: bgColor,
                            actions: actions,
                            mainColor: mainColor,
                            planList: planList,
                            onCheckBox: onCheckBox,
                            onGoalComplete: onGoalComplete,
                            onRecordComplete: onRecordComplete,
                          )
                  ],
                ),
              ),
              SpaceHeight(height: smallSpace),
            ],
          )
        : const EmptyArea();
  }
}

class DietExerciseContainer extends StatefulWidget {
  DietExerciseContainer({
    super.key,
    required this.type,
    required this.isOpen,
    required this.bgColor,
    required this.actions,
    required this.mainColor,
    required this.planList,
    required this.onCheckBox,
    required this.onGoalComplete,
    required this.onRecordComplete,
  });

  String type;
  bool isOpen;
  Color bgColor;
  List<Map<String, dynamic>>? actions;
  Color mainColor;
  List<PlanBox> planList;
  Function({required dynamic id, required bool newValue}) onCheckBox;
  Function({
    required String completedType,
    required dynamic id,
    required bool newValue,
    required String text,
    int? alarmId,
    DateTime? alarmTime,
    DateTime? createDateTime,
    bool? isAlarm,
    String? priority,
  }) onGoalComplete;
  Function({
    required String completedType,
    required String id,
    required String name,
    required DateTime actionDateTime,
    required String title,
  }) onRecordComplete;

  @override
  State<DietExerciseContainer> createState() => _DietExerciseContainerState();
}

class _DietExerciseContainerState extends State<DietExerciseContainer> {
  SegmentedTypes selectedSegment = SegmentedTypes.record;

  @override
  Widget build(BuildContext context) {
    onSegmentedChanged(SegmentedTypes? segmented) {
      setState(() {
        selectedSegment = segmented!;
      });
    }

    bool isRecord = selectedSegment == SegmentedTypes.record;
    List<Widget>? actionList = onActionList(
      actions: widget.actions,
      type: widget.type,
      onRecordUpdate: widget.onRecordComplete,
    );

    Map<SegmentedTypes, Widget> children = {
      SegmentedTypes.record: onSegmentedWidget(
        title: '기록 ${actionList?.length ?? 0}',
        type: SegmentedTypes.record,
        selected: selectedSegment,
      ),
      SegmentedTypes.month: onSegmentedWidget(
        title: '목표 ${widget.planList.length}',
        type: SegmentedTypes.month,
        selected: selectedSegment,
      ),
    };

    return widget.isOpen
        ? Column(
            children: [
              DefaultSegmented(
                selectedSegment: selectedSegment,
                children: children,
                backgroundColor: dialogBackgroundColor,
                thumbColor: Colors.white,
                onSegmentedChanged: onSegmentedChanged,
              ),
              SpaceHeight(height: regularSapce),
              isRecord
                  ? Column(
                      children: [
                        RecordList(
                          actionList: actionList,
                          onRecordUpdate: widget.onRecordComplete,
                        ),
                        RecordAdd(
                          type: widget.type,
                          onRecordAdd: widget.onRecordComplete,
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        GoalList(
                          type: widget.type,
                          actions: widget.actions,
                          planList: widget.planList,
                          mainColor: widget.mainColor,
                          onCheckBox: widget.onCheckBox,
                          onGoalUpdate: widget.onGoalComplete,
                        ),
                        GoalAdd(
                          type: widget.type,
                          title: '목표',
                          mainColor: widget.mainColor,
                          onTapGoalAdd: widget.onGoalComplete,
                        ),
                      ],
                    ),
            ],
          )
        : const EmptyArea();
  }
}

class RecordList extends StatelessWidget {
  RecordList({
    super.key,
    required this.actionList,
    required this.onRecordUpdate,
  });

  List<Widget>? actionList;
  Function({
    required String completedType,
    required String id,
    required String name,
    required DateTime actionDateTime,
    required String title,
  }) onRecordUpdate;

  @override
  Widget build(BuildContext context) {
    bool? isList = actionList?.isNotEmpty;
    return isList == true ? Column(children: actionList!) : const EmptyArea();
  }
}

class RecordName extends StatefulWidget {
  RecordName({
    super.key,
    required this.type,
    required this.id,
    required this.name,
    required this.title,
    required this.topTitle,
    required this.actionDateTime,
    required this.onRecordUpdate,
  });

  String type, id, name, title, topTitle;
  DateTime actionDateTime;
  Function({
    required String completedType,
    required String id,
    required String name,
    required DateTime actionDateTime,
    required String title,
  }) onRecordUpdate;

  @override
  State<RecordName> createState() => _RecordNameState();
}

class _RecordNameState extends State<RecordName> {
  TextEditingController textController = TextEditingController();
  bool isShowInput = false;

  @override
  void initState() {
    textController.text = widget.name;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DateTime importDateTime =
        context.watch<ImportDateTimeProvider>().getImportDateTime();
    Box<RecordBox> recordBox = recordRepository.recordBox;
    int recordKey = getDateTimeToInt(importDateTime);
    RecordBox? recordInfo = recordBox.get(recordKey);

    onTapEdit() {
      textController.text = widget.name;
      setState(() => isShowInput = true);
    }

    onTapTitle(String selectedTitle) async {
      recordInfo?.actions?.forEach(
        (action) {
          if (action['id'] == widget.id) {
            action['title'] = selectedTitle;
          }
        },
      );

      await recordInfo?.save();
    }

    onTapRemove() async {
      recordInfo!.actions!.removeWhere((action) => action['id'] == widget.id);

      if (recordInfo.actions!.isEmpty) {
        recordInfo.actions = null;
      }

      await recordInfo.save();
    }

    onTapMore() {
      showModalBottomSheet(
        context: context,
        builder: (context) {
          return RecordBottomSheet(
            selectedTitle: widget.title,
            type: widget.type,
            id: widget.id,
            name: widget.name,
            topTitle: widget.topTitle,
            onTapEdit: onTapEdit,
            onTapTitle: onTapTitle,
            onTapRemove: onTapRemove,
          );
        },
      );
    }

    onEditingComplete() {
      if (textController.text != '') {
        widget.onRecordUpdate(
          completedType: '수정',
          id: widget.id,
          name: textController.text,
          actionDateTime: widget.actionDateTime,
          title: widget.title,
        );
      }

      setState(() => isShowInput = false);
    }

    return isShowInput
        ? Row(
            children: [
              TodoInput(
                controller: textController,
                onEditingComplete: onEditingComplete,
              ),
            ],
          )
        : Dismiss(
            id: widget.id,
            onDismiss: onTapRemove,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => onTapMore(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.name,
                          style:
                              const TextStyle(color: themeColor, fontSize: 15),
                        ),
                        SpaceHeight(height: 3),
                        CommonText(
                          text: widget.title,
                          size: 11,
                          color: Colors.grey,
                        )
                      ],
                    ),
                  ),
                ),
                SpaceWidth(width: regularSapce),
                CommonIcon(
                  icon: Icons.more_horiz_rounded,
                  size: 20,
                  color: Colors.grey,
                  onTap: onTapMore,
                )
              ],
            ));
  }
}

class Dismiss extends StatelessWidget {
  Dismiss({
    super.key,
    required this.id,
    required this.child,
    required this.onDismiss,
  });

  String id;
  Widget child;
  Function() onDismiss;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(id),
      dismissThresholds: const {DismissDirection.endToStart: 0.2},
      direction: DismissDirection.endToStart,
      background: Container(
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(3),
        ),
        padding: const EdgeInsets.only(right: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            CommonIcon(
              icon: Icons.delete_rounded,
              size: 20,
              color: Colors.white,
            ),
          ],
        ),
      ),
      confirmDismiss: (direction) async {
        return showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              shape: containerBorderRadious,
              backgroundColor: dialogBackgroundColor,
              title: const Text('삭제할까요?',
                  style: TextStyle(fontSize: 18, color: themeColor)),
              content: Row(
                children: [
                  ExpandedButtonHori(
                    padding: 12,
                    imgUrl: 'assets/images/t-11.png',
                    text: '닫기',
                    onTap: () => Navigator.of(context).pop(false),
                  ),
                  SpaceWidth(width: tinySpace),
                  ExpandedButtonHori(
                    padding: 12,
                    imgUrl: 'assets/images/t-23.png',
                    text: '삭제',
                    onTap: () {
                      onDismiss();
                      return Navigator.of(context).pop(true);
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
      child: child,
    );
  }
}

class RecordAdd extends StatefulWidget {
  RecordAdd({
    super.key,
    required this.type,
    required this.onRecordAdd,
  });

  String type;
  Function({
    required String completedType,
    required String id,
    required String name,
    required DateTime actionDateTime,
    required String title,
  }) onRecordAdd;

  @override
  State<RecordAdd> createState() => _RecordAddState();
}

class _RecordAddState extends State<RecordAdd> {
  TextEditingController textController = TextEditingController();
  bool isShowInput = false;

  @override
  Widget build(BuildContext context) {
    DateTime importDateTime =
        context.watch<ImportDateTimeProvider>().getImportDateTime();

    onTapAdd() {
      setState(() => isShowInput = true);
    }

    onEditingComplete() async {
      String name = textController.text;

      setState(() {
        isShowInput = false;
        textController.text = '';
      });

      if (name != '') {
        await showModalBottomSheet(
          context: context,
          builder: (context) {
            return CategoryBottomSheet(
              type: widget.type,
              name: name,
              selectedTitle: '',
              onTap: (String title) {
                widget.onRecordAdd(
                  completedType: '추가',
                  id: uuid(),
                  name: name,
                  actionDateTime: importDateTime,
                  title: title,
                );
              },
            );
          },
        );
      }
    }

    return isShowInput
        ? Row(
            children: [
              TodoInput(
                controller: textController,
                onEditingComplete: onEditingComplete,
              ),
            ],
          )
        : InkWell(
            onTap: onTapAdd,
            child: Row(
              children: [
                SvgPicture.asset('assets/svgs/pencil-square.svg', height: 18),
                SpaceWidth(width: 7),
                CommonText(text: '기록 추가', size: 15, color: Colors.grey),
              ],
            ),
          );
  }
}

class CategoryBottomSheet extends StatelessWidget {
  CategoryBottomSheet({
    super.key,
    required this.type,
    required this.name,
    required this.selectedTitle,
    required this.onTap,
  });

  String type, name, selectedTitle;
  Function(String title) onTap;

  @override
  Widget build(BuildContext context) {
    return CommonBottomSheet(
      title: name,
      height: eDiet == type ? 200 : 220,
      contents: CategoryList(
        selectedTitle: selectedTitle,
        type: type,
        onTap: onTap,
      ),
    );
  }
}

class CategoryList extends StatelessWidget {
  CategoryList({
    super.key,
    required this.type,
    required this.onTap,
    required this.selectedTitle,
  });

  String type, selectedTitle;
  Function(String title) onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
        children: category[type]!
            .map(
              (item) => Expanded(
                child: Row(
                  children: [
                    ExpandedButtonVerti(
                      iconSize: eDiet == type ? 21 : 30,
                      titleSize: eDiet == type ? 13 : 15,
                      height: eDiet == type ? 90 : 105,
                      isBold: item['title'] == selectedTitle,
                      mainColor: item['title'] == selectedTitle
                          ? Colors.white
                          : themeColor,
                      backgroundColor: item['title'] == selectedTitle
                          ? themeColor
                          : Colors.white,
                      icon: item['icon'],
                      title: item['title'],
                      onTap: () {
                        onTap(item['title']);
                        closeDialog(context);
                      },
                    ),
                    SpaceWidth(width: item['space'] == true ? 0 : 5)
                  ],
                ),
              ),
            )
            .toList());
  }
}

class LifeContainer extends StatelessWidget {
  LifeContainer({
    super.key,
    required this.type,
    required this.isOpen,
    required this.title,
    required this.actions,
    required this.mainColor,
    required this.planList,
    required this.onCheckBox,
    required this.onGoalComplete,
  });

  String type;
  bool isOpen;
  String title;
  List<Map<String, dynamic>>? actions;
  Color mainColor;
  List<PlanBox> planList;
  Function({required dynamic id, required bool newValue}) onCheckBox;
  Function({
    required String completedType,
    required dynamic id,
    required bool newValue,
    required String text,
    int? alarmId,
    DateTime? alarmTime,
    DateTime? createDateTime,
    bool? isAlarm,
    String? priority,
  }) onGoalComplete;

  @override
  Widget build(BuildContext context) {
    return isOpen
        ? Column(
            children: [
              GoalList(
                type: type,
                actions: actions,
                mainColor: mainColor,
                planList: planList,
                onCheckBox: onCheckBox,
                onGoalUpdate: onGoalComplete,
              ),
              GoalAdd(
                type: type,
                title: title,
                mainColor: mainColor,
                onTapGoalAdd: onGoalComplete,
              ),
            ],
          )
        : const EmptyArea();
  }
}

class GoalList extends StatelessWidget {
  GoalList({
    super.key,
    required this.type,
    required this.actions,
    required this.planList,
    required this.mainColor,
    required this.onCheckBox,
    required this.onGoalUpdate,
  });

  String type;
  Color mainColor;
  List<Map<String, dynamic>>? actions;
  List<PlanBox> planList;
  Function({required dynamic id, required bool newValue}) onCheckBox;
  Function({
    required String completedType,
    required dynamic id,
    required String text,
    required bool newValue,
    String? priority,
    bool? isAlarm,
    DateTime? createDateTime,
    DateTime? alarmTime,
    int? alarmId,
  }) onGoalUpdate;

  @override
  Widget build(BuildContext context) {
    UserBox user = userRepository.user;
    List<String>? orderList = {
      eDiet: user.dietOrderList,
      eExercise: user.exerciseOrderList,
      eLife: user.lifeOrderList,
    }[type]!;

    planList.sort((itemA, itemB) {
      int indexA = orderList.indexOf(itemA.id);
      int indexB = orderList.indexOf(itemB.id);

      return indexA.compareTo(indexB);
    });

    onTapRemove(PlanBox planInfo) {
      if (planInfo.alarmId != null) {
        NotificationService().deleteAlarm(planInfo.alarmId!);
      }

      planRepository.planBox.delete(planInfo.id);
      orderList.remove(planInfo.id);

      user.save();
    }

    action(String planId) {
      if (actions == null) {
        return {'id': null, 'actionDateTime': null};
      }

      final action = actions!.firstWhere(
        (element) => element['id'] == planId,
        orElse: () => {'id': null, 'actionDateTime': null},
      );

      return action;
    }

    Widget item(index) {
      return InkWell(
        key: Key(planList[index].id),
        child: Column(
          children: [
            Dismiss(
              id: planList[index].id,
              onDismiss: () => onTapRemove(planList[index]),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonCheckBox(
                    id: planList[index].id,
                    isCheck: action(planList[index].id)['id'] != null,
                    checkColor: mainColor,
                    onTap: onCheckBox,
                  ),
                  GoalName(
                    type: type,
                    planInfo: planList[index],
                    color: mainColor,
                    isChcked: action(planList[index].id)['id'] != null,
                    onGoalUpdate: onGoalUpdate,
                    onTapRemove: onTapRemove,
                  ),
                ],
              ),
            ),
            SpaceHeight(height: 10)
          ],
        ),
      );
    }

    Widget proxyDecorator(
        Widget child, int index, Animation<double> animation) {
      return AnimatedBuilder(
        animation: animation,
        builder: (BuildContext context, Widget? child) {
          final double animValue = Curves.easeInOut.transform(animation.value);
          final double scale = lerpDouble(1, 1.02, animValue)!;
          return Transform.scale(
            scale: scale,
            child: Card(
              margin: const EdgeInsets.all(0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(7),
              ),
              color: const Color(0xffF9F9FC),
              elevation: 0.0,
              child: item(index),
            ),
          );
        },
        child: child,
      );
    }

    onReorder(int oldIndex, int newIndex) {
      String oldId = planList[oldIndex].id;
      String targetId = uuid();

      orderList[oldIndex] = targetId;
      orderList.insert(newIndex, oldId);
      orderList.remove(targetId);

      user.save();
    }

    return ReorderableListView(
      shrinkWrap: true,
      proxyDecorator: proxyDecorator,
      onReorder: onReorder,
      children: List.generate(planList.length, (int index) => item(index)),
    );
  }
}

class GoalName extends StatefulWidget {
  GoalName({
    required this.type,
    required this.planInfo,
    required this.isChcked,
    required this.onGoalUpdate,
    required this.color,
    required this.onTapRemove,
    this.fontSize,
    this.textColor,
  });

  String type;
  PlanBox planInfo;
  double? fontSize;
  bool isChcked;
  Color color;
  Color? textColor;
  Function({
    required String completedType,
    required dynamic id,
    required String text,
    required bool newValue,
    String? priority,
    bool? isAlarm,
    DateTime? createDateTime,
    DateTime? alarmTime,
    int? alarmId,
  }) onGoalUpdate;
  Function(PlanBox) onTapRemove;

  @override
  State<GoalName> createState() => _GoalNameState();
}

class _GoalNameState extends State<GoalName> {
  TextEditingController textController = TextEditingController();
  bool isShowInput = false;

  @override
  void initState() {
    textController.text = widget.planInfo.name;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    onEditingComplete() {
      setState(() => isShowInput = false);

      if (textController.text != '') {
        widget.onGoalUpdate(
          completedType: '수정',
          id: widget.planInfo.id,
          text: textController.text,
          newValue: widget.isChcked,
          createDateTime: widget.planInfo.createDateTime,
          isAlarm: widget.planInfo.isAlarm,
          priority: widget.planInfo.priority,
          alarmTime: widget.planInfo.alarmTime,
          alarmId: widget.planInfo.alarmId,
        );
      } else {
        textController.text = widget.planInfo.name;
      }
    }

    onTapEdit() {
      textController.text = widget.planInfo.name;
      setState(() => isShowInput = true);
    }

    onTapMore() {
      showModalBottomSheet(
        context: context,
        builder: (context) => GoalBottomSheet(
          type: widget.type,
          id: widget.planInfo.id,
          name: widget.planInfo.name,
          icon: todoData[widget.planInfo.type]!.icon,
          title: todoData[widget.planInfo.type]!.title,
          planInfo: widget.planInfo,
          onTapEdit: onTapEdit,
          onTapRemove: widget.onTapRemove,
        ),
      );
    }

    onActionCount() {
      int count = 0;

      recordRepository.recordList.forEach((record) {
        final actionList = record.actions;

        if (actionList != null) {
          actionList.forEach((action) {
            if (action['id'] == widget.planInfo.id) {
              count += 1;
            }
          });
        }
      });

      return count;
    }

    return isShowInput
        ? TodoInput(
            controller: textController,
            onEditingComplete: onEditingComplete,
          )
        : Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => onTapMore(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                            widget.planInfo.name,
                            style: TextStyle(
                              fontSize: widget.fontSize ?? 15,
                              color: widget.textColor ?? themeColor,
                              decorationColor: widget.color,
                              decorationThickness: 1,
                              decoration: widget.isChcked
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),
                        ),
                        SpaceHeight(height: 3),
                        Row(
                          children: [
                            widget.planInfo.isAlarm
                                ? CommonText(
                                    text:
                                        '${timeToString(widget.planInfo.alarmTime)} 알림, ',
                                    size: 11,
                                    color: Colors.grey,
                                  )
                                : const EmptyArea(),
                            CommonText(
                              text: '실천 ${onActionCount()}회',
                              size: 11,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SpaceWidth(width: regularSapce),
                CommonIcon(
                  icon: Icons.more_horiz,
                  size: 22,
                  color: Colors.grey,
                  onTap: onTapMore,
                ),
              ],
            ),
          );
  }
}

class GoalAdd extends StatefulWidget {
  GoalAdd({
    super.key,
    required this.type,
    required this.title,
    required this.mainColor,
    required this.onTapGoalAdd,
  });

  String type, title;
  Color mainColor;
  Function({
    required String completedType,
    required dynamic id,
    required String text,
    required bool newValue,
  }) onTapGoalAdd;

  @override
  State<GoalAdd> createState() => _GoalAddState();
}

class _GoalAddState extends State<GoalAdd> {
  TextEditingController textController = TextEditingController();
  bool isShowInput = false;
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    UserBox user = userRepository.user;
    List<String>? orderList = {
      eDiet: user.dietOrderList,
      eExercise: user.exerciseOrderList,
      eLife: user.lifeOrderList,
    }[widget.type]!;

    onTap() {
      setState(() => isShowInput = true);
    }

    onEditingComplete() {
      String id = uuid();

      if (textController.text != '') {
        widget.onTapGoalAdd(
          completedType: '추가',
          id: id,
          text: textController.text,
          newValue: isChecked,
        );
      }

      orderList.add(id);
      user.save();

      setState(() {
        isShowInput = false;
        isChecked = false;
        textController.text = '';
      });
    }

    onCheckBox({required dynamic id, required bool newValue}) {
      if (!isShowInput) {
        return setState(() => isShowInput = true);
      }

      if (id != 'disabled' && !isShowInput) {
        setState(() => isChecked = newValue);
      }
    }

    return InkWell(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CommonCheckBox(
            id: isShowInput ? uuid() : 'disabled',
            isCheck: isChecked,
            checkColor: isChecked ? widget.mainColor : Colors.grey,
            isDisabled: !isShowInput,
            onTap: onCheckBox,
          ),
          !isShowInput
              ? Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: CommonText(
                    text: '${widget.title} 추가',
                    size: 15,
                    color: Colors.grey,
                  ),
                )
              : TodoInput(
                  controller: textController,
                  onEditingComplete: onEditingComplete,
                )
        ],
      ),
    );
  }
}

class TodoInput extends StatelessWidget {
  TodoInput({
    super.key,
    required this.controller,
    required this.onEditingComplete,
  });

  TextEditingController? controller;
  Function() onEditingComplete;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextFormField(
        maxLength: 70,
        controller: controller,
        autofocus: true,
        textInputAction: TextInputAction.done,
        style: Theme.of(context).textTheme.bodyLarge,
        decoration: const InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.only(bottom: tinySpace),
          counterText: '',
        ),
        minLines: null,
        maxLines: null,
        onEditingComplete: onEditingComplete,
        onTapOutside: (_) {
          FocusScope.of(context).unfocus();
          onEditingComplete();
        },
      ),
    );
  }
}

class RecordBottomSheet extends StatefulWidget {
  RecordBottomSheet({
    super.key,
    required this.type,
    required this.id,
    required this.name,
    required this.selectedTitle,
    required this.topTitle,
    required this.onTapEdit,
    required this.onTapTitle,
    required this.onTapRemove,
  });

  String type, id, name, topTitle, selectedTitle;
  Function() onTapEdit;
  Function(String) onTapTitle;
  Function() onTapRemove;

  @override
  State<RecordBottomSheet> createState() => _RecordBottomSheetState();
}

class _RecordBottomSheetState extends State<RecordBottomSheet> {
  bool isCategory = false;

  @override
  Widget build(BuildContext context) {
    onTapChangeCategory() {
      setState(() => isCategory = true);
    }

    return CommonBottomSheet(
      title: widget.name,
      height: 220,
      contents: isCategory
          ? CategoryList(
              selectedTitle: widget.selectedTitle,
              type: widget.type,
              onTap: widget.onTapTitle,
            )
          : Row(
              children: [
                ExpandedButtonVerti(
                  mainColor: themeColor,
                  icon: Icons.edit,
                  title: '${widget.topTitle} 수정',
                  onTap: () {
                    closeDialog(context);
                    widget.onTapEdit();
                  },
                ),
                SpaceWidth(width: tinySpace),
                ExpandedButtonVerti(
                  mainColor: themeColor,
                  icon: Icons.category,
                  title: '분류 변경',
                  onTap: onTapChangeCategory,
                ),
                SpaceWidth(width: tinySpace),
                ExpandedButtonVerti(
                  mainColor: Colors.red,
                  icon: Icons.delete_forever,
                  title: '${widget.topTitle} 삭제',
                  onTap: () {
                    closeDialog(context);
                    widget.onTapRemove();
                  },
                )
              ],
            ),
    );
  }
}

class GoalBottomSheet extends StatefulWidget {
  GoalBottomSheet({
    super.key,
    required this.type,
    required this.name,
    required this.icon,
    required this.id,
    required this.title,
    required this.planInfo,
    required this.onTapEdit,
    required this.onTapRemove,
  });

  IconData icon;
  String id, title, name, type;
  PlanBox? planInfo;
  Function() onTapEdit;
  Function(PlanBox) onTapRemove;

  @override
  State<GoalBottomSheet> createState() => _GoalBottomSheetState();
}

class _GoalBottomSheetState extends State<GoalBottomSheet> {
  bool isShowAlarm = false;
  bool isEnabled = true;
  bool isRequestPermission = false;
  DateTime alarmTime = DateTime.now();

  @override
  void initState() {
    isEnabled = widget.planInfo?.isAlarm ?? true;
    alarmTime = widget.planInfo?.alarmTime ?? DateTime.now();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    onTapAlarm() async {
      bool isPermission = await NotificationService().permissionNotification;

      setState(() {
        isPermission == false ? isRequestPermission = true : isShowAlarm = true;
      });
    }

    onTapBack() {
      setState(() => isShowAlarm = false);
    }

    onChanged(bool newValue) {
      if (newValue == false) {
        if (widget.planInfo?.alarmId != null) {
          NotificationService().deleteAlarm(widget.planInfo!.alarmId!);
        }

        widget.planInfo?.isAlarm = false;
        widget.planInfo?.alarmId = null;
        widget.planInfo?.alarmTime = null;
        widget.planInfo?.save();
      }

      setState(() => isEnabled = newValue);
    }

    onDateTimeChanged(DateTime dateTime) {
      setState(() => alarmTime = dateTime);
    }

    onCompleted() {
      if (isEnabled) {
        int alarmId = widget.planInfo?.alarmId ?? UniqueKey().hashCode;

        NotificationService().addNotification(
          id: alarmId,
          dateTime: DateTime.now(),
          alarmTime: alarmTime,
          title: planNotifyTitle(),
          body: planNotifyBody(
            title: widget.title,
            body: widget.planInfo?.name ?? '',
          ),
          payload: 'plan',
        );

        widget.planInfo?.isAlarm = true;
        widget.planInfo?.alarmId = alarmId;
        widget.planInfo?.alarmTime = alarmTime;
      }

      widget.planInfo?.save();
      closeDialog(context);
    }

    if (isRequestPermission) {
      closeDialog(context);

      WidgetsBinding.instance.addPostFrameCallback(
        (timeStamp) {
          showDialog(context: context, builder: (context) => PermissionPopup());
        },
      );
    }

    return CommonBottomSheet(
      title: widget.name,
      titleLeftWidget: isShowAlarm
          ? InkWell(
              onTap: onTapBack,
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
              ),
            )
          : null,
      height: isShowAlarm ? 430 : 220,
      contents: isShowAlarm
          ? AlarmContainer(
              icon: widget.icon,
              title: '${widget.title} 실천 알림',
              desc: '매일 정해진 시간에 실천 알림을 드려요.',
              isEnabled: isEnabled,
              alarmTime: alarmTime,
              onChanged: onChanged,
              onDateTimeChanged: onDateTimeChanged,
              onCompleted: onCompleted,
            )
          : Row(
              children: [
                ExpandedButtonVerti(
                  mainColor: themeColor,
                  icon: Icons.edit,
                  title: '목표 수정',
                  onTap: () {
                    closeDialog(context);
                    widget.onTapEdit();
                  },
                ),
                SpaceWidth(width: tinySpace),
                ExpandedButtonVerti(
                  mainColor: themeColor,
                  icon: Icons.alarm_rounded,
                  title: '시간 알림',
                  onTap: onTapAlarm,
                ),
                SpaceWidth(width: tinySpace),
                ExpandedButtonVerti(
                  mainColor: Colors.red,
                  icon: Icons.delete_forever,
                  title: '목표 삭제',
                  onTap: () {
                    closeDialog(context);
                    widget.onTapRemove(widget.planInfo!);
                  },
                ),
              ],
            ),
    );
  }
}

class PermissionPopup extends StatelessWidget {
  const PermissionPopup({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AlertDialog(
          backgroundColor: dialogBackgroundColor,
          shape: containerBorderRadious,
          title: DialogTitle(
            text: '알림 허용 요청',
            onTap: () => closeDialog(context),
          ),
          content: Column(
            children: [
              ContentsBox(
                contentsWidget: Column(
                  children: ['설정으로 이동하여', '알림을 허용 해주세요.']
                      .map((text) => CommonText(
                            text: text,
                            size: 15,
                            isCenter: true,
                          ))
                      .toList(),
                ),
              ),
              SpaceHeight(height: smallSpace),
              Row(
                children: [
                  CommonButton(
                    text: '설정으로 이동',
                    fontSize: 15,
                    bgColor: themeColor,
                    radious: 10,
                    textColor: Colors.white,
                    onTap: () {
                      openAppSettings();
                      closeDialog(context);
                    },
                  )
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}
