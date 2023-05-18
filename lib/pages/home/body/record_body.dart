import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/pages/home/body/widgets/record_memo_widget.dart';
import 'package:flutter_app_weight_management/pages/home/body/widgets/record_plan_widget.dart';
import 'package:flutter_app_weight_management/pages/home/body/widgets/record_weight_widget.dart';
import 'package:flutter_app_weight_management/pages/home/body/widgets/today_wise_saying_widget.dart';
import 'package:flutter_app_weight_management/provider/record_sub_type_provider.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';
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

    return SingleChildScrollView(
      child: Column(
        children: [
          const TodayWiseSayingWidget(),
          SpaceHeight(height: regularSapce),
          RecordWeightWidget(seletedRecordSubType: seletedRecordSubType),
          SpaceHeight(height: regularSapce),
          RecordPlanWidget(seletedRecordSubType: seletedRecordSubType),
          SpaceHeight(height: regularSapce),
          RecordMemoWidget(seletedRecordSubType: seletedRecordSubType)
        ],
      ),
    );
  }
}
