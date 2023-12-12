import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/ads/banner_widget.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/model/plan_box/plan_box.dart';
import 'package:flutter_app_weight_management/model/record_box/record_box.dart';
import 'package:flutter_app_weight_management/model/user_box/user_box.dart';
import 'package:flutter_app_weight_management/pages/home/body/widgets/today_diary_widget.dart';
import 'package:flutter_app_weight_management/pages/home/body/widgets/today_plan_widget.dart';
import 'package:flutter_app_weight_management/pages/home/body/widgets/today_weight_widget.dart';
import 'package:flutter_app_weight_management/pages/home/body/widgets/today_wise_saying_widget.dart';
import 'package:flutter_app_weight_management/provider/ads_provider.dart';
import 'package:flutter_app_weight_management/provider/import_date_time_provider.dart';
import 'package:flutter_app_weight_management/provider/record_icon_type_provider.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:multi_value_listenable_builder/multi_value_listenable_builder.dart';
import 'package:provider/provider.dart';

class RecordBody extends StatefulWidget {
  RecordBody({super.key, required this.setActiveCamera});

  Function(bool isActive) setActiveCamera;

  @override
  State<RecordBody> createState() => _RecordBodyState();
}

class _RecordBodyState extends State<RecordBody> with WidgetsBindingObserver {
  late Box<UserBox> userBox;
  late Box<RecordBox> recordBox;
  late Box<PlanBox> planBox;

  bool isGestureDetector = false;
  BannerAd? bannerAd;

  @override
  void initState() {
    super.initState();

    userBox = Hive.box<UserBox>('userBox');
    recordBox = Hive.box<RecordBox>('recordBox');
    planBox = Hive.box<PlanBox>('planBox');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final adsState = Provider.of<AdsProvider>(context).adsState;

    adsState.initialization.then(
      (value) => {
        setState(() {
          bannerAd = BannerAd(
            adUnitId: adsState.bannerAdUnitId,
            size: AdSize.banner,
            request: const AdRequest(),
            listener: adsState.bannerAdListener,
          )..load();
        })
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    RecordIconTypes seletedRecordIconType =
        context.watch<RecordIconTypeProvider>().getSeletedRecordIconType();
    DateTime importDateTime =
        context.watch<ImportDateTimeProvider>().getImportDateTime();

    // onPressed() {
    //   userBox.clear();
    //   recordBox.clear();
    //   planBox.clear();
    // }

    return SingleChildScrollView(
      child: MultiValueListenableBuilder(
        valueListenables: [
          userBox.listenable(),
          recordBox.listenable(),
          planBox.listenable(),
        ],
        builder: (context, values, child) {
          return Column(
            children: [
              BannerWidget(),
              SpaceHeight(height: largeSpace),
              TodayWeightWidget(
                seletedRecordIconType: seletedRecordIconType,
                importDateTime: importDateTime,
              ),
              SpaceHeight(height: largeSpace),
              TodayDiaryWidget(
                importDateTime: importDateTime,
                seletedRecordSubType: seletedRecordIconType,
                setActiveCamera: widget.setActiveCamera,
              ),
              SpaceHeight(height: largeSpace),
              TodayPlanWidget(
                seletedRecordIconType: seletedRecordIconType,
                importDateTime: importDateTime,
              ),
              SpaceHeight(height: largeSpace),
            ],
          );
        },
      ),
    );
  }
}



              // ElevatedButton(
              //   onPressed: onPressed,
              //   child: const Text('hive 데이터 초기화'),
              // )
              