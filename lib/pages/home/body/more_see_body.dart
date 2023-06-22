import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/model/plan_box/plan_box.dart';
import 'package:flutter_app_weight_management/model/record_box/record_box.dart';
import 'package:flutter_app_weight_management/model/user_box/user_box.dart';
import 'package:flutter_app_weight_management/pages/home/body/widgets/more_app_setting_widget.dart';
import 'package:flutter_app_weight_management/pages/home/body/widgets/more_etc_info_widget.dart';
import 'package:flutter_app_weight_management/pages/home/body/widgets/more_my_info_widget.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:multi_value_listenable_builder/multi_value_listenable_builder.dart';

class MoreSeeBody extends StatefulWidget {
  const MoreSeeBody({super.key});

  @override
  State<MoreSeeBody> createState() => _MoreSeeBodyState();
}

class _MoreSeeBodyState extends State<MoreSeeBody> {
  late Box<UserBox> userBox;
  late Box<RecordBox> recordBox;
  late Box<PlanBox> planBox;

  @override
  void initState() {
    userBox = Hive.box('userBox');
    recordBox = Hive.box('recordBox');
    planBox = Hive.box('planBox');

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiValueListenableBuilder(
      valueListenables: [
        userBox.listenable(),
        recordBox.listenable(),
        planBox.listenable()
      ],
      builder: (context, list, widget) => SingleChildScrollView(
        child: Column(
          children: [
            MoreMyInfoWidget(userBox: userBox, recordBox: recordBox),
            SpaceHeight(height: largeSpace),
            MoreAppSettingWidget(
              userProfile: userBox.get('userProfile'),
              planBox: planBox,
            ),
            SpaceHeight(height: largeSpace),
            const MoreEtcInfoWidget()
          ],
        ),
      ),
    );
  }
}
