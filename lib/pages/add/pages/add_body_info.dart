import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/input/text_input.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/components/text/bottom_text.dart';
import 'package:flutter_app_weight_management/components/text/contents_title_text.dart';
import 'package:flutter_app_weight_management/pages/add/add_container.dart';
import 'package:flutter_app_weight_management/provider/diet_Info_provider.dart';
import 'package:flutter_app_weight_management/services/notifi_service.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:flutter_app_weight_management/widgets/add_title_widget.dart';
import 'package:flutter_app_weight_management/widgets/alarm_item_widget.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class AddBodyInfo extends StatefulWidget {
  const AddBodyInfo({super.key});

  @override
  State<AddBodyInfo> createState() => _AddBodyInfoState();
}

class _AddBodyInfoState extends State<AddBodyInfo> {
  late DateTime timeValue;

  @override
  void initState() {
    setPermission() async {
      bool isPermission = await NotificationService().permissionNotification;

      if (isPermission == false) {
        await NotificationService().requestPermission();
      }
    }

    setPermission();

    DateTime now = DateTime.now();
    timeValue = DateTime(now.year, now.month, now.day, 10, 30);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final watchProvider = context.watch<DietInfoProvider>();
    final readProvider = context.read<DietInfoProvider>();

    final tallText = watchProvider.getTallText();
    final weightText = watchProvider.getWeightText();
    final goalWeightText = watchProvider.getGoalWeightText();
    final isAlarm = watchProvider.getIsAlarm();
    final alarmTime = watchProvider.getAlarmTime();

    onChangedTallText(value) {
      context.read<DietInfoProvider>().changeTallText(value);
    }

    onChangedWeightText(value) {
      context.read<DietInfoProvider>().changeWeightText(value);
    }

    onChangedGoalWeightText(value) {
      context.read<DietInfoProvider>().changeGoalWeightText(value);
    }

    setErrorTextTall() {
      return handleCheckErrorText(
        text: tallText,
        min: tallMin,
        max: tallMax,
        errMsg: tallErrMsg,
      );
    }

    setErrorTextWeight() {
      return handleCheckErrorText(
        text: weightText,
        min: weightMin,
        max: weightMax,
        errMsg: weightErrMsg,
      );
    }

    setErrorTextGoalWeight() {
      return handleCheckErrorText(
        text: goalWeightText,
        min: weightMin,
        max: weightMax,
        errMsg: weightErrMsg,
      );
    }

    buttonEnabled() {
      return tallText != '' &&
          weightText != '' &&
          goalWeightText != '' &&
          setErrorTextTall() == null &&
          setErrorTextWeight() == null &&
          setErrorTextGoalWeight() == null;
    }

    onPressedBottomNavigationButton() {
      if (buttonEnabled()) {
        Navigator.pushNamed(
          context,
          '/add-plan-type',
          arguments: ArgmentsTypeEnum.start,
        );
      }

      return null;
    }

    bodyInputWidget({
      required String title,
      required int maxLength,
      required IconData? prefixIcon,
      required String suffixText,
      required String counterText,
      required String hintText,
      required dynamic errorText,
      required Function(String) onChanged,
    }) {
      return Column(
        children: [
          ContentsTitleText(text: title),
          SpaceHeight(height: smallSpace),
          TextInput(
            maxLength: maxLength,
            prefixIcon: prefixIcon,
            suffixText: suffixText,
            counterText: counterText,
            hintText: hintText,
            errorText: errorText,
            onChanged: onChanged,
          )
        ],
      );
    }

    onChanged(bool newValue) async {
      if (newValue) {
        final isPermission = await NotificationService().permissionNotification;

        if (isPermission == false) {
          // ignore: use_build_context_synchronously
          showSnackBar(
            context: context,
            width: 270,
            text: '알림 권한이 없어요.',
            buttonName: '설정창으로 이동',
            onPressed: openAppSettings,
          );
        }
      }

      readProvider.changeIsAlarm(newValue);
    }

    onDateTimeChanged(DateTime value) {
      setState(() => timeValue = value);
    }

    onSubmit() {
      readProvider.changeAlarmTime(timeValue);
      closeDialog(context);
    }

    onTap(dynamic id) {
      showAlarmBottomSheet(
        context: context,
        initialDateTime: alarmTime!,
        onDateTimeChanged: onDateTimeChanged,
        onSubmit: onSubmit,
      );
    }

    bodyAlarmWidget() {
      return Column(
        children: [
          ContentsTitleText(text: '알림 설정'),
          SpaceHeight(height: regularSapce),
          AlarmItemWidget(
            id: 'weight-alarm',
            title: '체중 기록 알림',
            desc: '정해진 시간에 알림을 드려요.',
            isEnabled: isAlarm,
            alarmTime: alarmTime,
            icon: Icons.notifications_active,
            iconBackgroundColor: dialogBackgroundColor,
            chipBackgroundColor: dialogBackgroundColor,
            onChanged: onChanged,
            onTap: onTap,
          ),
        ],
      );
    }

    return AddContainer(
      body: Column(
        children: [
          AddTitleWidget(
            argmentsType: ArgmentsTypeEnum.start,
            step: 1,
            title: '프로필 정보를 입력해주세요.',
          ),
          ContentsBox(
            contentsWidget: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: bodyInputWidget(
                        title: '키',
                        maxLength: 5,
                        prefixIcon: Icons.accessibility_new_sharp,
                        suffixText: 'cm',
                        counterText: ' ',
                        hintText: '키',
                        errorText: setErrorTextTall(),
                        onChanged: onChangedTallText,
                      ),
                    ),
                    SpaceWidth(width: smallSpace),
                    Expanded(
                      child: bodyInputWidget(
                        title: '체중',
                        maxLength: 4,
                        prefixIcon: Icons.monitor_weight,
                        suffixText: 'kg',
                        counterText: ' ',
                        hintText: '체중',
                        errorText: setErrorTextWeight(),
                        onChanged: onChangedWeightText,
                      ),
                    ),
                  ],
                ),
                SpaceHeight(height: regularSapce),
                bodyInputWidget(
                  title: '목표 체중',
                  maxLength: 4,
                  prefixIcon: Icons.flag,
                  suffixText: 'kg',
                  counterText: ' ',
                  hintText: '목표 체중',
                  errorText: setErrorTextGoalWeight(),
                  onChanged: onChangedGoalWeightText,
                ),
                SpaceHeight(height: regularSapce),
                bodyAlarmWidget(),
                SpaceHeight(height: smallSpace),
              ],
            ),
          ),
          SpaceHeight(height: regularSapce),
          BottomText(bottomText: '키와 몸무게는 체질량 지수(BMI)를 계산하는데 사용됩니다.')
        ],
      ),
      bottomSubmitButtonText: '다음',
      buttonEnabled: buttonEnabled(),
      onPressedBottomNavigationButton: onPressedBottomNavigationButton,
    );
  }
}
