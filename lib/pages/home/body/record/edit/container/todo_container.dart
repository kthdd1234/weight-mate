// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_weight_management/common/CommonBottomSheet.dart';
import 'package:flutter_app_weight_management/common/CommonButton.dart';
import 'package:flutter_app_weight_management/common/CommonCheckBox.dart';
import 'package:flutter_app_weight_management/common/CommonIcon.dart';
import 'package:flutter_app_weight_management/common/CommonText.dart';
import 'package:flutter_app_weight_management/components/area/empty_area.dart';
import 'package:flutter_app_weight_management/components/button/expanded_button_verti.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/dialog/native_ad_dialog.dart';
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
import 'package:hive/hive.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

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
    bool? isOpen = user.filterList?.contains(widget.filterId) == true;

    Box<PlanBox> planBox = planRepository.planBox;
    Box<RecordBox> recordBox = recordRepository.recordBox;
    int recordKey = getDateTimeToInt(importDateTime);
    RecordBox? recordInfo = recordBox.get(recordKey);
    List<Map<String, dynamic>>? actions = recordInfo?.actions;
    List<PlanBox> planList =
        planBox.values.where((element) => element.type == widget.type).toList();
    Color mainColor = tagColors[widget.color]!['textColor']!;

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

    onTapTodoComplete({
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

      onClick(BottomNavigationEnum enumId) async {
        context
            .read<BottomNavigationProvider>()
            .setBottomNavigation(enumId: enumId);
        closeDialog(context);
      }

      showDialog(
        context: context,
        builder: (context) => NativeAdDialog(
          title: '${widget.title} $completedType 완료!',
          leftText: '히스토리 보기',
          rightText: '그래프 보기',
          leftIcon: Icons.menu_book_rounded,
          rightIcon: Icons.auto_graph_rounded,
          onLeftClick: () => onClick(BottomNavigationEnum.history),
          onRightClick: () => onClick(BottomNavigationEnum.graph),
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

    onTapOpen() {
      isOpen
          ? user.filterList?.remove(widget.filterId)
          : user.filterList?.add(widget.filterId);
      user.save();
    }

    List<TagClass> tags = [
      TagClass(
        text: '할 일 ${planList.length}개',
        color: widget.color,
        isHide: isOpen,
        onTap: onTapOpen,
      ),
      TagClass(
        text: '실천율 ${actionPercent()}%',
        color: widget.color,
        onTap: onTapActionPercent,
      ),
      TagClass(
        icon: isOpen
            ? Icons.keyboard_arrow_down_rounded
            : Icons.keyboard_arrow_right_rounded,
        color: widget.color,
        onTap: onTapOpen,
      )
    ];

    return Column(
      children: [
        ContentsBox(
          isBoxShadow: true,
          contentsWidget: Column(
            children: [
              TitleContainer(
                isDivider: isOpen,
                title: widget.title,
                icon: widget.icon,
                tags: tags,
                onTap: onTapOpen,
              ),
              isOpen
                  ? Column(
                      children: [
                        TodoList(
                          actions: actions,
                          mainColor: mainColor,
                          planList: planList,
                          onCheckBox: onCheckBox,
                          onTapTodoUpdate: onTapTodoComplete,
                        ),
                        TodoAdd(
                          title: widget.title,
                          mainColor: mainColor,
                          onTapTodoAdd: onTapTodoComplete,
                        ),
                      ],
                    )
                  : const EmptyArea(),
            ],
          ),
        ),
        SpaceHeight(height: smallSpace),
      ],
    );
  }
}

class TodoList extends StatelessWidget {
  TodoList({
    super.key,
    required this.actions,
    required this.planList,
    required this.mainColor,
    required this.onCheckBox,
    required this.onTapTodoUpdate,
  });

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
            (info) => Padding(
              padding: const EdgeInsets.only(bottom: regularSapce),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonCheckBox(
                    id: info.id,
                    isCheck: action(info.id)['id'] != null,
                    checkColor: mainColor,
                    onTap: onCheckBox,
                  ),
                  TodoName(
                    planInfo: info,
                    color: mainColor,
                    isChcked: action(info.id)['id'] != null,
                    onTapTodoUpdate: onTapTodoUpdate,
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
    required this.planInfo,
    required this.isChcked,
    required this.onTapTodoUpdate,
    required this.color,
  });

  PlanBox planInfo;
  bool isChcked;
  Color color;
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
  }) onTapTodoUpdate;

  @override
  State<TodoName> createState() => _TodoNameState();
}

class _TodoNameState extends State<TodoName> {
  TextEditingController textController = TextEditingController();
  bool isShowInput = false;

  @override
  void initState() {
    textController.text = widget.planInfo.name;
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
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) => TodoModalBottomSheet(
          id: widget.planInfo.id,
          icon: todoData[widget.planInfo.type]!.icon,
          title: todoData[widget.planInfo.type]!.title,
          planInfo: widget.planInfo,
          onTapEdit: onTapEdit,
        ),
      );
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
                  child: InkWell(
                    onTap: onTapName,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          // width: 10,
                          child: Text(
                            widget.planInfo.name,
                            style: TextStyle(
                              fontSize: 15,
                              color: themeColor,
                              decorationColor: widget.color,
                              decorationThickness: 2,
                              decoration: widget.isChcked
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),
                        ),
                        SpaceHeight(height: 3),
                        CommonText(
                          text: widget.planInfo.isAlarm
                              ? timeToString(widget.planInfo.alarmTime)
                              : '알림 없음',
                          size: 11,
                          leftIcon: widget.planInfo.isAlarm
                              ? Icons.alarm
                              : Icons.alarm_off_rounded,
                          color: widget.planInfo.isAlarm
                              ? themeColor
                              : Colors.grey,
                        ),
                      ],
                    ),
                  ),
                ),
                SpaceWidth(width: regularSapce),
                InkWell(
                  onTap: onTapMore,
                  child: Column(
                    children: [
                      CommonIcon(
                        icon: Icons.more_horiz,
                        size: 22,
                        color: Colors.grey,
                        onTap: onTapMore,
                      ),
                      SpaceHeight(height: smallSpace)
                    ],
                  ),
                ),
              ],
            ),
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
    required String completedType,
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
          completedType: '추가',
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
      ),
    );
  }
}

class TodoModalBottomSheet extends StatefulWidget {
  TodoModalBottomSheet({
    super.key,
    required this.icon,
    required this.id,
    required this.title,
    required this.planInfo,
    required this.onTapEdit,
  });

  IconData icon;
  String id, title;
  PlanBox? planInfo;
  Function() onTapEdit;

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

      planRepository.planBox.delete(widget.id);
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
          showDialog(context: context, builder: (context) => PermissionPopup());
        },
      );
    }

    return CommonBottomSheet(
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
          : Column(
              children: [
                Row(
                  children: [
                    ExpandedButtonVerti(
                      mainColor: themeColor,
                      icon: Icons.edit,
                      title: '${widget.title} 수정',
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

class PermissionPopup extends StatelessWidget {
  const PermissionPopup({
    super.key,
  });

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
