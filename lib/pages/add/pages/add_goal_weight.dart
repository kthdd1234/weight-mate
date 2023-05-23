import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/dialog/calendar_default_dialog.dart';
import 'package:flutter_app_weight_management/components/info/color_text_info.dart';
import 'package:flutter_app_weight_management/components/input/text_input.dart';
import 'package:flutter_app_weight_management/components/simple_stepper/simple_stepper.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/components/text/contents_title_text.dart';
import 'package:flutter_app_weight_management/components/text/headline_text.dart';
import 'package:flutter_app_weight_management/pages/add/add_container.dart';
import 'package:flutter_app_weight_management/provider/diet_Info_provider.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:flutter_app_weight_management/widgets/date_time_range_input_widget.dart';
import 'package:provider/provider.dart';

class AddGoalWeight extends StatefulWidget {
  const AddGoalWeight({super.key});

  @override
  State<AddGoalWeight> createState() => _AddGoalWeightState();
}

class _AddGoalWeightState extends State<AddGoalWeight> {
  DateTime startDietDateTime = DateTime.now();
  DateTime? endDietDateTime;

  @override
  void initState() {
    super.initState();

    startDietDateTime = DateTime.now();
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
            .changeStartDietDateTime(startDietDateTime);

        context.read<DietInfoProvider>().changeEndDietDateTime(endDietDateTime);
      }

      return null;
    }

    onTitleWidget(String type) {
      final String text = type == 'start' ? '시작일' : '종료일';
      final Color color = type == 'start' ? buttonBackgroundColor : Colors.red;

      return [
        Text(
          '$text 설정',
          style: const TextStyle(color: buttonBackgroundColor, fontSize: 17),
        ),
        Row(
          children: [
            ColorTextInfo(
              width: smallSpace,
              height: smallSpace,
              text: text,
              color: color,
            ),
          ],
        )
      ];
    }

    onSubmit({type, Object? object}) {
      setState(() {
        if (object is DateTime) {
          type == 'start'
              ? startDietDateTime = object
              : endDietDateTime = object;
        }
      });

      closeDialog(context);
    }

    onTapInput({type, DateTime? dateTime}) {
      showDialog(
        context: context,
        builder: (BuildContext context) => CalendarDefaultDialog(
          type: type,
          titleWidgets: onTitleWidget(type),
          initialDateTime: dateTime,
          onSubmit: onSubmit,
          onCancel: () => closeDialog(context),
          minDate: type == 'end' ? startDietDateTime : null,
        ),
      );
    }

    return AddContainer(
      body: Column(
        children: [
          SimpleStepper(currentStep: 2),
          SpaceHeight(height: regularSapce),
          HeadlineText(text: '목표 체중과 기간을 입력해주세요.'),
          SpaceHeight(height: regularSapce),
          ContentsBox(
            height: null,
            contentsWidget: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                SpaceHeight(height: regularSapce),
                ContentsTitleText(text: '기간'),
                SpaceHeight(height: smallSpace),
                DateTimeRangeInputWidget(
                  startDietDateTime: startDietDateTime,
                  endDietDateTime: endDietDateTime,
                  onTapInput: onTapInput,
                ),
                SpaceHeight(height: smallSpace),
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
