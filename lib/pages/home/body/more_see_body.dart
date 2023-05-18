import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/pages/home/body/widgets/more_app_setting_widget.dart';
import 'package:flutter_app_weight_management/pages/home/body/widgets/more_etc_info_widget.dart';
import 'package:flutter_app_weight_management/pages/home/body/widgets/more_my_info_widget.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';

class MoreSeeBody extends StatelessWidget {
  const MoreSeeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          MoreMyInfoWidget(),
          SpaceHeight(height: regularSapce),
          MoreAppSettingWidget(),
          SpaceHeight(height: regularSapce),
          MoreEtcInfoWidget()
        ],
      ),
    );
  }
}

        // const AnalyzeDietWayWidget(),
          // SpaceHeight(height: regularSapce),
