// ignore_for_file: use_build_context_synchronously, avoid_function_literals_in_foreach_calls
import 'dart:developer';
import 'dart:ui';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app_weight_management/common/CommonBottomSheet.dart';
import 'package:flutter_app_weight_management/common/CommonButton.dart';
import 'package:flutter_app_weight_management/common/CommonCheckBox.dart';
import 'package:flutter_app_weight_management/common/CommonIcon.dart';
import 'package:flutter_app_weight_management/common/CommonText.dart';
import 'package:flutter_app_weight_management/components/area/empty_area.dart';
import 'package:flutter_app_weight_management/components/button/bottom_submit_button.dart';
import 'package:flutter_app_weight_management/components/button/expanded_button_hori.dart';
import 'package:flutter_app_weight_management/components/button/expanded_button_verti.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/segmented/default_segmented.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/main.dart';
import 'package:flutter_app_weight_management/model/plan_box/plan_box.dart';
import 'package:flutter_app_weight_management/model/record_box/record_box.dart';
import 'package:flutter_app_weight_management/model/user_box/user_box.dart';
import 'package:flutter_app_weight_management/pages/common/goal_chart_page.dart';
import 'package:flutter_app_weight_management/pages/home/body/record/edit/container/alarm_container.dart';
import 'package:flutter_app_weight_management/pages/home/body/record/edit/container/title_container.dart';
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
import 'package:table_calendar/table_calendar.dart';

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
          title: planNotifyTitle.tr(),
          body: planNotifyBody.tr(
            namedArgs: {'title': widget.title.tr(), "body": text},
          ),
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
      DateTime? dietExerciseRecordDateTime,
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
        dietExerciseRecordDateTime: dietExerciseRecordDateTime,
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

    onTapOpen() {
      isOpen
          ? user.filterList?.remove(widget.filterId)
          : user.filterList?.add(widget.filterId);
      user.save();
    }

    return isDisplay
        ? Column(
            children: [
              ContentsBox(
                contentsWidget: Column(
                  children: [
                    isLife
                        ? LifeContainer(
                            icon: widget.icon,
                            colorName: widget.color,
                            actionPercent: actionPercent(),
                            type: widget.type,
                            isOpen: isOpen,
                            title: widget.title,
                            actions: actions,
                            mainColor: mainColor,
                            planList: planList,
                            onCheckBox: onCheckBox,
                            onGoalComplete: onGoalComplete,
                            onTapOpen: onTapOpen,
                          )
                        : DietExerciseContainer(
                            title: widget.title,
                            colorName: widget.color,
                            icon: widget.icon,
                            type: widget.type,
                            isOpen: isOpen,
                            bgColor: bgColor,
                            actions: actions,
                            mainColor: mainColor,
                            planList: planList,
                            onCheckBox: onCheckBox,
                            onGoalComplete: onGoalComplete,
                            onRecordComplete: onRecordComplete,
                            onTapOpen: onTapOpen,
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
    required this.title,
    required this.colorName,
    required this.icon,
    required this.type,
    required this.isOpen,
    required this.bgColor,
    required this.actions,
    required this.mainColor,
    required this.planList,
    required this.onCheckBox,
    required this.onGoalComplete,
    required this.onRecordComplete,
    required this.onTapOpen,
  });

  String title, type, colorName;
  bool isOpen;
  Color bgColor;
  List<Map<String, dynamic>>? actions;
  Color mainColor;
  List<PlanBox> planList;
  IconData icon;
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
    DateTime? dietExerciseRecordDateTime,
  }) onRecordComplete;
  Function() onTapOpen;

  @override
  State<DietExerciseContainer> createState() => _DietExerciseContainerState();
}

class _DietExerciseContainerState extends State<DietExerciseContainer> {
  SegmentedTypes selectedSegment = SegmentedTypes.record;

  @override
  Widget build(BuildContext context) {
    onTapChangeOrder() {
      showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return ChangeOrderBottomSheet(
            title: widget.title,
            planList: widget.planList,
            type: widget.type,
          );
        },
      );
    }

    onHide(SegmentedTypes hideType) {
      return widget.isOpen == false ? true : selectedSegment == hideType;
    }

    onTapRecordCollection() async {
      await Navigator.pushNamed(
        context,
        '/todo-chart-page',
        arguments: {'type': widget.type, 'title': widget.title},
      );
    }

    onTapGoalCollection() async {
      await Navigator.pushNamed(
        context,
        '/goal-chart-page',
        arguments: {'type': widget.type, 'title': widget.title},
      );
    }

    List<TagClass> tags = [
      TagClass(
        text: '기록 모아보기',
        color: widget.colorName,
        isHide: onHide(SegmentedTypes.goal),
        onTap: onTapRecordCollection,
      ),
      TagClass(
        text: '실천 모아보기',
        color: widget.colorName,
        isHide: onHide(SegmentedTypes.record),
        onTap: onTapGoalCollection,
      ),
      TagClass(
        text: '순서 변경',
        color: widget.colorName,
        isHide: onHide(SegmentedTypes.record),
        onTap: onTapChangeOrder,
      ),
      TagClass(
        text: '기록 개',
        nameArgs: {
          "length": "${onActionList(
                actions: widget.actions,
                type: widget.type,
                onRecordUpdate: widget.onRecordComplete,
              )?.length ?? 0}"
        },
        color: widget.colorName,
        isHide: widget.isOpen,
        onTap: widget.onTapOpen,
      ),
      TagClass(
        text: '목표 개',
        nameArgs: {"length": "${widget.planList.length}"},
        color: widget.colorName,
        isHide: widget.isOpen,
        onTap: widget.onTapOpen,
      ),
      TagClass(
        icon: widget.isOpen
            ? Icons.keyboard_arrow_down_rounded
            : Icons.keyboard_arrow_right_rounded,
        color: widget.colorName,
        onTap: widget.onTapOpen,
      )
    ];

    onSegmentedChanged(SegmentedTypes? segmented) {
      setState(() => selectedSegment = segmented!);
    }

    bool isRecord = selectedSegment == SegmentedTypes.record;
    List<Widget>? actionList = onActionList(
      actions: widget.actions,
      type: widget.type,
      onRecordUpdate: widget.onRecordComplete,
    );

    Map<SegmentedTypes, Widget> children = {
      SegmentedTypes.record: onSegmentedWidget(
        title: '기록 ',
        nameArgs: {'length': '${actionList?.length ?? 0}'},
        type: SegmentedTypes.record,
        selected: selectedSegment,
      ),
      SegmentedTypes.goal: onSegmentedWidget(
        title: '목표 ',
        nameArgs: {'length': '${widget.planList.length}'},
        type: SegmentedTypes.goal,
        selected: selectedSegment,
      ),
    };

    return Column(
      children: [
        TitleContainer(
          isDivider: widget.isOpen,
          title: widget.title,
          icon: widget.icon,
          tags: tags,
          onTap: widget.onTapOpen,
        ),
        widget.isOpen
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
            : const EmptyArea()
      ],
    );
  }
}

class ChangeOrderBottomSheet extends StatefulWidget {
  ChangeOrderBottomSheet({
    super.key,
    required this.type,
    required this.title,
    required this.planList,
  });

  List<PlanBox> planList;
  String title, type;

  @override
  State<ChangeOrderBottomSheet> createState() => _ChangeOrderBottomSheetState();
}

class _ChangeOrderBottomSheetState extends State<ChangeOrderBottomSheet> {
  @override
  Widget build(BuildContext context) {
    UserBox user = userRepository.user;
    List<String>? orderList = {
      eDiet: user.dietOrderList,
      eExercise: user.exerciseOrderList,
      eLife: user.lifeOrderList,
    }[widget.type]!;

    widget.planList.sort((itemA, itemB) {
      int indexA = orderList.indexOf(itemA.id);
      int indexB = orderList.indexOf(itemB.id);

      return indexA.compareTo(indexB);
    });

    Widget planItem(index) {
      return Padding(
        key: Key(widget.planList[index].id),
        padding: const EdgeInsets.only(bottom: 10),
        child: Row(
          children: [
            GoalName(
              moreIcon: Icons.drag_indicator_rounded,
              planInfo: widget.planList[index],
              isChcked: false,
              actionCount: onActionCount(
                recordRepository.recordList,
                widget.planList[index].id,
              ),
              color: themeColor,
              onTapMore: () {},
            ),
          ],
        ),
      );
    }

    Widget proxyDecorator(
      Widget child,
      int index,
      Animation<double> animation,
    ) {
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
              child: planItem(index),
            ),
          );
        },
        child: child,
      );
    }

    onReorder(int oldIndex, int newIndex) {
      String oldId = widget.planList[oldIndex].id;
      String targetId = uuid();

      orderList[oldIndex] = targetId;
      orderList.insert(newIndex, oldId);
      orderList.remove(targetId);

      user.save();
      setState(() {});
    }

    return CommonBottomSheet(
      title: ' 목표'.tr(namedArgs: {'type': widget.title.tr()}),
      height: 530,
      contents: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CommonIcon(
                icon: Icons.drag_indicator,
                size: 14,
                color: themeColor,
              ),
              CommonText(
                text: '버튼으로 순서를 변경해보세요',
                size: 12,
                isBold: true,
              ),
            ],
          ),
          SpaceHeight(height: 10),
          ContentsBox(
              height: 390,
              contentsWidget: ReorderableListView(
                shrinkWrap: true,
                proxyDecorator: proxyDecorator,
                onReorder: onReorder,
                children: List.generate(
                  widget.planList.length,
                  (int index) => planItem(index),
                ),
              )),
        ],
      ),
    );
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
    required this.dietExerciseRecordDateTime,
  });

  String type, id, name, title, topTitle;
  DateTime actionDateTime;
  DateTime? dietExerciseRecordDateTime;
  Function({
    required String completedType,
    required String id,
    required String name,
    required DateTime actionDateTime,
    required String title,
    DateTime? dietExerciseRecordDateTime,
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
    UserBox user = userRepository.user;
    DateTime importDateTime =
        context.watch<ImportDateTimeProvider>().getImportDateTime();
    Box<RecordBox> recordBox = recordRepository.recordBox;
    int recordKey = getDateTimeToInt(importDateTime);
    RecordBox? recordInfo = recordBox.get(recordKey);

    onTapEdit() {
      textController.text = widget.name;
      setState(() => isShowInput = true);
    }

    onEditTitle(String selectedTitle) async {
      log(selectedTitle);
      recordInfo?.actions?.forEach(
        (action) {
          if (action['id'] == widget.id) {
            action['title'] = selectedTitle;
          }
        },
      );

      await recordInfo?.save();
    }

    onEditDietExerciseRecordDateTime(DateTime dateTime) async {
      recordInfo?.actions?.forEach(
        (action) {
          if (action['id'] == widget.id) {
            action['dietExerciseRecordDateTime'] = dateTime;
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
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return RecordBottomSheet(
            selectedTitle: widget.title,
            type: widget.type,
            id: widget.id,
            name: widget.name,
            topTitle: widget.topTitle,
            dietExerciseRecordDateTime: widget.dietExerciseRecordDateTime,
            onTapEdit: onTapEdit,
            onEditTitle: onEditTitle,
            onEditDietExerciseRecordDateTime: onEditDietExerciseRecordDateTime,
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
          dietExerciseRecordDateTime: widget.dietExerciseRecordDateTime,
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
                    onTap: onTapMore,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.name,
                          style: const TextStyle(
                            color: themeColor,
                            fontSize: 15,
                          ),
                        ),
                        SpaceHeight(height: 3),
                        Row(
                          children: [
                            CommonText(
                              text:
                                  '${widget.title.tr()}${widget.dietExerciseRecordDateTime != null ? ', ${hm(locale: context.locale.toString(), dateTime: widget.dietExerciseRecordDateTime!)}' : ''}',
                              size: 11,
                              color: Colors.grey,
                            ),
                          ],
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
              title: Text(
                '삭제할까요?'.tr(),
                style: const TextStyle(fontSize: 18, color: themeColor),
              ),
              content: Row(
                children: [
                  ExpandedButtonHori(
                    padding: const EdgeInsets.all(12),
                    imgUrl: 'assets/images/t-11.png',
                    text: '닫기',
                    onTap: () => Navigator.of(context).pop(false),
                  ),
                  SpaceWidth(width: tinySpace),
                  ExpandedButtonHori(
                    padding: const EdgeInsets.all(12),
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
    DateTime? dietExerciseRecordDateTime,
  }) onRecordAdd;

  @override
  State<RecordAdd> createState() => _RecordAddState();
}

class _RecordAddState extends State<RecordAdd> {
  TextEditingController textController = TextEditingController();
  bool isShowInput = false;

  @override
  Widget build(BuildContext context) {
    onAdd() {
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
          isScrollControlled: true,
          context: context,
          builder: (context) {
            DateTime importDateTime =
                context.watch<ImportDateTimeProvider>().getImportDateTime();

            List<String> timeStamps = [
              ampmFormat(DateTime.now().hour),
              hourTo12[DateTime.now().hour]!,
              '00'
            ];

            return StatefulBuilder(
              builder: (
                BuildContext context,
                void Function(void Function()) setState,
              ) {
                UserBox? user = userRepository.user;

                onAmpm(String ampm) {
                  setState(() => timeStamps[0] = ampm);
                }

                onHours(String hour) {
                  setState(() => timeStamps[1] = hour);
                }

                onMinutes(String minute) {
                  setState(() => timeStamps[2] = minute);
                }

                onChangedSwitch(bool isChecked) {
                  user.isDietExerciseRecordDateTime = isChecked;

                  user.save();
                  setState(() {});
                }

                onTapItem(String title) {
                  DateTime createRecordDateTime = DateTime(
                    importDateTime.year,
                    importDateTime.month,
                    importDateTime.day,
                    hourTo24(ampm: timeStamps[0], hour: timeStamps[1]),
                    minuteToInt(minute: timeStamps[2]),
                  );

                  widget.onRecordAdd(
                    completedType: '추가',
                    id: uuid(),
                    title: title,
                    name: name,
                    actionDateTime: importDateTime,
                    dietExerciseRecordDateTime:
                        (user.isDietExerciseRecordDateTime == true
                            ? createRecordDateTime
                            : null),
                  );
                }

                return CategoryBottomSheet(
                  type: widget.type,
                  timeStamps: timeStamps,
                  name: name,
                  selectedTitle: '',
                  onAmpm: onAmpm,
                  onHours: onHours,
                  onMinutes: onMinutes,
                  onChangedSwitch: onChangedSwitch,
                  onTitle: onTapItem,
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
            onTap: onAdd,
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
    required this.timeStamps,
    required this.selectedTitle,
    required this.onTitle,
    required this.onAmpm,
    required this.onHours,
    required this.onMinutes,
    required this.onChangedSwitch,
  });

  String type, name, selectedTitle;
  List<String> timeStamps;
  Function(String) onAmpm, onHours, onMinutes, onTitle;
  Function(bool) onChangedSwitch;

  @override
  Widget build(BuildContext context) {
    UserBox user = userRepository.user;

    return CommonBottomSheet(
      title: name,
      height: user.isDietExerciseRecordDateTime == true ? 555 : 265,
      contents: Column(
        children: [
          RecordDateTime(
            isTitle: true,
            isShowContents: user.isDietExerciseRecordDateTime == true,
            timeStamps: timeStamps,
            onAmpm: onAmpm,
            onHours: onHours,
            onMinutes: onMinutes,
            onChangedSwitch: onChangedSwitch,
          ),
          SpaceHeight(height: 10),
          CategoryList(
            type: type,
            selectedTitle: selectedTitle,
            onTitle: onTitle,
          ),
        ],
      ),
    );
  }
}

class CategoryList extends StatelessWidget {
  CategoryList({
    super.key,
    required this.type,
    required this.onTitle,
    required this.selectedTitle,
  });

  String type, selectedTitle;
  DateTime? dietExerciseRecordDateTime;
  Function(String title) onTitle;

  @override
  Widget build(BuildContext context) {
    return Row(
        children: category[type]!
            .map(
              (item) => Expanded(
                child: Row(
                  children: [
                    ExpandedButtonVerti(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 10),
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
                        onTitle(item['title']);
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

class RecordDateTime extends StatelessWidget {
  RecordDateTime({
    super.key,
    required this.isTitle,
    required this.isShowContents,
    required this.timeStamps,
    required this.onAmpm,
    required this.onHours,
    required this.onMinutes,
    required this.onChangedSwitch,
  });

  bool isTitle, isShowContents;
  List<String> timeStamps;
  Function(String) onAmpm, onHours, onMinutes;
  Function(bool) onChangedSwitch;

  @override
  Widget build(BuildContext context) {
    UserBox user = userRepository.user;

    onCommButton({
      required String type,
      required String state,
      required String text,
      required Function(String) onTap,
      bool? isLast,
    }) {
      return Expanded(
        flex: 1,
        child: Row(
          children: [
            CommonButton(
              text: type == 'ampm' ? text.tr() : text,
              fontSize: 12,
              textColor: state == text ? Colors.white : Colors.grey,
              bgColor: state == text ? themeColor : Colors.grey.shade50,
              isBold: state == text,
              radious: 7,
              isNotTr: true,
              onTap: () => onTap(text),
            ),
            SpaceWidth(width: isLast == true ? 0 : 5)
          ],
        ),
      );
    }

    List<Widget> ampmInfo = ['오전', '오후']
        .map((text) => onCommButton(
              type: 'ampm',
              text: text,
              isLast: text == '오후',
              state: timeStamps[0],
              onTap: onAmpm,
            ))
        .toList();
    List<List<Widget>> hoursInfo = [
      ["1", "2", "3", "4", "5", "6"]
          .map((text) => onCommButton(
                type: 'hour',
                text: text,
                isLast: text == '6',
                state: timeStamps[1],
                onTap: onHours,
              ))
          .toList(),
      ["7", "8", "9", "10", "11", "12"]
          .map((text) => onCommButton(
                type: 'hour',
                text: text,
                isLast: text == '12',
                state: timeStamps[1],
                onTap: onHours,
              ))
          .toList(),
    ];
    List<List<Widget>> minutesInfo = [
      ["00", "05", "10", "15", "20", "25"]
          .map((text) => onCommButton(
                type: 'minute',
                text: text,
                isLast: text == '25',
                state: timeStamps[2],
                onTap: onMinutes,
              ))
          .toList(),
      ["30", "35", "40", "45", "50", "55"]
          .map((text) => onCommButton(
                type: 'minute',
                text: text,
                isLast: text == '55',
                state: timeStamps[2],
                onTap: onMinutes,
              ))
          .toList()
    ];

    Map<String, Flex> wObj = {
      "오전/오후": Row(children: ampmInfo),
      "시": Column(
        children: [
          Row(children: hoursInfo[0]),
          SpaceHeight(height: 5),
          Row(children: hoursInfo[1]),
        ],
      ),
      "분": Column(
        children: [
          Row(children: minutesInfo[0]),
          SpaceHeight(height: 5),
          Row(children: minutesInfo[1]),
        ],
      ),
    };

    rowItem({required String title}) {
      return wObj[title]!;
    }

    rowTitle() {
      return Padding(
        padding: EdgeInsets.only(bottom: isShowContents ? 20 : 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonText(text: '시간도 기록 할까요?', size: 12, isBold: true),
                SpaceHeight(height: 2),
                CommonText(
                  text: '오전/오후, 시, 분 버튼으로 기록해요',
                  size: 10,
                  color: Colors.grey,
                ),
              ],
            ),
            CupertinoSwitch(
              value: user.isDietExerciseRecordDateTime == true,
              activeColor: themeColor,
              onChanged: onChangedSwitch,
            )
          ],
        ),
      );
    }

    return ContentsBox(
      contentsWidget: Column(
        children: [
          isTitle ? rowTitle() : const EmptyArea(),
          isShowContents == true
              ? Column(
                  children: [
                    rowItem(title: '오전/오후'),
                    SpaceHeight(height: 25),
                    rowItem(title: '시'),
                    SpaceHeight(height: 25),
                    rowItem(title: '분'),
                  ],
                )
              : const EmptyArea(),
        ],
      ),
    );
  }
}

class LifeContainer extends StatelessWidget {
  LifeContainer({
    super.key,
    required this.colorName,
    required this.icon,
    required this.actionPercent,
    required this.type,
    required this.isOpen,
    required this.title,
    required this.actions,
    required this.mainColor,
    required this.planList,
    required this.onCheckBox,
    required this.onGoalComplete,
    required this.onTapOpen,
  });

  String type, title, colorName, actionPercent;
  bool isOpen;
  List<Map<String, dynamic>>? actions;
  Color mainColor;
  List<PlanBox> planList;
  IconData icon;
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
  Function() onTapOpen;

  @override
  Widget build(BuildContext context) {
    onTapChangeOrder() {
      showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) => ChangeOrderBottomSheet(
          type: type,
          title: title,
          planList: planList,
        ),
      );
    }

    onTapGoalCollection() async {
      await Navigator.pushNamed(
        context,
        '/goal-chart-page',
        arguments: {'type': type, 'title': title},
      );
    }

    List<TagClass> lifeTags = [
      TagClass(
        text: '습관 개',
        nameArgs: {'length': '${planList.length}'},
        color: colorName,
        isHide: isOpen,
        onTap: onTapOpen,
      ),
      TagClass(
        text: '실천 모아보기',
        color: colorName,
        onTap: onTapGoalCollection,
      ),
      TagClass(
        text: '순서 변경',
        isHide: !isOpen,
        color: colorName,
        onTap: onTapChangeOrder,
      ),
      TagClass(
        icon: isOpen
            ? Icons.keyboard_arrow_down_rounded
            : Icons.keyboard_arrow_right_rounded,
        color: colorName,
        onTap: onTapOpen,
      ),
    ];

    return Column(
      children: [
        TitleContainer(
          isDivider: isOpen,
          title: title,
          icon: icon,
          tags: lifeTags,
          onTap: onTapOpen,
        ),
        isOpen
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
            : const EmptyArea()
      ],
    );
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
    }[type];

    onTapRemove(PlanBox planInfo) async {
      if (planInfo.alarmId != null) {
        NotificationService().deleteAlarm(planInfo.alarmId!);
      }

      planRepository.planBox.delete(planInfo.id);
      orderList?.remove(planInfo.id);

      if (planList.length < 2) {
        if (type == eDiet) {
          user.dietOrderList = [];
        } else if (type == eExercise) {
          user.exerciseOrderList = [];
        } else if (type == eLife) {
          user.lifeOrderList = [];
        }
      }

      user.save();
    }

    action(String planId) {
      if (actions == null) {
        return {'id': null, 'actionDateTime': null};
      }

      Map<String, dynamic> action = actions!.firstWhere(
        (element) => element['id'] == planId,
        orElse: () => {'id': null, 'actionDateTime': null},
      );

      return action;
    }

    planList.sort((itemA, itemB) {
      int indexA = orderList?.indexOf(itemA.id) ?? 0;
      int indexB = orderList?.indexOf(itemB.id) ?? 0;

      return indexA.compareTo(indexB);
    });

    planList.sort((itemA, itemB) {
      bool isCheckedA = action(itemA.id)['id'] != null;
      bool isCheckedB = action(itemB.id)['id'] != null;

      return (isCheckedA == isCheckedB ? 0 : (isCheckedB ? 1 : -1));
    });

    return Column(
      children: planList
          .map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Dismiss(
                id: item.id,
                onDismiss: () => onTapRemove(item),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonCheckBox(
                      id: item.id,
                      isCheck: action(item.id)['id'] != null,
                      checkColor: mainColor,
                      onTap: onCheckBox,
                    ),
                    GoalItem(
                      type: type,
                      planInfo: item,
                      color: mainColor,
                      isChcked: action(item.id)['id'] != null,
                      onGoalUpdate: onGoalUpdate,
                      onTapRemove: onTapRemove,
                    ),
                  ],
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

class GoalItem extends StatefulWidget {
  GoalItem({
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
  State<GoalItem> createState() => _GoalItemState();
}

class _GoalItemState extends State<GoalItem> {
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
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
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

    return isShowInput
        ? TodoInput(
            controller: textController,
            onEditingComplete: onEditingComplete,
          )
        : GoalName(
            color: widget.color,
            moreIcon: Icons.more_horiz,
            planInfo: widget.planInfo,
            isChcked: widget.isChcked,
            actionCount: onActionCount(
              recordRepository.recordList,
              widget.planInfo.id,
            ),
            onTapMore: onTapMore,
          );
  }
}

class GoalName extends StatelessWidget {
  GoalName({
    super.key,
    required this.moreIcon,
    required this.planInfo,
    required this.isChcked,
    required this.actionCount,
    required this.color,
    required this.onTapMore,
  });

  IconData moreIcon;
  PlanBox planInfo;
  bool isChcked;
  int actionCount;
  Color color;
  Function() onTapMore;

  @override
  Widget build(BuildContext context) {
    DateTime importDateTime =
        context.watch<ImportDateTimeProvider>().getImportDateTime();

    return Expanded(
      child: InkWell(
        onTap: onTapMore,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      planInfo.name,
                      style: TextStyle(
                        fontSize: 15,
                        color: themeColor,
                        decorationColor: color,
                        decorationThickness: 1,
                        decoration:
                            isChcked ? TextDecoration.lineThrough : null,
                      ),
                    ),
                  ),
                  SpaceHeight(height: 3),
                  Row(
                    children: [
                      planInfo.isAlarm && planInfo.alarmTime != null
                          ? CommonText(
                              text: '알림, ',
                              nameArgs: {
                                'time': hm(
                                  dateTime: planInfo.alarmTime!,
                                  locale: context.locale.toString(),
                                )
                              },
                              size: 11,
                              color: Colors.grey,
                            )
                          : const EmptyArea(),
                      CommonText(
                        text: weekAndMonthActionCount(
                          importDateTime: importDateTime,
                          recordBox: recordRepository.recordBox,
                          type: planInfo.type,
                          planId: planInfo.id,
                        ),
                        size: 11,
                        color: Colors.grey,
                        isNotTr: true,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SpaceWidth(width: regularSapce),
            CommonIcon(
              icon: moreIcon,
              size: 22,
              color: Colors.grey,
              onTap: onTapMore,
            ),
          ],
        ),
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
      if (textController.text != '') {
        String id = uuid();

        widget.onTapGoalAdd(
          completedType: '추가',
          id: id,
          text: textController.text,
          newValue: isChecked,
        );

        orderList.add(id);
      }

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
    required this.dietExerciseRecordDateTime,
    required this.onTapEdit,
    required this.onEditTitle,
    required this.onEditDietExerciseRecordDateTime,
    required this.onTapRemove,
  });

  String type, id, name, topTitle, selectedTitle;
  DateTime? dietExerciseRecordDateTime;
  Function(String title) onEditTitle;
  Function(DateTime) onEditDietExerciseRecordDateTime;
  Function() onTapEdit;
  Function() onTapRemove;

  @override
  State<RecordBottomSheet> createState() => _RecordBottomSheetState();
}

class _RecordBottomSheetState extends State<RecordBottomSheet> {
  List<String> timeStamps = ['', '', ''];
  String selectedWidget = 'default';

  @override
  void initState() {
    if (widget.dietExerciseRecordDateTime != null) {
      DateTime dateTime = widget.dietExerciseRecordDateTime!;

      timeStamps[0] = ampmFormat(dateTime.hour);
      timeStamps[1] = hourTo12[dateTime.hour]!;
      timeStamps[2] = minuteTo5Min(min: dateTime.minute);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DateTime importDateTime =
        context.watch<ImportDateTimeProvider>().getImportDateTime();
    bool isCompleted =
        timeStamps[0] != '' && timeStamps[1] != '' && timeStamps[2] != '';

    final widgetObj = {
      'default': {
        'height': 305.0,
        'contents': Column(
          children: [
            Row(
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
                SpaceWidth(width: 7),
                ExpandedButtonVerti(
                  mainColor: themeColor,
                  icon: Icons.category,
                  title: '분류 변경',
                  onTap: () {
                    setState(() => selectedWidget = 'category');
                  },
                ),
              ],
            ),
            SpaceHeight(height: 7),
            Row(
              children: [
                ExpandedButtonVerti(
                  mainColor: themeColor,
                  icon: Icons.alarm_on_rounded,
                  title: '기록 시간',
                  onTap: () {
                    setState(() => selectedWidget = 'timeSetting');
                  },
                ),
                SpaceWidth(width: 7),
                ExpandedButtonVerti(
                  mainColor: Colors.red,
                  icon: Icons.delete_forever,
                  title: '${widget.topTitle} 삭제',
                  onTap: () {
                    closeDialog(context);
                    widget.onTapRemove();
                  },
                ),
              ],
            )
          ],
        ),
      },
      'category': {
        'height': 180.0,
        'contents': CategoryList(
          selectedTitle: widget.selectedTitle,
          type: widget.type,
          onTitle: widget.onEditTitle,
        ),
      },
      'timeSetting': {
        'height': 445.0,
        'contents': Column(
          children: [
            RecordDateTime(
              isTitle: false,
              isShowContents: true,
              timeStamps: timeStamps,
              onAmpm: (String ampm) {
                setState(() => timeStamps[0] = ampm);
              },
              onHours: (String hour) {
                setState(() => timeStamps[1] = hour);
              },
              onMinutes: (String minute) {
                setState(() => timeStamps[2] = minute);
              },
              onChangedSwitch: (_) => null,
            ),
            SpaceHeight(height: 10),
            Row(
              children: [
                Expanded(
                  child: BottomSubmitButton(
                    padding: const EdgeInsets.all(0),
                    isEnabled: isCompleted,
                    text: '완료'.tr(),
                    onPressed: () {
                      if (isCompleted) {
                        DateTime dateTime = DateTime(
                          importDateTime.year,
                          importDateTime.month,
                          importDateTime.day,
                          hourTo24(ampm: timeStamps[0], hour: timeStamps[1]),
                          minuteToInt(minute: timeStamps[2]),
                        );
                        widget.onEditDietExerciseRecordDateTime(dateTime);
                        closeDialog(context);
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      },
    };

    return CommonBottomSheet(
      title: widget.name,
      height: widgetObj[selectedWidget]!['height'] as double,
      contents: widgetObj[selectedWidget]!['contents'] as Widget,
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
  DateTime selectedMonth = DateTime.now();

  @override
  void initState() {
    isEnabled = widget.planInfo?.isAlarm ?? true;
    alarmTime = widget.planInfo?.alarmTime ?? DateTime.now();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String locale = context.locale.toString();

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
          title: planNotifyTitle.tr(),
          body: planNotifyBody.tr(
            namedArgs: {
              'title': widget.title.tr(),
              "body": widget.planInfo?.name ?? ''
            },
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
          showDialog(
            context: context,
            builder: (context) => const PermissionPopup(),
          );
        },
      );
    }

    onPageChanged(DateTime dateTime) {
      setState(() => selectedMonth = dateTime);
    }

    markerBuilder(context, DateTime dateTime, focusedDay) {
      int recordKey = getDateTimeToInt(dateTime);
      RecordBox? record = recordRepository.recordBox.get(recordKey);
      List<Map<String, dynamic>> actions = record?.actions ?? [];
      bool isAction = actions.any(
        (action) =>
            action['id'] == widget.id &&
            action['type'] == widget.type &&
            action['isRecord'] != true,
      );

      if (isAction == false) {
        return null;
      }

      return Center(
        child: Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: categoryColors[widget.type]!.shade100,
            borderRadius: BorderRadius.circular(100),
          ),
          child: CommonText(
            text: '${dateTime.day}',
            size: 12,
            isCenter: true,
            color: Colors.white,
            isBold: true,
            isNotTop: true,
            isNotTr: true,
          ),
        ),
      );
    }

    return CommonBottomSheet(
      title: widget.name,
      titleLeftWidget: isShowAlarm
          ? InkWell(
              onTap: onTapBack,
              child: const Icon(Icons.arrow_back_ios_new_rounded),
            )
          : null,
      height: isShowAlarm ? 430 : 630,
      contents: isShowAlarm
          ? AlarmContainer(
              icon: widget.icon,
              title: '실천 알림',
              nameArgs: {'type': widget.title.tr()},
              desc: '매일 실천 알림을 드려요.',
              isEnabled: isEnabled,
              alarmTime: alarmTime,
              onChanged: onChanged,
              onDateTimeChanged: onDateTimeChanged,
              onCompleted: onCompleted,
            )
          : Column(
              children: [
                ContentsBox(
                  contentsWidget: Column(
                    children: [
                      TableCalendarHeader(
                        locale: locale,
                        selectedMonth: selectedMonth,
                        text: '실천'.tr(),
                        leftIcon: Icons.circle,
                        textColor: categoryColors[widget.type]!,
                        iconColor: categoryColors[widget.type]!.shade100,
                      ),
                      TableCalendar(
                        locale: locale,
                        headerVisible: false,
                        firstDay: DateTime(2000, 1, 1),
                        lastDay: DateTime.now(),
                        calendarStyle: const CalendarStyle(
                          todayDecoration:
                              BoxDecoration(color: Colors.transparent),
                          todayTextStyle: TextStyle(color: Colors.black),
                        ),
                        calendarBuilders: CalendarBuilders(
                          markerBuilder: markerBuilder,
                        ),
                        focusedDay: selectedMonth,
                        onPageChanged: onPageChanged,
                      ),
                    ],
                  ),
                ),
                SpaceHeight(height: 10),
                Row(
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
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 10),
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
