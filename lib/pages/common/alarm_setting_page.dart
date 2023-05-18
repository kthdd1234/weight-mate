import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/framework/app_framework.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/widgets/custom_alarm_widget.dart';
import 'package:flutter_app_weight_management/widgets/record_alarm_widget.dart';

class AlarmSettingPage extends StatelessWidget {
  const AlarmSettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppFramework(
      widget: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          foregroundColor: buttonBackgroundColor,
          elevation: 0.0,
          title: const Text('알림 설정'),
        ),
        body: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: pagePadding,
              child: ContentsBox(
                width: MediaQuery.of(context).size.width,
                contentsWidget: Column(
                  children: [
                    RecordAlarmWidget(),
                    SpaceHeight(height: largeSpace),
                    CustomAlarmWidget()
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
