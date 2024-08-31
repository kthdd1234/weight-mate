// ignore_for_file: unnecessary_brace_in_string_interps, prefer_function_declarations_over_variables, use_build_context_synchronously
import 'dart:io';
import 'dart:math';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/common/CommonButton.dart';
import 'package:flutter_app_weight_management/common/CommonText.dart';
import 'package:flutter_app_weight_management/components/area/empty_area.dart';
import 'package:flutter_app_weight_management/components/bottomSheet/AdBottomSheet.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/etc/AdBottomSheet.dart';
import 'package:flutter_app_weight_management/main.dart';
import 'package:flutter_app_weight_management/model/record_box/record_box.dart';
import 'package:flutter_app_weight_management/model/user_box/user_box.dart';
import 'package:flutter_app_weight_management/pages/home/body/record/edit/container/title_container.dart';
import 'package:flutter_app_weight_management/provider/enabled_provider.dart';
import 'package:flutter_app_weight_management/provider/import_date_time_provider.dart';
import 'package:flutter_app_weight_management/provider/premium_provider.dart';
import 'package:flutter_app_weight_management/services/health_service.dart';
import 'package:flutter_app_weight_management/utils/class.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:flutter_app_weight_management/utils/variable.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class EditWeight extends StatefulWidget {
  EditWeight({super.key});

  @override
  State<EditWeight> createState() => _EditWeightState();
}

class _EditWeightState extends State<EditWeight> {
  TextEditingController textController = TextEditingController();
  bool isShowInput = false;
  bool isGoalWeight = false;

  @override
  Widget build(BuildContext context) {
    UserBox user = userRepository.user;
    DateTime importDateTime =
        context.watch<ImportDateTimeProvider>().getImportDateTime();
    int recordKey = getDateTimeToInt(importDateTime);
    RecordBox? recordInfo = recordRepository.recordBox.get(recordKey);
    bool isOpen = user.filterList?.contains(fWeight) == true;
    bool isPremium = context.watch<PremiumProvider>().isPremium;

    isError() {
      return isShowErorr(
        unit: user.weightUnit ?? 'kg',
        value: double.tryParse(textController.text),
      );
    }

    onInit() {
      setState(() {
        isShowInput = false;
        isGoalWeight = false;
        textController.text = '';
      });

      FocusScope.of(context).unfocus();
      context.read<EnabledProvider>().setEnabled(false);
    }

    onChangedText(_) {
      bool isInitText =
          isDoubleTryParse(text: textController.text) == false || isError();

      if (isInitText) {
        textController.text = '';
      }

      setState(() {});
      context.read<EnabledProvider>().setEnabled(!isInitText);
    }

    onSaveWeight(String value) async {
      if (isDoubleTryParse(text: value)) {
        double weight = stringToDouble(value);
        DateTime now = DateTime.now();
        DateTime weightDateTime = DateTime(
          importDateTime.year,
          importDateTime.month,
          importDateTime.day,
          now.hour,
          now.minute,
        );

        if (recordInfo == null) {
          await recordRepository.recordBox.put(
            recordKey,
            RecordBox(
              createDateTime: importDateTime,
              weightDateTime: weightDateTime,
              weight: stringToDouble(value),
            ),
          );

          onShowAd(context: context, category: '체중', isPremium: isPremium);
        } else if (recordInfo.weight == null) {
          recordInfo.weightDateTime = weightDateTime;
          recordInfo.weight = weight;

          await recordInfo.save();
          onShowAd(context: context, category: '체중', isPremium: isPremium);
        } else {
          recordInfo.weightDateTime = weightDateTime;
          recordInfo.weight = weight;

          await recordInfo.save();
        }

        onInit();
      }
    }

    onSaveGoalWeight() {
      if (isDoubleTryParse(text: textController.text)) {
        user.goalWeight = stringToDouble(textController.text);
        user.save();

        onInit();
        closeDialog(context);
      }
    }

    onCancel() {
      onInit();
      closeDialog(context);
    }

    onTapWeight() {
      setState(() {
        if (recordInfo?.weight != null) {
          textController.text = '${recordInfo!.weight}';
          context.read<EnabledProvider>().setEnabled(true);
        }

        isShowInput = true;
      });

      showModalBottomSheet(
        barrierColor: Colors.transparent,
        context: context,
        builder: (context) {
          return WeightButtonBottmSheet(
            onCompleted: () {
              onSaveWeight(textController.text);
              closeDialog(context);
            },
            onCancel: onCancel,
          );
        },
      ).whenComplete(() => onInit());
    }

    onTapGoalWeight() {
      setState(() {
        textController.text = '${user.goalWeight}';
        context.read<EnabledProvider>().setEnabled(true);
        isShowInput = true;
        isGoalWeight = true;
      });

      showModalBottomSheet(
        barrierColor: Colors.transparent,
        context: context,
        builder: (context) {
          return WeightButtonBottmSheet(
            onCompleted: onSaveGoalWeight,
            onCancel: onCancel,
          );
        },
      ).whenComplete(() => onInit());
    }

    onTapOpen() {
      isOpen ? user.filterList?.remove(fWeight) : user.filterList?.add(fWeight);
      user.save();
    }

    helperText() {
      int max = user.weightUnit == 'kg' ? kgMax.toInt() : lbMax.toInt();

      return textController.text == ''
          ? '1 ~ max 의 값을 입력해주세요.'.tr(namedArgs: {'max': '$max'})
          : null;
    }

    onTapWeightChart() {
      Navigator.pushNamed(context, '/weight-chart-page');
    }

    onSaveHealthWeight() async {
      HealthService healthService = HealthService();
      double? weight = await healthService.getHealthWeight(
        ctx: context,
        dateTime: importDateTime,
      );

      if (weight != null) await onSaveWeight('$weight');
    }

    onTapHealth() async {
      HealthService healthService = HealthService();
      bool isPermission = await healthService.isPermission;

      if (isPermission == false) {
        await healthService.requestAuthorization();
        onSaveHealthWeight();
      } else {
        onSaveHealthWeight();
      }
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: ContentsBox(
        contentsWidget: Column(
          children: [
            TitleContainer(
              isDivider: isOpen,
              title: isGoalWeight ? '목표 체중' : '체중',
              icon: isGoalWeight ? Icons.flag : Icons.monitor_weight_rounded,
              tags: [
                TagClass(
                  text:
                      '${recordInfo?.weight ?? '- '}${user.weightUnit ?? 'kg'}',
                  isNotTr: true,
                  color: 'indigo',
                  isHide: isOpen,
                  onTap: onTapOpen,
                ),
                TagClass(
                  text: '체중 모아보기',
                  color: 'indigo',
                  isHide: false,
                  onTap: onTapWeightChart,
                ),
                TagClass(
                  icon: isOpen
                      ? Icons.keyboard_arrow_down_rounded
                      : Icons.keyboard_arrow_right_rounded,
                  color: 'indigo',
                  onTap: onTapOpen,
                ),
              ],
              onTap: onTapOpen,
            ),
            isOpen
                ? isShowInput
                    ? TextFormField(
                        controller: textController,
                        keyboardType: inputKeyboardType,
                        autofocus: true,
                        maxLength: 5,
                        decoration: InputDecoration(
                          suffixText: user.weightUnit,
                          hintText: weightHintText.tr(),
                          helperText: helperText(),
                        ),
                        onChanged: onChangedText,
                        onEditingComplete: isGoalWeight
                            ? onSaveGoalWeight
                            : () {
                                onSaveWeight(textController.text);
                                closeDialog(context);
                              },
                      )
                    : recordInfo?.weight != null
                        ? WeeklyWeightGraph(
                            weight: recordInfo?.weight,
                            goalWeight: user.goalWeight,
                            importDateTime: importDateTime,
                            locale: context.locale.toString(),
                            onTapWeight: onTapWeight,
                            onTapGoalWeight: onTapGoalWeight,
                          )
                        : Column(
                            children: [
                              Row(
                                children: [
                                  CommonButton(
                                    text: '체중 기록하기',
                                    fontSize: 13,
                                    isBold: true,
                                    height: 50,
                                    bgColor: whiteBgBtnColor,
                                    radious: 7,
                                    textColor: indigo.s300,
                                    onTap: onTapWeight,
                                  ),
                                  Platform.isIOS
                                      ? Padding(
                                          padding:
                                              const EdgeInsets.only(left: 5),
                                          child: InkWell(
                                            onTap: onTapHealth,
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 20,
                                              ),
                                              height: 50,
                                              decoration: BoxDecoration(
                                                color: whiteBgBtnColor,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  7,
                                                ),
                                              ),
                                              child: getSvg(
                                                  name: 'health', width: 18),
                                            ),
                                          ),
                                        )
                                      : const EmptyArea()
                                ],
                              ),
                            ],
                          )
                : const EmptyArea()
          ],
        ),
      ),
    );
  }
}

class WeightButtonBottmSheet extends StatelessWidget {
  WeightButtonBottmSheet({
    super.key,
    required this.onCompleted,
    required this.onCancel,
  });

  Function() onCompleted, onCancel;

  @override
  Widget build(BuildContext context) {
    bool isEnabled = context.watch<EnabledProvider>().isEnabled;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        color: const Color(0xffCCCDD3),
        padding: const EdgeInsets.all(tinySpace),
        child: Row(
          children: [
            CommonButton(
              text: '취소',
              fontSize: 17,
              radious: 5,
              bgColor: Colors.white,
              textColor: textColor,
              onTap: onCancel,
            ),
            SpaceWidth(width: tinySpace),
            CommonButton(
              text: '완료',
              fontSize: 17,
              radious: 5,
              isBold: true,
              bgColor: isEnabled ? themeColor : Colors.grey.shade400,
              textColor: isEnabled ? Colors.white : Colors.grey.shade300,
              onTap: onCompleted,
            ),
          ],
        ),
      ),
    );
  }
}

class WeeklyWeightGraph extends StatefulWidget {
  WeeklyWeightGraph({
    super.key,
    required this.importDateTime,
    required this.weight,
    required this.goalWeight,
    required this.onTapWeight,
    required this.onTapGoalWeight,
    required this.locale,
  });

  String locale;
  DateTime importDateTime;
  double? weight, goalWeight;
  Function() onTapWeight, onTapGoalWeight;

  @override
  State<WeeklyWeightGraph> createState() => _WeeklyWeightGraphState();
}

class _WeeklyWeightGraphState extends State<WeeklyWeightGraph> {
  List<GraphData> dataSource = [];
  double? maximum, minimum;

  void initChart() {
    List<GraphData> lineSeriesData = [];
    List<double> weightList = [];

    for (var i = 0; i <= 3; i++) {
      DateTime subtractDateTime = jumpDayDateTime(
        type: jumpDayTypeEnum.subtract,
        dateTime: widget.importDateTime,
        days: i,
      );
      bool isToday = isCheckToday(subtractDateTime);
      int recordKey = getDateTimeToInt(subtractDateTime);
      RecordBox? recordInfo = recordRepository.recordBox.get(recordKey);
      String formatterDay = isToday
          ? '오늘'.tr()
          : d(locale: widget.locale, dateTime: subtractDateTime);
      GraphData graphData = GraphData(formatterDay, recordInfo?.weight);

      if (recordInfo?.weight != null) {
        weightList.add(recordInfo!.weight!);
      }

      lineSeriesData.add(graphData);
    }

    maximum = (weightList.reduce(max) + 1).floorToDouble();
    minimum = (weightList.reduce(min) - 1).floorToDouble();
    dataSource = lineSeriesData.reversed.toList();
  }

  @override
  void initState() {
    initChart();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant WeeklyWeightGraph oldWidget) {
    initChart();
    setState(() {});
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    UserBox user = userRepository.user;
    String weightUnit = user.weightUnit ?? 'kg';

    List<WeightButtonClass> weightButtonList = [
      WeightButtonClass(
        text: '현재 체중: ',
        imgNumber: '3',
        nameArgs: {'weight': '${widget.weight}', 'unit': weightUnit},
        onTap: widget.onTapWeight,
      ),
      WeightButtonClass(),
      WeightButtonClass(
        text: '목표 체중: ',
        imgNumber: '4',
        nameArgs: {'weight': '${widget.goalWeight}', 'unit': weightUnit},
        onTap: widget.onTapGoalWeight,
      ),
    ];

    return Column(
      children: [
        SizedBox(
          height: 300,
          child: SfCartesianChart(
            enableAxisAnimation: true,
            primaryXAxis: CategoryAxis(),
            primaryYAxis: NumericAxis(
              maximum: maximum,
              minimum: minimum,
              plotBands: [
                PlotBand(
                  dashArray: const [5, 5],
                  borderWidth: 1.0,
                  borderColor: disabledButtonTextColor,
                  isVisible: true,
                  text: '목표 체중: '.tr(
                    namedArgs: {
                      'weight': '${widget.goalWeight}',
                      'unit': weightUnit
                    },
                  ),
                  textStyle: const TextStyle(color: disabledButtonTextColor),
                  start: widget.goalWeight,
                  end: widget.goalWeight,
                )
              ],
            ),
            tooltipBehavior: TooltipBehavior(
              enable: true,
              header: '',
              format: 'point.x: point.y$weightUnit',
            ),
            series: [
              FastLineSeries(
                emptyPointSettings:
                    EmptyPointSettings(mode: EmptyPointMode.drop),
                enableTooltip: true,
                markerSettings: const MarkerSettings(isVisible: true),
                dataLabelSettings: DataLabelSettings(
                  isVisible: true,
                  useSeriesColor: true,
                  textStyle: TextStyle(
                    color: indigo.s300,
                    fontWeight: FontWeight.w600,
                    fontSize: 10,
                  ),
                ),
                color: indigo.s50,
                dataSource: dataSource,
                xValueMapper: (data, _) => data.x,
                yValueMapper: (data, _) => data.y,
              )
            ],
          ),
        ),
        SpaceHeight(height: tinySpace),
        Row(
          children: weightButtonList
              .map(
                (button) => button.text != null
                    ? Expanded(
                        child: GestureDetector(
                        onTap: button.onTap,
                        child: ContentsBox(
                          borderRadius: 5,
                          padding: const EdgeInsets.all(smallSpace),
                          imgUrl: 'assets/images/t-${button.imgNumber}.png',
                          contentsWidget: CommonText(
                            text: button.text!,
                            size: 13,
                            color: Colors.white,
                            isBold: true,
                            isCenter: true,
                            nameArgs: button.nameArgs,
                          ),
                        ),
                      ))
                    : SpaceWidth(width: tinySpace),
              )
              .toList(),
        )
      ],
    );
  }
}
