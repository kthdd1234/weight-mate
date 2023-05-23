import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/area/empty_area.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/icon/default_icon.dart';
import 'package:flutter_app_weight_management/components/text/contents_title_text.dart';
import 'package:flutter_app_weight_management/model/user_info/user_info.dart';
import 'package:flutter_app_weight_management/pages/home/body/widgets/today_weight_edit_widget.dart';
import 'package:flutter_app_weight_management/pages/home/body/widgets/today_weight_infos_widget.dart';
import 'package:flutter_app_weight_management/provider/record_selected_dateTime_provider.dart';
import 'package:flutter_app_weight_management/utils/class.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:multi_value_listenable_builder/multi_value_listenable_builder.dart';
import 'package:provider/provider.dart';

class RecordWeightWidget extends StatefulWidget {
  RecordWeightWidget({
    super.key,
    required this.seletedRecordSubType,
    required this.recordSelectedDateTime,
  });

  RecordSubTypes seletedRecordSubType;
  DateTime recordSelectedDateTime;

  @override
  State<RecordWeightWidget> createState() => _RecordWeightWidgetState();
}

class _RecordWeightWidgetState extends State<RecordWeightWidget> {
  final userInfoBox = Hive.box<UserInfoBox>('userInfoBox');

  @override
  Widget build(BuildContext context) {
    List<RecordSubTypeClass> subClassList = [
      RecordSubTypeClass(
        enumId: RecordSubTypes.weightReRecood,
        icon: Icons.edit,
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
      required double tall,
      required double weight,
      required double goalWeight,
      required double bodyFat,
    }) {
      List<RecordSubTypes> enumIds = [
        RecordSubTypes.weightReRecood,
        RecordSubTypes.enterBodyFat,
        RecordSubTypes.resetWeight
      ];

      convertStr(double num) {
        return num.toString();
      }

      if (enumIds.contains(widget.seletedRecordSubType)) {
        return TodayWeightEditWidget(
          seletedRecordSubType: widget.seletedRecordSubType,
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

    setBoxValue({required Box<UserInfoBox> box, required String type}) {
      final userInfo = box.get('userInfo')!;
      final recordInfoList = userInfo.recordInfoList;

      switch (type) {
        case 'tall':
          return userInfo.tall;

        case 'weight':
          if (recordInfoList != null) {
            List<DietPlanClass> convertDataToClassList(
              List<Map<String, dynamic>> dietPlanList,
            ) {
              return dietPlanList
                  .map(
                    (element) => DietPlanClass(
                      id: element['id'],
                      icon: IconData(
                        element['iconCodePoint'],
                        fontFamily: 'MaterialIcons',
                      ),
                      plan: element['plan'],
                      isChecked: element['isChecked'],
                      isAction: element['isAction'],
                    ),
                  )
                  .toList();
            }

            final listObjToClass = recordInfoList.map(
              (item) => RecordInfoClass(
                recordDateTime: item['recordDateTime'],
                weight: item['weight'],
                bodyFat: item['bodyFat'],
                dietPlanList: convertDataToClassList(item['dietPlanList']),
                memo: item['memo'],
              ),
            );

            final resultClass = listObjToClass.firstWhere(
              (element) =>
                  getDateTimeToSlash(element.recordDateTime) ==
                  getDateTimeToSlash(widget.recordSelectedDateTime),
            );

            return resultClass.weight;
          }

          return 0.0;

        case 'goalWeight':
          return userInfo.goalWeight;

        case 'bodyFat':
          return 0.0;

        default:
          return 0.0;
      }
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
              setWidget(
                tall: setBoxValue(box: box, type: 'tall'),
                weight: setBoxValue(box: box, type: 'weight'),
                goalWeight: setBoxValue(box: box, type: 'goalWeight'),
                bodyFat: setBoxValue(box: box, type: 'bodyFat'),
              ),
            ],
          ),
        );
      },
    );
  }
}
