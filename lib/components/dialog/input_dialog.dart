import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/common/CommonBottomSheet.dart';
import 'package:flutter_app_weight_management/components/button/ok_and_cancel_button.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/input/text_input.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/utils/class.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';
import 'package:flutter_app_weight_management/utils/function.dart';

Map<MoreSeeItem, TextInputClass> textInputData = {
  MoreSeeItem.tall: TextInputClass(
    maxLength: tallMaxLength,
    hintText: tallHintText,
    inputTextErr: InputTextErrorClass(
      min: tallMin,
      max: tallMax,
      errMsg: tallErrMsg,
    ),
    prefixIcon: tallPrefixIcon,
    suffixText: tallSuffixText,
  ),
  MoreSeeItem.goalWeight: TextInputClass(
    maxLength: weightMaxLength,
    hintText: goalWeightHintText,
    inputTextErr: InputTextErrorClass(
      min: weightMin,
      max: weightMax,
      errMsg: weightErrMsg,
    ),
    prefixIcon: goalWeightPrefixIcon,
    suffixText: weightSuffixText,
  )
};

class InputDialog extends StatefulWidget {
  InputDialog({
    super.key,
    required this.id,
    required this.title,
    required this.selectedText,
    required this.onPressedOk,
  });

  MoreSeeItem id;
  String title;
  String? selectedText;
  Function(MoreSeeItem id, String text) onPressedOk;

  @override
  State<InputDialog> createState() => _InputDialogState();
}

class _InputDialogState extends State<InputDialog> {
  TextEditingController textInputController = TextEditingController();
  String? errorText;
  bool isPress = false;

  @override
  void initState() {
    textInputController.text = widget.selectedText!;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextInputClass? item = textInputData[widget.id]!;

    setErrorText() {
      return item.getErrorText(
        text: textInputController.text,
        min: item.inputTextErr.min,
        max: item.inputTextErr.max,
        errMsg: item.inputTextErr.errMsg,
      );
    }

    onChanged(String value) {
      if (double.tryParse(textInputController.text) == null) {
        textInputController.text = '';
      }

      setState(() {
        errorText = setErrorText();
        isPress = textInputController.text != '' && setErrorText() == null;
      });
    }

    onTapClose() {
      closeDialog(context);
    }

    onPressedCancel() {
      closeDialog(context);
    }

    return AlertDialog(
      shape: containerBorderRadious,
      backgroundColor: enableBackgroundColor,
      elevation: 0.0,
      title: DialogTitle(text: widget.title, onTap: onTapClose),
      content: ContentsBox(
        height: errorText == null ? 156 : 180,
        contentsWidget: Column(
          children: [
            TextInput(
              autofocus: true,
              maxLength: item.maxLength,
              prefixIcon: item.prefixIcon,
              suffixText: item.suffixText,
              hintText: item.hintText.tr(),
              counterText: '',
              errorText: errorText,
              onChanged: onChanged,
              controller: textInputController,
            ),
            SpaceHeight(height: regularSapce),
            OkAndCancelButton(
              okText: '확인',
              cancelText: '취소',
              onPressedOk: errorText == null
                  ? () => widget.onPressedOk(
                        widget.id,
                        textInputController.text,
                      )
                  : null,
              onPressedCancel: onPressedCancel,
            )
          ],
        ),
      ),
    );
  }
}
