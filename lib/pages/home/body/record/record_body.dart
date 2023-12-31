import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/main.dart';
import 'package:flutter_app_weight_management/pages/home/body/record/edit/edit_container.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:multi_value_listenable_builder/multi_value_listenable_builder.dart';

class RecordBody extends StatelessWidget {
  RecordBody({super.key, required this.setActiveCamera});

  Function(bool isActive) setActiveCamera;

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
          return EditContainer(
            recordType: eEditContainer.edit,
            setActiveCamera: setActiveCamera,
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