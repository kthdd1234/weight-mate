// ignore_for_file: must_be_immutable

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/main.dart';
import 'package:flutter_app_weight_management/pages/home/body/record/widget/record_edit.dart';
import 'package:flutter_app_weight_management/pages/home/body/record/widget/record_history.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:multi_value_listenable_builder/multi_value_listenable_builder.dart';

class RecordBody extends StatefulWidget {
  RecordBody({super.key, required this.setActiveCamera});

  Function(bool isActive) setActiveCamera;

  @override
  State<RecordBody> createState() => _RecordBodyState();
}

class _RecordBodyState extends State<RecordBody> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<ValueListenable<Box<HiveObject>>> valueListenables = [
      userRepository.userBox.listenable(),
      recordRepository.recordBox.listenable(),
      planRepository.planBox.listenable()
    ];

    return SingleChildScrollView(
      child: MultiValueListenableBuilder(
        valueListenables: valueListenables,
        builder: (context, values, child) {
          return Column(
            children: [RecordEdit(), RecordHistory()],
          );
        },
      ),
    );
  }
}
// BannerWidget(),
// SpaceHeight(height: largeSpace),
// TodayWeightWidget(
//   seletedRecordIconType: seletedRecordIconType,
//   importDateTime: importDateTime,
// ),
// SpaceHeight(height: largeSpace),
// TodayDiaryWidget(
//   importDateTime: importDateTime,
//   seletedRecordSubType: seletedRecordIconType,
//   setActiveCamera: widget.setActiveCamera,
// ),
// SpaceHeight(height: largeSpace),
// TodayPlanWidget(
//   seletedRecordIconType: seletedRecordIconType,
//   importDateTime: importDateTime,
// ),
// SpaceHeight(height: largeSpace),
  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   final adsState = Provider.of<AdsProvider>(context).adsState;

  //   adsState.initialization.then(
  //     (value) => {
  //       setState(() {
  //         bannerAd = BannerAd(
  //           adUnitId: adsState.bannerAdUnitId,
  //           size: AdSize.banner,
  //           request: const AdRequest(),
  //           listener: adsState.bannerAdListener,
  //         )..load();
  //       })
  //     },
  //   );
  // }