import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/pages/home/body/widgets/record_memo_widget.dart';
import 'package:flutter_app_weight_management/pages/home/body/widgets/record_plan_widget.dart';
import 'package:flutter_app_weight_management/pages/home/body/widgets/record_weight_widget.dart';
import 'package:flutter_app_weight_management/pages/home/body/widgets/today_wise_saying_widget.dart';
import 'package:flutter_app_weight_management/provider/record_selected_dateTime_provider.dart';
import 'package:flutter_app_weight_management/provider/record_icon_type_provider.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';
import 'package:provider/provider.dart';

class RecordBody extends StatefulWidget {
  const RecordBody({super.key});

  @override
  State<RecordBody> createState() => _RecordBodyState();
}

class _RecordBodyState extends State<RecordBody> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      context.read<ImportDateTimeProvider>().setImportDateTime(DateTime.now());
    }
  }

  @override
  Widget build(BuildContext context) {
    RecordIconTypes seletedRecordIconType =
        context.watch<RecordIconTypeProvider>().getSeletedRecordIconType();
    final recordSelectedDateTime =
        context.watch<ImportDateTimeProvider>().getImportDateTime();

    return SingleChildScrollView(
      child: Column(
        children: [
          TodayWiseSayingWidget(
            recordSelectedDateTime: recordSelectedDateTime,
          ),
          SpaceHeight(height: largeSpace),
          RecordWeightWidget(
            seletedRecordIconType: seletedRecordIconType,
            recordSelectedDateTime: recordSelectedDateTime,
          ),
          SpaceHeight(height: largeSpace),
          RecordPlanWidget(seletedRecordIconType: seletedRecordIconType),
          SpaceHeight(height: largeSpace),
          RecordMemoWidget(seletedRecordSubType: seletedRecordIconType),
        ],
      ),
    );
  }
}
    // ElevatedButton(
          //   onPressed: onPressed,
          //   child: const Text('hive 데이터 초기화'),
          // )
  //onPressed() {
      // final recordInfoBox = Hive.box<RecordInfoBox>('recordInfoBox');
      // recordInfoBox.clear();

      // print(recordInfoBox.values.toList());
   // }