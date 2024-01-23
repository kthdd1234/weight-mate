import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/common/CommonIcon.dart';
import 'package:flutter_app_weight_management/common/CommonText.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/framework/app_framework.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/main.dart';
import 'package:flutter_app_weight_management/model/record_box/record_box.dart';
import 'package:flutter_app_weight_management/pages/home/body/history/widget/history_container.dart';
import 'package:flutter_app_weight_management/pages/home/body/record/record_body.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:multi_value_listenable_builder/multi_value_listenable_builder.dart';

class PatialDeletePage extends StatelessWidget {
  const PatialDeletePage({super.key});

  @override
  Widget build(BuildContext context) {
    int recordKey = ModalRoute.of(context)!.settings.arguments as int;
    RecordBox recordInfo = recordRepository.recordBox.get(recordKey)!;

    return AppFramework(
      widget: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('부분 삭제', style: TextStyle(fontSize: 20)),
          backgroundColor: Colors.transparent,
          foregroundColor: themeColor,
          elevation: 0.0,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: MultiValueListenableBuilder(
              valueListenables: valueListenables,
              builder: ((context, values, child) {
                return Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          CommonIcon(
                            icon: Icons.remove_circle,
                            size: 13,
                            color: Colors.red,
                          ),
                          SpaceWidth(width: 3),
                          CommonText(
                            text: '버튼을 누르면 바로 삭제됩니다. ',
                            size: 12,
                            isBold: true,
                          ),
                        ],
                      ),
                      SpaceHeight(height: 10),
                      ContentsBox(
                        contentsWidget: HistoryContainer(
                          isRemoveMode: true,
                          recordInfo: recordInfo,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
