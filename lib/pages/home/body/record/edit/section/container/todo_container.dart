// ignore_for_file: use_build_context_synchronously
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_weight_management/common/widget/CommonButton.dart';
import 'package:flutter_app_weight_management/common/widget/CommonCheckBox.dart';
import 'package:flutter_app_weight_management/common/widget/CommonIcon.dart';
import 'package:flutter_app_weight_management/common/widget/CommonTag.dart';
import 'package:flutter_app_weight_management/common/widget/CommonText.dart';
import 'package:flutter_app_weight_management/components/area/empty_area.dart';
import 'package:flutter_app_weight_management/components/button/expanded_button_verti.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/picker/default_date_time_picker.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/main.dart';
import 'package:flutter_app_weight_management/model/plan_box/plan_box.dart';
import 'package:flutter_app_weight_management/model/record_box/record_box.dart';
import 'package:flutter_app_weight_management/model/user_box/user_box.dart';
import 'package:flutter_app_weight_management/pages/home/body/record/edit/section/container/title_container.dart';
import 'package:flutter_app_weight_management/services/notifi_service.dart';
import 'package:flutter_app_weight_management/utils/class.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:flutter_app_weight_management/utils/variable.dart';
import 'package:flutter_app_weight_management/widgets/alarm_item_widget.dart';
import 'package:flutter_app_weight_management/widgets/alert_dialog_title_widget.dart';
import 'package:flutter_app_weight_management/widgets/dafault_bottom_sheet.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive/hive.dart';
import 'package:permission_handler/permission_handler.dart';

class TodoContainer extends StatefulWidget {
  TodoContainer({
    super.key,
    required this.containerId,
    required this.type,
    required this.color,
    required this.title,
    required this.icon,
    required this.importDateTime,
  });

  String containerId, color, title, type;
  IconData icon;
  DateTime importDateTime;

  @override
  State<TodoContainer> createState() => _TodoContainerState();
}

class _TodoContainerState extends State<TodoContainer> {
  bool isShowInput = false;

  @override
  Widget build(BuildContext context) {
    UserBox user = userRepository.user;
    List<String>? filterList = user.filterList;
    bool? isContainId = filterList?.contains(widget.containerId);

    Box<PlanBox> planBox = planRepository.planBox;
    Box<RecordBox> recordBox = recordRepository.recordBox;
    int recordKey = getDateTimeToInt(widget.importDateTime);
    RecordBox? recordInfo = recordBox.get(recordKey);
    List<Map<String, dynamic>>? actions = recordInfo?.actions;
    List<PlanBox> planList =
        planBox.values.where((element) => element.type == widget.type).toList();
    Color mainColor = tagColors[widget.color]!['textColor']!;

    onCheckBox({required dynamic id, required bool newValue}) async {
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

      // 체크 on
      if (newValue == true) {
        HapticFeedback.mediumImpact();

        if (recordInfo == null) {
          await recordBox.put(
            recordKey,
            RecordBox(
              createDateTime: widget.importDateTime,
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

    onTapTodoComplete({
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

    onTapMoreTodo({required dynamic id}) {
      PlanBox? planInfo = planBox.get(id);

      showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) => TodoModalBottomSheet(
          id: id,
          title: widget.title,
          planBox: planBox,
          planInfo: planInfo,
        ),
      );
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

    onTapRemove() {}

    onTapCollapse() {}

    List<TagClass> tags = [
      TagClass(
        text: '실천율: ${actionPercent()}%',
        color: widget.color,
        onTap: onTapActionPercent,
      ),
      TagClass(
        icon: Icons.keyboard_arrow_down,
        color: widget.color,
        onTap: onTapCollapse,
      )
      // TagClass(
      //   text: '삭제',
      //   color: 'red',
      //   onTap: onTapRemove,
      // ),
    ];

    return isContainId == true
        ? Column(
            children: [
              SpaceHeight(height: smallSpace),
              ContentsBox(
                contentsWidget: Column(
                  children: [
                    TitleContainer(
                      title: widget.title,
                      icon: widget.icon,
                      tags: tags,
                    ),
                    TodoList(
                      actions: actions,
                      mainColor: mainColor,
                      planList: planList,
                      onCheckBox: onCheckBox,
                      onTapMoreTodo: onTapMoreTodo,
                      onTapTodoUpdate: onTapTodoComplete,
                    ),
                    TodoAdd(
                      title: widget.title,
                      mainColor: mainColor,
                      onTapTodoAdd: onTapTodoComplete,
                    ),
                  ],
                ),
              ),
            ],
          )
        : const EmptyArea();
  }
}

// class TodoTitle extends StatelessWidget {
//   TodoTitle({
//     super.key,
//     required this.id,
//     required this.title,
//     required this.icon,
//     required this.color,
//     required this.planBox,
//     required this.planType,
//     required this.recordKey,
//     required this.actions,
//     required this.planList,
//   });

//   Box<PlanBox> planBox;
//   String id, title, color, planType;
//   int recordKey;
//   IconData icon;
//   List<Map<String, dynamic>>? actions;
//   List<PlanBox> planList;

//   @override
//   Widget build(BuildContext context) {
//     Color textColor = tagColors[color]!['textColor']!;

//     actionPercent() {
//       if (actions == null) {
//         return '0.0';
//       }

//       final result = actions!.where((element) {
//         bool isPlanType = planType == element['type'];
//         bool isAction =
//             recordKey == getDateTimeToInt(element['actionDateTime']);
//         bool isShowPlan = planBox.get(element['id']) != null;

//         return isPlanType && isAction && isShowPlan;
//       });

//       return planToActionPercent(
//         a: result.length,
//         b: planList.length,
//       ).toString();
//     }

//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         CommonText(
//           text: title,
//           size: 15,
//           isBold: true,
//           color: Colors.grey.shade600,
//           leftIcon: icon,
//         ),
//         Row(
//           children: [
//             CommonTag(color: color, text: '실천율: ${value()}%'),
//             SpaceWidth(width: tinySpace),
//             CommonTag(color: 'red', text: '삭제')
//           ],
//         )
//       ],
//     );
//   }
// }

class TodoList extends StatelessWidget {
  TodoList({
    super.key,
    required this.actions,
    required this.planList,
    required this.mainColor,
    required this.onCheckBox,
    required this.onTapMoreTodo,
    required this.onTapTodoUpdate,
  });

  Color mainColor;
  List<Map<String, dynamic>>? actions;
  List<PlanBox> planList;
  Function({required dynamic id, required bool newValue}) onCheckBox;
  Function({required dynamic id}) onTapMoreTodo;
  Function({
    required dynamic id,
    required String text,
    required bool newValue,
    String? priority,
    bool? isAlarm,
    DateTime? createDateTime,
    DateTime? alarmTime,
    int? alarmId,
  }) onTapTodoUpdate;

  @override
  Widget build(BuildContext context) {
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

    return Column(
      children: planList
          .map(
            (e) => Padding(
              padding: const EdgeInsets.only(bottom: regularSapce),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonCheckBox(
                    id: e.id,
                    isCheck: action(e.id)['id'] != null,
                    checkColor: mainColor,
                    onTap: onCheckBox,
                  ),
                  TodoName(
                    todo: e,
                    isChcked: action(e.id)['id'] != null,
                    onTapTodoUpdate: onTapTodoUpdate,
                    color: mainColor,
                  ),
                  TodoMore(
                    id: e.id,
                    matinColor: mainColor,
                    actionDateTime: action(e.id)['actionDateTime'],
                    onTapMoreTodo: onTapMoreTodo,
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}

class TodoName extends StatefulWidget {
  TodoName({
    super.key,
    required this.todo,
    required this.isChcked,
    required this.onTapTodoUpdate,
    required this.color,
  });

  PlanBox todo;
  bool isChcked;
  Color color;
  Function({
    required dynamic id,
    required String text,
    required bool newValue,
    String? priority,
    bool? isAlarm,
    DateTime? createDateTime,
    DateTime? alarmTime,
    int? alarmId,
  }) onTapTodoUpdate;

  @override
  State<TodoName> createState() => _TodoNameState();
}

class _TodoNameState extends State<TodoName> {
  TextEditingController textController = TextEditingController();
  bool isShowInput = false;

  @override
  void initState() {
    textController.text = widget.todo.name;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    onTapName() {
      setState(() => isShowInput = true);
    }

    onEditingComplete() {
      setState(() => isShowInput = false);

      if (textController.text != '') {
        widget.onTapTodoUpdate(
          id: widget.todo.id,
          text: textController.text,
          newValue: widget.isChcked,
          createDateTime: widget.todo.createDateTime,
          isAlarm: widget.todo.isAlarm,
          priority: widget.todo.priority,
          alarmTime: widget.todo.alarmTime,
          alarmId: widget.todo.alarmId,
        );
      } else {
        textController.text = widget.todo.name;
      }
    }

    return isShowInput
        ? TodoInput(
            controller: textController,
            onEditingComplete: onEditingComplete,
          )
        : Expanded(
            flex: 4,
            child: GestureDetector(
              onTap: onTapName,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.todo.name,
                    style: TextStyle(
                      fontSize: 15,
                      color: themeColor,
                      decorationColor: widget.color,
                      decoration:
                          widget.isChcked ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  SpaceHeight(height: 3),
                  CommonText(
                    text: widget.todo.isAlarm
                        ? timeToString(widget.todo.alarmTime)
                        : '알림 없음',
                    size: 11,
                    leftIcon: widget.todo.isAlarm
                        ? Icons.alarm
                        : Icons.alarm_off_rounded,
                    color: widget.todo.isAlarm ? themeColor : Colors.grey,
                  ),
                ],
              ),
            ),
          );
  }
}

class TodoMore extends StatelessWidget {
  TodoMore({
    super.key,
    required this.id,
    required this.onTapMoreTodo,
    required this.matinColor,
    this.actionDateTime,
  });

  dynamic id;
  Color matinColor;
  DateTime? actionDateTime;
  Function({required dynamic id}) onTapMoreTodo;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SpaceWidth(width: regularSapce),
        Expanded(
          flex: 0,
          child: InkWell(
            onTap: () => onTapMoreTodo(id: id),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                CommonIcon(
                  icon: Icons.more_horiz,
                  size: 22,
                  color: Colors.grey,
                  onTap: () => onTapMoreTodo(id: id),
                ),
                SpaceHeight(height: 3),
                // CommonText(
                //   text: timeToString(actionDateTime),
                //   size: 11,
                //   color: matinColor,
                //   leftIcon: actionDateTime != null ? Icons.check : null,
                // )
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class TodoAdd extends StatefulWidget {
  TodoAdd({
    super.key,
    required this.title,
    required this.mainColor,
    required this.onTapTodoAdd,
  });

  String title;
  Color mainColor;
  Function({
    required dynamic id,
    required String text,
    required bool newValue,
  }) onTapTodoAdd;

  @override
  State<TodoAdd> createState() => _TodoAddState();
}

class _TodoAddState extends State<TodoAdd> {
  TextEditingController textController = TextEditingController();
  bool isShowInput = false;
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    onTap() {
      setState(() => isShowInput = true);
    }

    onEditingComplete() {
      if (textController.text != '') {
        widget.onTapTodoAdd(
          id: uuid(),
          text: textController.text,
          newValue: isChecked,
        );
      }

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

    return Column(
      children: [
        // SpaceHeight(height: smallSpace),
        InkWell(
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
        ),
      ],
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
      flex: 6,
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
      ),
    );
  }
}

class TodoResult extends StatelessWidget {
  TodoResult({super.key, required this.importDateTime});

  DateTime importDateTime;

  @override
  Widget build(BuildContext context) {
    Box<RecordBox> recordBox = recordRepository.recordBox;
    int recordKey = getDateTimeToInt(importDateTime);
    RecordBox? recordInfo = recordBox.get(recordKey);
    List<Map<String, dynamic>>? actions = recordInfo?.actions;

    renderSvg(String type) => SvgPicture.asset('assets/svgs/check-$type.svg');

    final wSvgPicture = {
      PlanTypeEnum.diet.toString(): renderSvg('diet'),
      PlanTypeEnum.exercise.toString(): renderSvg('exercise'),
      PlanTypeEnum.lifestyle.toString(): renderSvg('life'),
    };

    final todoResultList = actions
        ?.where(
          (action) =>
              getDateTimeToInt(action['actionDateTime']) ==
              getDateTimeToInt(importDateTime),
        )
        .toList();

    todoResultList?.sort(
        (a, b) => planOrder[a['type']]!.compareTo(planOrder[b['type']]!));

    final todoWidgetList = todoResultList
        ?.map((data) => Column(
              children: [
                SpaceHeight(height: smallSpace),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 0,
                      child: wSvgPicture[data['type']] ?? EmptyArea(),
                    ),
                    SpaceWidth(width: smallSpace),
                    Expanded(
                      flex: 5,
                      child: Text(
                        data['name'],
                        style: const TextStyle(fontSize: 13, color: themeColor),
                      ),
                    ),
                    SpaceWidth(width: largeSpace),
                    Expanded(
                      flex: 0,
                      child: Text(
                        timeToString(data['actionDateTime']),
                        style: TextStyle(
                          fontSize: 10,
                          color: planTypeColors[data['type']],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ))
        .toList();

    return Column(children: todoWidgetList ?? []);
  }
}

class TodoModalBottomSheet extends StatefulWidget {
  TodoModalBottomSheet({
    super.key,
    required this.id,
    required this.title,
    required this.planBox,
    required this.planInfo,
  });

  String id, title;
  Box<PlanBox> planBox;
  PlanBox? planInfo;

  @override
  State<TodoModalBottomSheet> createState() => _TodoModalBottomSheetState();
}

class _TodoModalBottomSheetState extends State<TodoModalBottomSheet> {
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

    onTapRemove() {
      if (widget.planInfo?.alarmId != null) {
        NotificationService().deleteAlarm(widget.planInfo!.alarmId!);
      }

      widget.planBox.delete(widget.id);
      closeDialog(context);
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
          showDialog(
            context: context,
            builder: (context) => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AlertDialog(
                  backgroundColor: dialogBackgroundColor,
                  shape: containerBorderRadious,
                  title: AlertDialogTitleWidget(
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
            ),
          );
        },
      );
    }

    onTapChangeName() {
      //
    }

    return DefaultBottomSheet(
      title: '${widget.title} 설정',
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
          ? ContentsBox(
              backgroundColor: Colors.white,
              contentsWidget: Column(
                children: [
                  AlarmRow(
                    title: '실천 알림',
                    iconBackgroundColor: dialogBackgroundColor,
                    desc: '매일 정해진 시간에 실천 알림을 드려요.',
                    isEnabled: isEnabled,
                    onChanged: onChanged,
                  ),
                  isEnabled
                      ? Column(
                          children: [
                            DefaultTimePicker(
                              initialDateTime: alarmTime,
                              mode: CupertinoDatePickerMode.time,
                              onDateTimeChanged: onDateTimeChanged,
                            ),
                            Row(
                              children: [
                                CommonButton(
                                  text: '완료',
                                  fontSize: 13,
                                  bgColor: themeColor,
                                  radious: 10,
                                  textColor: Colors.white,
                                  onTap: onCompleted,
                                  isBold: true,
                                ),
                              ],
                            )
                          ],
                        )
                      : const EmptyArea()
                ],
              ),
            )
          : Column(
              children: [
                Row(
                  children: [
                    ExpandedButtonVerti(
                      mainColor: themeColor,
                      icon: Icons.edit,
                      title: '${widget.title} 수정',
                      onTap: onTapChangeName,
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
                      title: '${widget.title} 삭제',
                      onTap: onTapRemove,
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}
