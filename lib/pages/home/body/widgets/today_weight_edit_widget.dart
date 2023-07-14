import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/button/ok_and_cancel_button.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/dialog/native_ad_dialog.dart';
import 'package:flutter_app_weight_management/components/input/text_input.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/model/record_box/record_box.dart';
import 'package:flutter_app_weight_management/model/user_box/user_box.dart';
import 'package:flutter_app_weight_management/provider/bottom_navigation_provider.dart';
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

    checkText();
  }

  checkText() {
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

    textInputController.selection = TextSelection.fromPosition(
        TextPosition(offset: textInputController.text.length));

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
      if (double.tryParse(textInputController.text) == null) {
        textInputController.text = '';
      }

      setState(() {
        errorText = setErrorText();
        isEnabledOnPressed =
            textInputController.text != '' && setErrorText() == null;
      });
    }

    onPressedResister() {
      UserBox? userProfile = userBox.get('userProfile');
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
                createDateTime: widget.importDateTime,
                weightDateTime: DateTime.now(),
                weight: stringToDouble(text),
              ),
            );
          } else {
            recordInfo.weightDateTime = DateTime.now();
            recordInfo.weight = stringToDouble(text);
            recordBox.put(importDateTimeInt, recordInfo);
          }

          showDialog(
            context: context,
            builder: (dialogContext) {
              onClick(BottomNavigationEnum enumId) async {
                closeDialog(dialogContext);
                dialogContext
                    .read<BottomNavigationProvider>()
                    .setBottomNavigation(enumId: enumId);
              }

              setTitleText() {
                List<RecordBox> valueList = recordBox.values.toList();
                List<RecordBox> recordList =
                    valueList.where((e) => e.weight != null).toList();

                return '👏🏻 ${recordList.length}일째 기록 했어요!';
              }

              return NativeAdDialog(
                title: setTitleText(),
                leftText: '달력 보기',
                rightText: '체중 보기',
                leftIcon: Icons.calendar_month,
                rightIcon: Icons.auto_graph_rounded,
                onLeftClick: () => onClick(BottomNavigationEnum.calendar),
                onRightClick: () => onClick(BottomNavigationEnum.analyze),
              );
            },
          );

          break;

        case RecordIconTypes.editGoalWeight:
          if (userProfile == null) return null;

          userProfile.goalWeight = stringToDouble(text);
          userProfile.save();
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
      contentsWidget: Column(
        children: [
          TextInput(
            controller: textInputController,
            autofocus: true,
            maxLength: inputDatas.maxLength,
            prefixIcon: inputDatas.prefixIcon,
            suffixText: inputDatas.suffixText,
            hintText: inputDatas.hintText,
            errorText: errorText,
            onChanged: setOnChanged,
            counterText: '',
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
