import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/dialog/confirm_dialog.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/text/contents_title_text.dart';
import 'package:flutter_app_weight_management/utils/class.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';
import 'package:flutter_app_weight_management/widgets/more_see_item_widget.dart';

class MoreAppSettingWidget extends StatefulWidget {
  const MoreAppSettingWidget({super.key});

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
              titleText: '화면 잠금 경고',
              contentIcon: Icons.lock,
              contentText1: '암호를 분실했을 경우',
              contentText2: '앱을 삭제하고 재설치 해야 합니다.',
              onPressedOk: () => Navigator.pushNamed(context, '/screen-lock'),
            ),
          );
          return;
        }

        return setState(() => isLockScreen = value);
      }
    }

    onTapArrow(MoreSeeItem id) {
      switch (id) {
        case MoreSeeItem.appReset:
          showDialog(
            context: context,
            builder: (builder) => ConfirmDialog(
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
        case MoreSeeItem.appAlarm:
          Navigator.pushNamed(context, '/alarm-setting');
          break;
        default:
      }
    }

    List<MoreSeeItemClass> moreSeeAppSettingItems = [
      MoreSeeItemClass(
        index: 0,
        id: MoreSeeItem.appLock,
        icon: Icons.lock_outline_rounded,
        title: '화면 잠금',
        value: isLockScreen,
        widgetType: MoreSeeWidgetTypes.switching,
        onTapSwitch: onTapSwitch,
      ),
      MoreSeeItemClass(
        index: 1,
        id: MoreSeeItem.appAlarm,
        icon: Icons.notifications_active_outlined,
        title: '알림',
        value: '0개의 알림',
        widgetType: MoreSeeWidgetTypes.arrow,
        onTapArrow: onTapArrow,
      ),
      MoreSeeItemClass(
        index: 2,
        id: MoreSeeItem.appLang,
        icon: Icons.language_rounded,
        title: '언어',
        value: '한국어',
        widgetType: MoreSeeWidgetTypes.arrow,
        onTapArrow: onTapArrow,
      ),
      MoreSeeItemClass(
        index: 3,
        id: MoreSeeItem.appReset,
        icon: Icons.settings_backup_restore,
        title: '앱 초기화',
        value: '',
        widgetType: MoreSeeWidgetTypes.arrow,
        onTapArrow: onTapArrow,
      ),
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

    return ContentsBox(
      contentsWidget: Column(
        children: [
          ContentsTitleText(text: '설정'),
          SpaceHeight(height: regularSapce),
          ContentsBox(
            backgroundColor: dialogBackgroundColor,
            contentsWidget: Column(children: widgetList),
          )
        ],
      ),
    );
  }
}
