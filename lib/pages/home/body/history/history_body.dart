import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/main.dart';
import 'package:flutter_app_weight_management/model/record_box/record_box.dart';
import 'package:flutter_app_weight_management/pages/home/body/history/widget/History_container.dart';
import 'package:flutter_app_weight_management/pages/home/body/history/widget/dash_divider.dart';

class HistoryBody extends StatelessWidget {
  const HistoryBody({super.key});

  @override
  Widget build(BuildContext context) {
    List<RecordBox> recordList = recordRepository.recordBox.values.toList();

    return Expanded(
      child: ListView(
        children: recordList
            .map((recordInfo) => Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: HistoryContainer(recordInfo: recordInfo),
                    ),
                    DashDivider(color: Colors.grey.shade400)
                  ],
                ))
            .toList()
            .reversed
            .toList(),
      ),
    );
  }
}
