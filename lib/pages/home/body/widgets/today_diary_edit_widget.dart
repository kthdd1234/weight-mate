import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/button/ok_and_cancel_button.dart';
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
  bool isEnabledOnPressed = false;

  @override
  void initState() {
    textController.text = widget.text;
    final bool isResult =
        widget.text != '' && widget.text.length != textMaxLength;
    isEnabledOnPressed = isResult;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    onPressedOk() {
      widget.onPressedOk(textController.text);
      context
          .read<RecordIconTypeProvider>()
          .setSeletedRecordIconType(RecordIconTypes.none);
    }

    onPressedCancel() {
      context
          .read<RecordIconTypeProvider>()
          .setSeletedRecordIconType(RecordIconTypes.none);
    }

    onChanged(String value) {
      final bool isResult = textController.text != '' &&
          textController.text.length != textMaxLength;

      setState(() => isEnabledOnPressed = isResult);
    }

    return Column(
      children: [
        SpaceHeight(height: tinySpace),
        MultiLineTextInput(
          hintText: '일기를 작성해주세요.',
          controller: textController,
          maxLength: textMaxLength,
          onChanged: onChanged,
        ),
        SpaceHeight(height: smallSpace),
        OkAndCancelButton(
          okText: '추가',
          cancelText: '취소',
          onPressedOk: isEnabledOnPressed ? onPressedOk : null,
          onPressedCancel: onPressedCancel,
        )
      ],
    );
  }
}
