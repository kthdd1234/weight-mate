import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/common/CommonBackground.dart';
import 'package:flutter_app_weight_management/common/CommonIcon.dart';
import 'package:flutter_app_weight_management/common/CommonScaffold.dart';
import 'package:flutter_app_weight_management/common/CommonText.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/main.dart';
import 'package:flutter_app_weight_management/model/record_box/record_box.dart';
import 'package:flutter_app_weight_management/pages/home/body/history/widget/history_container.dart';
import 'package:flutter_app_weight_management/pages/home/body/record/record_body.dart';
import 'package:flutter_app_weight_management/utils/class.dart';
import 'package:multi_value_listenable_builder/multi_value_listenable_builder.dart';

class PatialDeletePage extends StatefulWidget {
  const PatialDeletePage({super.key});

  @override
  State<PatialDeletePage> createState() => _PatialDeletePageState();
}

class _PatialDeletePageState extends State<PatialDeletePage> {
  @override
  Widget build(BuildContext context) {
    int recordKey = ModalRoute.of(context)!.settings.arguments as int;
    RecordBox recordInfo = recordRepository.recordBox.get(recordKey)!;

    return CommonBackground(
      child: CommonScaffold(
        appBarInfo: AppBarInfoClass(title: '부분 삭제'),
        body: SingleChildScrollView(
          child: MultiValueListenableBuilder(
            valueListenables: valueListenables,
            builder: (context, values, child) {
              return Column(
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
                        text: '버튼을 누르면 바로 삭제됩니다.',
                        size: 12,
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
              );
            },
          ),
        ),
      ),
    );
  }
}
