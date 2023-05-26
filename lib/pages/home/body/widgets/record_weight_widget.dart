import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/icon/default_icon.dart';
import 'package:flutter_app_weight_management/components/text/contents_title_text.dart';
import 'package:flutter_app_weight_management/model/user_info/user_info.dart';
import 'package:flutter_app_weight_management/pages/home/body/widgets/today_weight_edit_widget.dart';
import 'package:flutter_app_weight_management/pages/home/body/widgets/today_weight_infos_widget.dart';
import 'package:flutter_app_weight_management/utils/class.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:hive_flutter/hive_flutter.dart';

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

    Widget handleSetWidget({
      required double weight,
      required double tall,
      required double goalWeight,
    }) {
      List<RecordSubTypes> enumIds = [
        RecordSubTypes.weightReRecood,
        RecordSubTypes.resetWeight
      ];

      convertStr(double? num) {
        if (num == null) {
          return '';
        }

        return num.toString();
      }

      double? setBeforeWeight() {
        final userInfo = userInfoBox.get('userInfo')!;
        final recordInfoList = userInfo.recordInfoList;

        if (recordInfoList == null || recordInfoList.length < 2) return 0.0;

        final beforeIndex = getRecordIndex(
              dateTime: widget.recordSelectedDateTime,
              recordInfoList: recordInfoList,
            ) -
            1;
        final beforeRecordInfo = recordInfoList[beforeIndex];

        return beforeRecordInfo['weight'];
      }

      if (enumIds.contains(widget.seletedRecordSubType)) {
        return TodayWeightEditWidget(
          seletedRecordSubType: widget.seletedRecordSubType,
          weightText: convertStr(weight),
        );
      }

      return TodayWeightInfosWidget(
        weight: weight,
        goalWeight: goalWeight,
        tall: tall,
        beforeWeight: setBeforeWeight(),
      );
    }

    setBoxValue({required String type}) {
      final userInfo = userInfoBox.get('userInfo')!;
      final recordInfoList = userInfo.recordInfoList;

      switch (type) {
        case 'tall':
          return userInfo.tall;

        case 'weight':
          final result = getRecordInfoClass(
            recordInfoList: recordInfoList,
            recordSelectedDateTime: widget.recordSelectedDateTime,
          );

          if (result == null) return 0.0;
          return result.weight!;

        case 'goalWeight':
          return userInfo.goalWeight;

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
              handleSetWidget(
                tall: setBoxValue(type: 'tall'),
                weight: setBoxValue(type: 'weight'),
                goalWeight: setBoxValue(type: 'goalWeight'),
              ),
            ],
          ),
        );
      },
    );
  }
}
