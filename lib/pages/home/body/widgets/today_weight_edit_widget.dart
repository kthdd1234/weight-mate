import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/button/ok_and_cancel_button.dart';
import 'package:flutter_app_weight_management/components/input/text_input.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/provider/diet_Info_provider.dart';
import 'package:flutter_app_weight_management/provider/record_sub_type_provider.dart';
import 'package:flutter_app_weight_management/utils/class.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';
import 'package:provider/provider.dart';

class TodayWeightEditWidget extends StatefulWidget {
  TodayWeightEditWidget({
    super.key,
    required this.seletedRecordSubType,
    required this.weightText,
    required this.bodyFatText,
  });

  RecordSubTypes seletedRecordSubType = RecordSubTypes.none;
  String weightText, bodyFatText;

  @override
  State<TodayWeightEditWidget> createState() => _TodayWeightEditWidgetState();
}

class _TodayWeightEditWidgetState extends State<TodayWeightEditWidget> {
  final TextEditingController textInputController = TextEditingController();
  dynamic errorText;
  bool isEnabledOnPressed = true;

  setInputText() {
    switch (widget.seletedRecordSubType) {
      case RecordSubTypes.weightReRecood:
        textInputController.text = widget.weightText;

        break;

      case RecordSubTypes.enterBodyFat:
        textInputController.text = widget.bodyFatText;
        break;

      default:
    }

    checkEmptyText();
  }

  checkEmptyText() {
    isEnabledOnPressed = textInputController.text != '';
  }

  @override
  void initState() {
    setInputText();
    super.initState();
  }

  @override
  void didUpdateWidget(oldWidget) {
    setInputText();
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    textInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Map<RecordSubTypes, TextInputClass> textInputDatas = {
      RecordSubTypes.weightReRecood: TextInputClass(
        maxLength: tallMaxLength,
        prefixIcon: weightPrefixIcon,
        suffixText: 'kg',
        hintText: tallHintText,
        inputTextErr: InputTextErrorClass(
          min: weightMin,
          max: weightMax,
          errMsg: weightErrMsg,
        ),
      ),
      RecordSubTypes.enterBodyFat: TextInputClass(
        maxLength: bodyFatMaxLength,
        prefixIcon: bodyFatPrefixIcon,
        suffixText: '%',
        hintText: bodyFatHintText,
        inputTextErr: InputTextErrorClass(
          min: bodyFatMin,
          max: bodyFatMax,
          errMsg: bodyFatErrMsg,
        ),
      ),
    };

    setMaxLength() {
      return textInputDatas[widget.seletedRecordSubType]!.maxLength;
    }

    setPrefixIcon() {
      return textInputDatas[widget.seletedRecordSubType]!.prefixIcon;
    }

    setSuffixText() {
      return textInputDatas[widget.seletedRecordSubType]!.suffixText;
    }

    setHintText() {
      return textInputDatas[widget.seletedRecordSubType]!.hintText;
    }

    setErrorText() {
      var inputData = textInputDatas[widget.seletedRecordSubType]!;
      var inputTextErr = inputData.inputTextErr;

      return inputData.getErrorText(
        text: textInputController.text,
        min: inputTextErr.min,
        max: inputTextErr.max,
        errMsg: inputTextErr.errMsg,
      );
    }

    setOnChanged(String value) {
      setState(() {
        errorText = setErrorText();
        isEnabledOnPressed =
            textInputController.text != '' && setErrorText() == null;
      });
    }

    onPressedResister() {
      var resultText = textInputController.text;

      switch (widget.seletedRecordSubType) {
        case RecordSubTypes.weightReRecood:
          context.read<DietInfoProvider>().changeWeightText(resultText);
          break;
        case RecordSubTypes.enterBodyFat:
          // context.read<DietInfoProvider>().changeBodyFatText(resultText);
          break;

        default:
          break;
      }

      context
          .read<RecordSubTypeProvider>()
          .setSeletedRecordSubType(RecordSubTypes.none);
    }

    onPressedCancel() {
      context
          .read<RecordSubTypeProvider>()
          .setSeletedRecordSubType(RecordSubTypes.none);
    }

    return Column(
      children: [
        SpaceHeight(height: tinySpace),
        TextInput(
          maxLength: setMaxLength(),
          prefixIcon: setPrefixIcon(),
          suffixText: setSuffixText(),
          hintText: setHintText(),
          errorText: errorText,
          onChanged: setOnChanged,
          counterText: '',
          controller: textInputController,
        ),
        SpaceHeight(height: smallSpace),
        OkAndCancelButton(
          okText: '등록',
          cancelText: '취소',
          onPressedOk: isEnabledOnPressed ? onPressedResister : null,
          onPressedCancel: onPressedCancel,
        )
      ],
    );
  }
}
