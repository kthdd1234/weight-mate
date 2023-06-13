import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/button/ok_and_cancel_button.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/input/text_input.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/model/record_box/record_box.dart';
import 'package:flutter_app_weight_management/model/user_box/user_box.dart';
import 'package:flutter_app_weight_management/provider/record_icon_type_provider.dart';
import 'package:flutter_app_weight_management/utils/class.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

class TodayWeightEditWidget extends StatefulWidget {
  TodayWeightEditWidget({
    super.key,
    required this.importDateTime,
    required this.seletedRecordIconType,
    required this.weightText,
    required this.goalWeightText,
  });

  RecordIconTypes seletedRecordIconType = RecordIconTypes.none;
  String weightText;
  String goalWeightText;
  DateTime importDateTime;

  @override
  State<TodayWeightEditWidget> createState() => _TodayWeightEditWidgetState();
}

class _TodayWeightEditWidgetState extends State<TodayWeightEditWidget> {
  late Box<UserBox> userBox;
  late Box<RecordBox> recordBox;

  TextEditingController textInputController = TextEditingController();
  dynamic errorText;
  bool isEnabledOnPressed = true;

  setInputText() {
    switch (widget.seletedRecordIconType) {
      case RecordIconTypes.addWeight:
      case RecordIconTypes.editWeight:
        textInputController.text = widget.weightText;
        break;

      case RecordIconTypes.editGoalWeight:
        textInputController.text = widget.goalWeightText;
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
    super.initState();

    setInputText();

    userBox = Hive.box<UserBox>('userBox');
    recordBox = Hive.box<RecordBox>('recordBox');
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
    Map<RecordIconTypes, TextInputClass> textInputDatas = {
      RecordIconTypes.addWeight: TextInputClass(
        maxLength: weightMaxLength,
        prefixIcon: weightPrefixIcon,
        suffixText: 'kg',
        hintText: weightHintText,
        inputTextErr: InputTextErrorClass(
          min: weightMin,
          max: weightMax,
          errMsg: weightErrMsg,
        ),
      ),
      RecordIconTypes.editWeight: TextInputClass(
        maxLength: weightMaxLength,
        prefixIcon: weightPrefixIcon,
        suffixText: 'kg',
        hintText: weightHintText,
        inputTextErr: InputTextErrorClass(
          min: weightMin,
          max: weightMax,
          errMsg: weightErrMsg,
        ),
      ),
      RecordIconTypes.editGoalWeight: TextInputClass(
        maxLength: weightMaxLength,
        prefixIcon: goalWeightPrefixIcon,
        suffixText: 'kg',
        hintText: goalWeightHintText,
        inputTextErr: InputTextErrorClass(
          min: weightMin,
          max: weightMax,
          errMsg: weightErrMsg,
        ),
      ),
    };

    TextInputClass inputDatas = textInputDatas[widget.seletedRecordIconType]!;

    setErrorText() {
      TextInputClass inputData = textInputDatas[widget.seletedRecordIconType]!;
      InputTextErrorClass inputTextErr = inputData.inputTextErr;

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
      UserBox? userInfo = userBox.get('userBox');
      int importDateTimeInt = getDateTimeToInt(widget.importDateTime);
      RecordBox? recordInfo = recordBox.get(importDateTimeInt);
      String text = textInputController.text;

      switch (widget.seletedRecordIconType) {
        case RecordIconTypes.addWeight:
        case RecordIconTypes.editWeight:
          if (recordInfo == null) {
            recordBox.put(
              importDateTimeInt,
              RecordBox(
                recordDateTime: widget.importDateTime,
                weight: stringToDouble(text),
                actions: [],
              ),
            );

            break;
          }

          recordInfo.recordDateTime = widget.importDateTime;
          recordInfo.weight = stringToDouble(text);
          recordBox.put(importDateTimeInt, recordInfo);

          break;

        case RecordIconTypes.editGoalWeight:
          if (userInfo == null) return null;

          userInfo.goalWeight = stringToDouble(text);
          userBox.put('userBox', userInfo);
          break;

        default:
          break;
      }

      context
          .read<RecordIconTypeProvider>()
          .setSeletedRecordIconType(RecordIconTypes.none);
    }

    onPressedCancel() {
      context
          .read<RecordIconTypeProvider>()
          .setSeletedRecordIconType(RecordIconTypes.none);
    }

    return ContentsBox(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
      backgroundColor: Colors.white,
      contentsWidget: Column(
        children: [
          TextInput(
            autofocus: true,
            maxLength: inputDatas.maxLength,
            prefixIcon: inputDatas.prefixIcon,
            suffixText: inputDatas.suffixText,
            hintText: inputDatas.hintText,
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
      ),
    );
  }
}
