// ignore_for_file: prefer_const_constructors
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/common/CommonAppBar.dart';
import 'package:flutter_app_weight_management/components/ads/banner_widget.dart';
import 'package:flutter_app_weight_management/components/area/empty_area.dart';
import 'package:flutter_app_weight_management/main.dart';
import 'package:flutter_app_weight_management/pages/home/body/record/edit/edit_diary.dart';
import 'package:flutter_app_weight_management/pages/home/body/record/edit/edit_picture.dart';
import 'package:flutter_app_weight_management/pages/home/body/record/edit/edit_todo.dart';
import 'package:flutter_app_weight_management/pages/home/body/record/edit/edit_weight.dart';
import 'package:flutter_app_weight_management/pages/home/home_page.dart';
import 'package:flutter_app_weight_management/provider/import_date_time_provider.dart';
import 'package:flutter_app_weight_management/provider/premium_provider.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:multi_value_listenable_builder/multi_value_listenable_builder.dart';
import 'package:provider/provider.dart';

List<ValueListenable<Box<HiveObject>>> valueListenables = [
  userRepository.userBox.listenable(),
  recordRepository.recordBox.listenable(),
  planRepository.planBox.listenable()
];

class RecordBody extends StatelessWidget {
  const RecordBody({super.key});

  @override
  Widget build(BuildContext context) {
    DateTime importDateTime =
        context.watch<ImportDateTimeProvider>().getImportDateTime();
    bool isPremium = context.watch<PremiumProvider>().premiumValue();

    onHorizontalDragEnd(DragEndDetails dragEndDetails) {
      double? primaryVelocity = dragEndDetails.primaryVelocity;
      DateTime dateTime = importDateTime;

      if (primaryVelocity == null) {
        return;
      } else if (primaryVelocity > 0) {
        dateTime = importDateTime.subtract(Duration(days: 1));
      } else if (primaryVelocity < 0) {
        dateTime = importDateTime.add(Duration(days: 1));
      }

      context.read<ImportDateTimeProvider>().setImportDateTime(dateTime);
    }

    return MultiValueListenableBuilder(
      valueListenables: valueListenables,
      builder: (context, values, child) {
        return Column(
          children: [
            CommonAppBar(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
                child: GestureDetector(
                  onHorizontalDragEnd: onHorizontalDragEnd,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        EditWeight(),
                        EditPicture(),
                        EditTodo(),
                        EditDiary(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            !isPremium
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: BannerWidget(),
                  )
                : const EmptyArea(),
          ],
        );
      },
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