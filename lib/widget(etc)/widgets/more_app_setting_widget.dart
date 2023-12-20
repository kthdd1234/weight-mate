import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/dialog/confirm_dialog.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/text/contents_title_text.dart';
import 'package:flutter_app_weight_management/model/plan_box/plan_box.dart';
import 'package:flutter_app_weight_management/model/user_box/user_box.dart';
import 'package:flutter_app_weight_management/utils/class.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';
import 'package:flutter_app_weight_management/widgets/dafault_bottom_sheet.dart';
import 'package:flutter_app_weight_management/widgets/more_see_item_widget.dart';
import 'package:hive_flutter/hive_flutter.dart';

class MoreAppSettingWidget extends StatefulWidget {
  MoreAppSettingWidget({
    super.key,
    required this.userProfile,
    required this.planBox,
  });

  UserBox? userProfile;
  Box<PlanBox> planBox;

  @override
  State<MoreAppSettingWidget> createState() => _MoreAppSettingWidgetState();
}

class _MoreAppSettingWidgetState extends State<MoreAppSettingWidget> {
  bool isLockScreen = false;
  bool isOnAlarm = false;

  @override
  Widget build(BuildContext buildContext) {
    onTapSwitch(MoreSeeItem id, bool value) {
      if (id == MoreSeeItem.appLock) {
        if (value) {
          showDialog(
            context: context,
            builder: (context) => ConfirmDialog(
              width: 300,
              titleText: '화면 잠금 경고',
              contentIcon: Icons.lock,
              contentText1: '암호를 분실했을 경우',
              contentText2: '앱 삭제 후 재설치 해야 합니다.',
              onPressedOk: () => Navigator.pushNamed(context, '/screen-lock'),
            ),
          );
        } else {
          widget.userProfile?.screenLockPasswords = null;
          widget.userProfile?.save();
        }
      }
    }

    onTapArrow(MoreSeeItem id) {
      switch (id) {
        // case MoreSeeItem.appAlarm:
        //   Navigator.pushNamed(context, '/common-alarm');
        //   break;

        case MoreSeeItem.appLang:
          showModalBottomSheet(
            backgroundColor: Colors.transparent,
            context: context,
            builder: (context) => DefaultBottomSheet(
              title: '언어 선택',
              height: 500,
              contents: Column(children: [
                ContentsBox(
                  contentsWidget: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [Text('한국어'), Icon(Icons.task_alt)],
                  ),
                )
              ]),
              submitText: '완료',
              onSubmit: () {},
            ),
          );
          break;

        case MoreSeeItem.appReset:
          showDialog(
            context: context,
            builder: (builder) => ConfirmDialog(
              width: 300,
              titleText: '초기화 경고',
              contentIcon: Icons.settings_backup_restore,
              contentText1: '앱 내의 모든 데이터가 초기화되며',
              contentText2: '복구가 불가능합니다.',
              onPressedOk: () {
                // 로직 수행
                // closeDialog(context);
              },
            ),
          );
          break;

        default:
      }
    }

    setAlarmValue() {
      int count = 0;

      if (widget.userProfile!.isAlarm) {
        count += 1;
      }

      // ignore: avoid_function_literals_in_foreach_calls
      widget.planBox.values.forEach((element) {
        if (element.isAlarm) {
          count += 1;
        }
      });

      return count;
    }

    List<MoreSeeItemClass> moreSeeAppSettingItems = [
      MoreSeeItemClass(
        index: 0,
        id: MoreSeeItem.appLock,
        icon: Icons.lock_outline_rounded,
        title: '화면 잠금',
        value: widget.userProfile?.screenLockPasswords != null,
        widgetType: MoreSeeWidgetTypes.switching,
        onTapSwitch: onTapSwitch,
      ),
      // MoreSeeItemClass(
      //   index: 1,
      //   id: MoreSeeItem.appAlarm,
      //   icon: Icons.notifications_active_outlined,
      //   title: '알림',
      //   value: '${setAlarmValue()}개의 알림',
      //   widgetType: MoreSeeWidgetTypes.arrow,
      //   onTapArrow: onTapArrow,
      // ),
      MoreSeeItemClass(
        index: 2,
        id: MoreSeeItem.appLang,
        icon: Icons.language_rounded,
        title: '언어',
        value: '한국어',
        widgetType: MoreSeeWidgetTypes.arrow,
        onTapArrow: onTapArrow,
      ),
      // MoreSeeItemClass(
      //   index: 3,
      //   id: MoreSeeItem.appReset,
      //   icon: Icons.settings_backup_restore,
      //   title: '앱 초기화',
      //   value: '',
      //   widgetType: MoreSeeWidgetTypes.arrow,
      //   onTapArrow: onTapArrow,
      // ),
    ];

    List<MoreSeeItemWidget> widgetList = moreSeeAppSettingItems
        .map((item) => MoreSeeItemWidget(
              index: item.index,
              id: item.id,
              icon: item.icon,
              title: item.title,
              value: item.value,
              widgetType: item.widgetType,
              onTapArrow: item.onTapArrow,
              onTapSwitch: item.onTapSwitch,
            ))
        .toList();

    return Column(children: widgetList);
  }
}
