import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/area/empty_area.dart';
import 'package:flutter_app_weight_management/components/button/ok_and_cancel_button.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/input/text_input.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/utils/class.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:flutter_app_weight_management/widgets/alert_dialog_title_widget.dart';

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
  MoreSeeItem.currentWeight: TextInputClass(
    maxLength: weightMaxLength,
    hintText: weightHintText,
    inputTextErr: InputTextErrorClass(
      min: weightMin,
      max: weightMax,
      errMsg: weightErrMsg,
    ),
    prefixIcon: weightPrefixIcon,
    suffixText: weightSuffixText,
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
    required this.title,
    required this.selectedMoreSeeItem,
    required this.selectedText,
  });

  String title;
  MoreSeeItem selectedMoreSeeItem;
  String selectedText;

  @override
  State<InputDialog> createState() => _InputDialogState();
}

class _InputDialogState extends State<InputDialog> {
  TextEditingController textInputController = TextEditingController();
  String? errorText;
  bool isPress = false;

  @override
  void initState() {
    textInputController.text = widget.selectedText;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    setErrorText() {
      TextInputClass data = textInputData[widget.selectedMoreSeeItem]!;

      return data.getErrorText(
        text: textInputController.text,
        min: data.inputTextErr.min,
        max: data.inputTextErr.max,
        errMsg: data.inputTextErr.errMsg,
      );
    }

    onChanged(String value) {
      setState(() {
        errorText = setErrorText();
        isPress = textInputController.text != '' && setErrorText() == null;
      });
    }

    onTapClose() {
      closeDialog(context);
    }

    onPressedOk() {
      //
    }

    onPressedCancel() {
      closeDialog(context);
    }

    TextInputClass? item = textInputData[widget.selectedMoreSeeItem];

    return AlertDialog(
      shape: containerBorderRadious,
      backgroundColor: dialogBackgroundColor,
      elevation: 0.0,
      title: AlertDialogTitleWidget(text: widget.title, onTap: onTapClose),
      content: ContentsBox(
        height: errorText == null ? 156 : 180,
        contentsWidget: Column(
          children: [
            item != null
                ? TextInput(
                    maxLength: item.maxLength,
                    prefixIcon: item.prefixIcon,
                    suffixText: item.suffixText,
                    hintText: item.hintText,
                    counterText: '',
                    errorText: errorText,
                    onChanged: onChanged,
                    controller: textInputController,
                  )
                : const EmptyArea(),
            SpaceHeight(height: regularSapce),
            OkAndCancelButton(
              okText: '확인',
              cancelText: '취소',
              onPressedOk: onPressedOk,
              onPressedCancel: onPressedCancel,
            )
          ],
        ),
      ),
    );
  }
}
