import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/dialog/calendar_range_dialog.dart';
import 'package:flutter_app_weight_management/components/dialog/input_dialog.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/text/contents_title_text.dart';
import 'package:flutter_app_weight_management/provider/diet_Info_provider.dart';
import 'package:flutter_app_weight_management/utils/class.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:flutter_app_weight_management/widgets/more_see_item_widget.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

Map<MoreSeeItem, String> titleData = {
  MoreSeeItem.tall: '키',
  MoreSeeItem.currentWeight: '현재 체중',
  MoreSeeItem.dietStartDay: '다이어트 시작일',
  MoreSeeItem.dietEndDay: '다이어트 종료일',
  MoreSeeItem.goalWeight: '목표 체중',
};

class MoreMyInfoWidget extends StatefulWidget {
  const MoreMyInfoWidget({super.key});

  @override
  State<MoreMyInfoWidget> createState() => _MoreMyInfoWidgetState();
}

class _MoreMyInfoWidgetState extends State<MoreMyInfoWidget> {
  List<DateTime?> startAndEndDateTime = [null, null];
  String startDietDay = '';
  String endDietDay = '';

  @override
  void initState() {
    DateTime now = DateTime.now();
    var strToday = getDateTimeToStr(now);

    setState(() {
      startAndEndDateTime = [now, null];
      startDietDay = strToday;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String tallText = context.watch<DietInfoProvider>().getTallText();
    String weightText = context.watch<DietInfoProvider>().getWeightText();
    String goalWeightText =
        context.watch<DietInfoProvider>().getGoalWeightText();

    onTapArrow(MoreSeeItem id) {
      Map<MoreSeeItem, String> textData = {
        MoreSeeItem.tall: tallText,
        MoreSeeItem.currentWeight: weightText,
        MoreSeeItem.goalWeight: goalWeightText,
      };

      onSubmit(Object? object) {
        if (object != null) {
          setState(() {
            if (object is PickerDateRange) {
              DateTime? startDate = object.startDate ?? object.startDate;
              DateTime? endDate = object.endDate ?? object.endDate;

              startAndEndDateTime[0] = startDate;
              startAndEndDateTime[1] = endDate;
            }
          });

          closeDialog(context);
        }
      }

      onCancel() {
        closeDialog(context);
      }

      showDialog(
          context: context,
          builder: (builder) {
            final title = titleData[id]!;

            if (id == MoreSeeItem.dietStartDay) {
              return CalenderRangeDialog(
                labelText: '다이어트 기간',
                startAndEndDateTime: startAndEndDateTime,
                onSubmit: onSubmit,
                onCancel: onCancel,
              );
            }

            return InputDialog(
              title: title,
              selectedMoreSeeItem: id,
              selectedText: textData[id]!,
            );
          });
    }

    List<MoreSeeItemClass> moreSeeMyInfoItems = [
      MoreSeeItemClass(
        index: 0,
        id: MoreSeeItem.tall,
        icon: Icons.accessibility_new_outlined,
        title: '키',
        value: '$tallText cm',
        widgetType: MoreSeeWidgetTypes.arrow,
        onTapArrow: onTapArrow,
      ),
      MoreSeeItemClass(
        index: 1,
        id: MoreSeeItem.currentWeight,
        icon: Icons.monitor_weight_outlined,
        title: '현재 체중',
        value: '$weightText kg',
        widgetType: MoreSeeWidgetTypes.arrow,
        onTapArrow: onTapArrow,
      ),
      MoreSeeItemClass(
        index: 2,
        id: MoreSeeItem.dietStartDay,
        icon: Icons.hourglass_top_outlined,
        title: '시작일',
        value: '2023.06.01',
        widgetType: MoreSeeWidgetTypes.arrow,
        onTapArrow: onTapArrow,
      ),
      MoreSeeItemClass(
        index: 3,
        id: MoreSeeItem.dietEndDay,
        icon: Icons.hourglass_bottom_outlined,
        title: '종료일',
        value: '2023.08.01',
        widgetType: MoreSeeWidgetTypes.arrow,
        onTapArrow: onTapArrow,
      ),
      MoreSeeItemClass(
        index: 4,
        id: MoreSeeItem.goalWeight,
        icon: Icons.flag_outlined,
        title: '목표 체중',
        value: '$goalWeightText kg',
        widgetType: MoreSeeWidgetTypes.arrow,
        onTapArrow: onTapArrow,
      ),
    ];

    List<MoreSeeItemWidget> widgetList = moreSeeMyInfoItems
        .map((item) => MoreSeeItemWidget(
              index: item.index,
              id: item.id,
              icon: item.icon,
              title: item.title,
              value: item.value,
              widgetType: item.widgetType,
              onTapArrow: onTapArrow,
            ))
        .toList();

    return ContentsBox(
      contentsWidget: Column(
        children: [
          ContentsTitleText(text: '내 정보'),
          SpaceHeight(height: regularSapce),
          ContentsBox(
            backgroundColor: dialogBackgroundColor,
            contentsWidget: Column(children: widgetList),
          ),
        ],
      ),
    );
  }
}

/**
 * 키
 * 체중
 * 다이어트 기간
 * 목표 체중
 * BMI
 */
