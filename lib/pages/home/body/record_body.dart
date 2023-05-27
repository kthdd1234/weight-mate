import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/model/record_info/record_info.dart';
import 'package:flutter_app_weight_management/pages/home/body/widgets/record_memo_widget.dart';
import 'package:flutter_app_weight_management/pages/home/body/widgets/record_plan_widget.dart';
import 'package:flutter_app_weight_management/pages/home/body/widgets/record_weight_widget.dart';
import 'package:flutter_app_weight_management/pages/home/body/widgets/today_wise_saying_widget.dart';
import 'package:flutter_app_weight_management/provider/record_selected_dateTime_provider.dart';
import 'package:flutter_app_weight_management/provider/record_sub_type_provider.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

class RecordBody extends StatefulWidget {
  const RecordBody({super.key});

  @override
  State<RecordBody> createState() => _RecordBodyState();
}

class _RecordBodyState extends State<RecordBody> {
  @override
  Widget build(BuildContext context) {
    RecordSubTypes seletedRecordSubType =
        context.watch<RecordSubTypeProvider>().getSeletedRecordSubType();
    final recordSelectedDateTime =
        context.watch<RecordSelectedDateTimeProvider>().getSelectedDateTime();

    onPressed() {
      final recordInfoBox = Hive.box<RecordInfoBox>('recordInfoBox');
      recordInfoBox.clear();

      print(recordInfoBox.values.toList());
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          TodayWiseSayingWidget(
            recordSelectedDateTime: recordSelectedDateTime,
          ),
          SpaceHeight(height: regularSapce),
          RecordWeightWidget(
            seletedRecordSubType: seletedRecordSubType,
            recordSelectedDateTime: recordSelectedDateTime,
          ),
          SpaceHeight(height: regularSapce),
          RecordPlanWidget(seletedRecordSubType: seletedRecordSubType),
          SpaceHeight(height: regularSapce),
          RecordMemoWidget(seletedRecordSubType: seletedRecordSubType),
          ElevatedButton(
            onPressed: onPressed,
            child: const Text('hive 데이터 초기화'),
          )
        ],
      ),
    );
  }
}
