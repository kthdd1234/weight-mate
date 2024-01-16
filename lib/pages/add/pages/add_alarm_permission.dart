import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/common/CommonText.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/pages/add/add_container.dart';
import 'package:flutter_app_weight_management/pages/add/pages/add_body_info.dart';

class AddAlarmPermission extends StatelessWidget {
  const AddAlarmPermission({super.key});

  @override
  Widget build(BuildContext context) {
    onCompleted() {
      //
    }

    return AddContainer(
      body: Column(
        children: [
          AddTitle(
            step: 3,
            title: '기록 알림을 받으면 까먹지 않고\n꾸준히 체중을 기록할 수 있어요.',
          ),
          SpaceHeight(height: 100),
          ContentsBox(
            backgroundColor: const Color(0xffF5F6F6),
            contentsWidget: Column(
              children: [Row(children: []), CommonText(text: '', size: 15)],
            ),
          ),
          SpaceHeight(height: 10),
          ContentsBox(
            backgroundColor: const Color(0xffF5F6F6),
            contentsWidget: Column(
              children: [Row(children: []), CommonText(text: '', size: 15)],
            ),
          ),
        ],
      ),
      buttonEnabled: true,
      bottomSubmitButtonText: '알림을 받을게요!',
      onPressedBottomNavigationButton: onCompleted,
    );
  }
}
