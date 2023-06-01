import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/button/ok_and_cancel_button.dart';
import 'package:flutter_app_weight_management/components/input/multi_line_text_input.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/provider/diet_Info_provider.dart';
import 'package:flutter_app_weight_management/provider/record_icon_type_provider.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';
import 'package:provider/provider.dart';

class TodayMemoEditWidget extends StatefulWidget {
  TodayMemoEditWidget({
    super.key,
    required this.todayMemoText,
  });

  String todayMemoText;

  @override
  State<TodayMemoEditWidget> createState() => _TodayMemoEditWidgetState();
}

class _TodayMemoEditWidgetState extends State<TodayMemoEditWidget> {
  final TextEditingController textController = TextEditingController();
  final int textMaxLength = 200;
  bool isEnabledOnPressed = false;

  @override
  void initState() {
    textController.text = widget.todayMemoText;
    final bool isResult = widget.todayMemoText != '' &&
        widget.todayMemoText.length != textMaxLength;
    isEnabledOnPressed = isResult;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    onPressedOk() {
      // context.read<DietInfoProvider>().changeTodayMemoText(textController.text);
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
          hintText: '메모를 입력해주세요. (기분, 컨디션, 몸 상태 등등)',
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
