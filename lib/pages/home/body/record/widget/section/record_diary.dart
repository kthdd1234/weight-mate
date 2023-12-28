import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/area/empty_area.dart';
import 'package:flutter_app_weight_management/main.dart';
import 'package:flutter_app_weight_management/model/user_box/user_box.dart';
import 'package:flutter_app_weight_management/pages/home/body/record/widget/section/container/dot_container.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';

class RecordDiary extends StatelessWidget {
  const RecordDiary({super.key});

  @override
  Widget build(BuildContext context) {
    UserBox user = userRepository.user;
    List<String>? filterList = user.filterList;
    bool isContainDiary =
        filterList != null && filterList.contains(FILITER.diary.toString());

    onTap() {
      //
    }

    return Row(
      children: [
        isContainDiary
            ? DashContainer(
                height: 40,
                text: '일기 또는 메모',
                borderType: BorderType.RRect,
                radius: 10,
                onTap: onTap,
              )
            : const EmptyArea(),
      ],
    );
  }
}
