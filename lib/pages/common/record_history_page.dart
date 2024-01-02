import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/framework/app_framework.dart';
import 'package:flutter_app_weight_management/main.dart';
import 'package:flutter_app_weight_management/model/record_box/record_box.dart';
import 'package:flutter_app_weight_management/pages/home/body/record/edit/edit_container.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';
import 'package:hive/hive.dart';

class RecordHistoryPage extends StatelessWidget {
  const RecordHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    Box<RecordBox> recordBox = recordRepository.recordBox;

    return AppFramework(
      widget: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('2024년', style: TextStyle(color: themeColor)),
          backgroundColor: Colors.transparent,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              EditContainer(
                setActiveCamera: (_) {},
                importDateTime: DateTime.now(),
                recordType: RECORD.history,
              ),
              DashDivider(color: Colors.grey.shade400)
            ],
          ),
        ),
      ),
    );
  }
}

class DashDivider extends StatelessWidget {
  DashDivider({Key? key, this.height = 1, this.color = Colors.black})
      : super(key: key);

  double height;
  Color color;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        const dashWidth = 8.0;
        final dashHeight = height;
        final dashCount = (boxWidth / (2 * dashWidth)).floor();

        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: regularSapce,
            vertical: smallSpace,
          ),
          child: Flex(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            direction: Axis.horizontal,
            children: List.generate(dashCount, (_) {
              return SizedBox(
                width: dashWidth,
                height: dashHeight,
                child: DecoratedBox(
                  decoration: BoxDecoration(color: color),
                ),
              );
            }),
          ),
        );
      },
    );
  }
}
