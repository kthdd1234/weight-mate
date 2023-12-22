import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/pages/home/body/record/widget/section/container/dot_container.dart';

class RecordDiary extends StatelessWidget {
  const RecordDiary({super.key});

  @override
  Widget build(BuildContext context) {
    onTap() {
      //
    }

    return Row(
      children: [
        DotContainer(
          height: 40,
          text: '일기 또는 메모',
          borderType: BorderType.RRect,
          radius: 10,
          onTap: onTap,
        ),
      ],
    );
  }
}
