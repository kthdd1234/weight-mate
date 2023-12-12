import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/dialog/input_dialog.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/text/contents_title_text.dart';
import 'package:flutter_app_weight_management/model/user_box/user_box.dart';
import 'package:flutter_app_weight_management/utils/class.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:flutter_app_weight_management/widgets/more_see_item_widget.dart';
import 'package:hive/hive.dart';
import '../../../../model/record_box/record_box.dart';

class MoreMyInfoWidget extends StatefulWidget {
  MoreMyInfoWidget({
    super.key,
    required this.userBox,
    required this.recordBox,
  });

  Box<UserBox> userBox;
  Box<RecordBox> recordBox;

  @override
  State<MoreMyInfoWidget> createState() => _MoreMyInfoWidgetState();
}

class _MoreMyInfoWidgetState extends State<MoreMyInfoWidget> {
  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final userProfile = widget.userBox.get('userProfile');
    final recordInfo = widget.recordBox.get(getDateTimeToInt(now));

    Map<MoreSeeItem, double?> textData = {
      MoreSeeItem.tall: userProfile!.tall,
      // MoreSeeItem.weight: recordInfo?.weight,
      MoreSeeItem.goalWeight: userProfile.goalWeight,
    };

    onPressedOk(MoreSeeItem id, String text) {
      double value = double.parse(text);

      switch (id) {
        case MoreSeeItem.tall:
          userProfile.tall = value;
          userProfile.save();

          break;
        // case MoreSeeItem.weight:
        //   if (recordInfo == null) {
        //     widget.recordBox.put(
        //       getDateTimeToInt(now),
        //       RecordBox(
        //         createDateTime: now,
        //         weightDateTime: now,
        //         weight: value,
        //       ),
        //     );
        //   } else {
        //     recordInfo.weight = value;
        //     recordInfo.save();
        //   }

        //   break;
        case MoreSeeItem.goalWeight:
          userProfile.goalWeight = value;
          userProfile.save();

          break;
        default:
      }

      closeDialog(context);
    }

    onTapArrow(MoreSeeItem id) {
      Map<MoreSeeItem, String> titleData = {
        MoreSeeItem.tall: '키',
        // MoreSeeItem.weight: '현재 체중',
        MoreSeeItem.goalWeight: '목표 체중',
      };

      showDialog(
        context: context,
        builder: (builder) {
          final title = titleData[id]!;

          return InputDialog(
            id: id,
            title: title,
            selectedText: textData[id] != null ? textData[id].toString() : '',
            onPressedOk: onPressedOk,
          );
        },
      );
    }

    List<MoreSeeItemClass> moreSeeMyInfoItems = [
      MoreSeeItemClass(
        index: 0,
        id: MoreSeeItem.tall,
        icon: Icons.person_outline,
        title: '키',
        value: '${userProfile.tall} cm',
        widgetType: MoreSeeWidgetTypes.arrow,
        onTapArrow: onTapArrow,
      ),
      // MoreSeeItemClass(
      //   index: 1,
      //   id: MoreSeeItem.weight,
      //   icon: Icons.monitor_weight_outlined,
      //   title: '현재 체중',
      //   value: '${recordInfo?.weight ?? '-'} kg',
      //   widgetType: MoreSeeWidgetTypes.arrow,
      //   onTapArrow: onTapArrow,
      // ),
      MoreSeeItemClass(
        index: 2,
        id: MoreSeeItem.goalWeight,
        icon: Icons.flag_outlined,
        title: '목표 체중',
        value: '${userProfile.goalWeight} kg',
        widgetType: MoreSeeWidgetTypes.arrow,
        onTapArrow: onTapArrow,
      ),
    ];

    List<MoreSeeItemWidget> widgetList = moreSeeMyInfoItems
        .map(
          (item) => MoreSeeItemWidget(
            index: item.index,
            id: item.id,
            icon: item.icon,
            title: item.title,
            value: item.value,
            widgetType: item.widgetType,
            onTapArrow: onTapArrow,
          ),
        )
        .toList();

    return Column(
      children: [
        ContentsTitleText(text: '내 정보'),
        SpaceHeight(height: regularSapce),
        Column(children: widgetList),
      ],
    );
  }
}
