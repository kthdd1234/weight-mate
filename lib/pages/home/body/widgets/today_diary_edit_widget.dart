import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/button/ok_and_cancel_button.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/input/multi_line_text_input.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/provider/record_icon_type_provider.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';
import 'package:provider/provider.dart';

class TodayDiaryEditWidget extends StatefulWidget {
  TodayDiaryEditWidget({
    super.key,
    required this.text,
    required this.onPressedOk,
  });

  String text;
  Function(String text) onPressedOk;

  @override
  State<TodayDiaryEditWidget> createState() => _TodayDiaryEditWidgetState();
}

class _TodayDiaryEditWidgetState extends State<TodayDiaryEditWidget> {
  final TextEditingController textController = TextEditingController();
  final int textMaxLength = 200;

  @override
  void initState() {
    textController.text = widget.text;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    onEditingComplete() {
      widget.onPressedOk(textController.text);
      context
          .read<RecordIconTypeProvider>()
          .setSeletedRecordIconType(RecordIconTypes.none);
    }

    return ContentsBox(
      contentsWidget: Column(
        children: [
          SpaceHeight(height: tinySpace),
          MultiLineTextInput(
            hintText: '일기를 작성해주세요.',
            controller: textController,
            maxLength: textMaxLength,
            onEditingComplete: onEditingComplete,
            onTapOutside: onEditingComplete,
          ),
          SpaceHeight(height: smallSpace),
        ],
      ),
    );
  }
}
