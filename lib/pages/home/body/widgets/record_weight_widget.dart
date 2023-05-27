import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/icon/default_icon.dart';
import 'package:flutter_app_weight_management/components/text/contents_title_text.dart';
import 'package:flutter_app_weight_management/model/record_info/record_info.dart';
import 'package:flutter_app_weight_management/model/user_info/user_info.dart';
import 'package:flutter_app_weight_management/pages/home/body/widgets/today_weight_edit_widget.dart';
import 'package:flutter_app_weight_management/pages/home/body/widgets/today_weight_infos_widget.dart';
import 'package:flutter_app_weight_management/provider/record_selected_dateTime_provider.dart';
import 'package:flutter_app_weight_management/utils/class.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

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
  late Box<UserInfoBox> userInfoBox;
  late Box<RecordInfoBox> recordInfoBox;

  @override
  void initState() {
    userInfoBox = Hive.box<UserInfoBox>('userInfoBox');
    recordInfoBox = Hive.box<RecordInfoBox>('recordInfoBox');

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final DateTime selectedDateTime =
        context.watch<RecordSelectedDateTimeProvider>().getSelectedDateTime();

    setIconWidgets() {
      return subClassList
          .map((element) => DefaultIcon(
                id: element.enumId,
                icon: element.icon,
                onTap: (id) {},
              ))
          .toList();
    }

    setMainWidgets({
      double? weight,
      required double tall,
      required double goalWeight,
      double? beforeWeight,
    }) {
      List<RecordSubTypes> enumIds = [
        RecordSubTypes.weightReRecood,
      ];

      if (enumIds.contains(widget.seletedRecordSubType)) {
        return TodayWeightEditWidget(
          seletedRecordSubType: widget.seletedRecordSubType,
          weightText: weight.toString(),
        );
      }

      return TodayWeightInfosWidget(
        weight: weight,
        goalWeight: goalWeight,
        tall: tall,
        beforeWeight: beforeWeight,
      );
    }

    setTall() {
      UserInfoBox? userInfo = userInfoBox.get('userInfo');
      return userInfo!.tall;
    }

    setWeight() {
      final recordInfo = recordInfoBox.get(getDateTimeToInt(selectedDateTime));

      if (recordInfo == null) return null;

      return recordInfo.weight;
    }

    setGoalWeight() {
      UserInfoBox? userInfo = userInfoBox.get('userInfo');
      return userInfo!.goalWeight;
    }

    double? setBeforeWeight() {
      List<RecordInfoBox> values = recordInfoBox.values.toList();

      if (values.length < 2) {
        return 0.0;
      }

      int firstIndex = values.indexWhere(
        (element) =>
            getDateTimeToInt(element.recordDateTime) ==
            getDateTimeToInt(selectedDateTime),
      );
      List<RecordInfoBox> sublist = values.sublist(0, firstIndex).toList();
      List<RecordInfoBox> reverseList = List.from(sublist.reversed);

      RecordInfoBox result =
          reverseList.firstWhere((element) => element.weight != null);

      return result.weight;
    }

    return ContentsBox(
      contentsWidget: Column(
        children: [
          ContentsTitleText(
            text: '오늘의 체중',
            sub: setIconWidgets(),
            icon: Icons.align_vertical_bottom_rounded,
          ),
          setMainWidgets(
            tall: setTall(),
            weight: setWeight(),
            goalWeight: setGoalWeight(),
            beforeWeight: setBeforeWeight(),
          ),
        ],
      ),
    );
  }
}
