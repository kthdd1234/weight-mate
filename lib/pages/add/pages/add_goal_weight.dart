import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/dialog/calendar_range_dialog.dart';
import 'package:flutter_app_weight_management/components/input/date_input.dart';
import 'package:flutter_app_weight_management/components/input/text_input.dart';
import 'package:flutter_app_weight_management/components/simple_stepper/simple_stepper.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/text/contents_title_text.dart';
import 'package:flutter_app_weight_management/components/text/headline_text.dart';
import 'package:flutter_app_weight_management/pages/add/add_container.dart';
import 'package:flutter_app_weight_management/provider/diet_Info_provider.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class AddGoalWeight extends StatefulWidget {
  const AddGoalWeight({super.key});

  @override
  State<AddGoalWeight> createState() => _AddGoalWeightState();
}

class _AddGoalWeightState extends State<AddGoalWeight> {
  List<DateTime?> startAndEndDateTime = [null, null];
  String startDietDay = '';
  String endDietDay = '';

  @override
  void initState() {
    super.initState();

    DateTime now = DateTime.now();
    var strToday = getDateTimeToStr(now);

    setState(() {
      startAndEndDateTime = [now, null];
      startDietDay = strToday;
    });
  }

  @override
  Widget build(BuildContext context) {
    final goalWeight = context.watch<DietInfoProvider>().getGoalWeightText();

    onChangeGoalWeightText(String text) {
      context.read<DietInfoProvider>().changeGoalWeightText(text);
    }

    setErrorTextGoalWeight() {
      return handleCheckErrorText(
        text: goalWeight,
        min: weightMin,
        max: weightMax,
        errMsg: weightErrMsg,
      );
    }

    onCheckedButtonEnabled() {
      return goalWeight != '' && setErrorTextGoalWeight() == null;
    }

    onPressedBottomNavigationButton() {
      if (onCheckedButtonEnabled()) {
        Navigator.pushNamed(context, '/add-todo-list');
        context
            .read<DietInfoProvider>()
            .changeStartAndEndDateTime(startAndEndDateTime);
      }

      return null;
    }

    onSubmit(Object? object) {
      if (object != null) {
        setState(() {
          if (object is PickerDateRange) {
            DateTime? startDate = object.startDate ?? object.startDate;
            DateTime? endDate = object.endDate ?? object.endDate;

            startAndEndDateTime[0] = startDate;
            startAndEndDateTime[1] = endDate;
          }
        });

        closeDialog(context);
      }
    }

    onCancel() {
      closeDialog(context);
    }

    onTap() {
      showDialog(
        context: context,
        builder: (BuildContext context) => CalenderRangeDialog(
          labelText: '달력',
          startAndEndDateTime: startAndEndDateTime,
          onSubmit: onSubmit,
          onCancel: onCancel,
        ),
      );
    }

    onStartDietDayText() {
      return startAndEndDateTime[0] != null
          ? startDietDay = getDateTimeToStr(startAndEndDateTime[0]!)
          : '시작일';
    }

    onEndDietDayText() {
      return startAndEndDateTime[1] != null
          ? endDietDay = getDateTimeToStr(startAndEndDateTime[1]!)
          : '종료일 ';
    }

    return AddContainer(
      body: Column(
        children: [
          SimpleStepper(currentStep: 2),
          SpaceHeight(height: regularSapce),
          HeadlineText(text: '다이어트 기간과 목표 체중을'),
          SpaceHeight(height: tinySpace),
          HeadlineText(text: '입력해주세요.'),
          SpaceHeight(height: regularSapce),
          ContentsBox(
            height: null,
            contentsWidget: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ContentsTitleText(text: '다이어트 기간'),
                SpaceHeight(height: smallSpace),
                DateInput(
                  prefixIcon: Icons.calendar_month_sharp,
                  text: '${onStartDietDayText()} ~ ${onEndDietDayText()}',
                  onTap: onTap,
                ),
                SpaceHeight(height: largeSpace),
                ContentsTitleText(text: '목표 체중'),
                TextInput(
                  maxLength: 4,
                  prefixIcon: Icons.flag,
                  suffixText: 'kg',
                  hintText: '목표 체중을 입력해주세요.',
                  errorText: setErrorTextGoalWeight(),
                  counterText: '(예: 59, 63.5)',
                  onChanged: onChangeGoalWeightText,
                ),
              ],
            ),
          )
        ],
      ),
      bottomSubmitButtonText: '다음',
      buttonEnabled: onCheckedButtonEnabled(),
      onPressedBottomNavigationButton: onPressedBottomNavigationButton,
      actions: [],
    );
  }
}
