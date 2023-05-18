import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/icon/default_icon.dart';
import 'package:flutter_app_weight_management/components/text/contents_title_text.dart';
import 'package:flutter_app_weight_management/pages/home/body/widgets/today_weight_edit_widget.dart';
import 'package:flutter_app_weight_management/pages/home/body/widgets/today_weight_infos_widget.dart';
import 'package:flutter_app_weight_management/utils/class.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class RecordWeightWidget extends StatelessWidget {
  RecordWeightWidget({
    super.key,
    required this.seletedRecordSubType,
  });

  RecordSubTypes seletedRecordSubType;

  @override
  Widget build(BuildContext context) {
    // String tallText = context.watch<DietInfoProvider>().getTallText();
    // String weightText = context.watch<DietInfoProvider>().getWeightText();
    // String goalWeightText =
    //     context.watch<DietInfoProvider>().getGoalWeightText();
    // String bodyFatText = context.watch<DietInfoProvider>().getBodyFatText();

    final userInfoBox = Hive.box('userInfoBox');

    List<RecordSubTypeClass> subClassList = [
      RecordSubTypeClass(
        enumId: RecordSubTypes.weightReRecood,
        icon: Icons.monitor_weight,
      ),
      RecordSubTypeClass(
        enumId: RecordSubTypes.enterBodyFat,
        icon: Icons.av_timer_rounded,
      ),
      RecordSubTypeClass(
        enumId: RecordSubTypes.resetWeight,
        icon: Icons.replay,
      )
    ];

    List<DefaultIcon> subWidgets = subClassList
        .map((element) => DefaultIcon(
              id: element.enumId,
              icon: element.icon,
              onTap: (id) {},
            ))
        .toList();

    Widget setWidget({
      required double weight,
      required double goalWeight,
      required double bodyFat,
      required double tall,
    }) {
      List<RecordSubTypes> enumIds = [
        RecordSubTypes.weightReRecood,
        RecordSubTypes.enterBodyFat,
        RecordSubTypes.resetWeight
      ];

      convertStr(double num) {
        return num.toString();
      }

      if (enumIds.contains(seletedRecordSubType)) {
        return TodayWeightEditWidget(
          seletedRecordSubType: seletedRecordSubType,
          weightText: convertStr(weight),
          bodyFatText: convertStr(bodyFat),
        );
      }

      return TodayWeightInfosWidget(
        weightText: convertStr(weight),
        goalWeightText: convertStr(goalWeight),
        bodyFatText: convertStr(bodyFat),
        tallText: convertStr(tall),
      );
    }

    return ValueListenableBuilder(
        valueListenable: userInfoBox.listenable(),
        builder: (context, box, widget) {
          return ContentsBox(
            contentsWidget: Column(
              children: [
                ContentsTitleText(
                  text: '오늘의 체중',
                  sub: subWidgets,
                  icon: Icons.align_vertical_bottom_rounded,
                ),
                // setWidget({  })
              ],
            ),
          );
        });
  }
}
