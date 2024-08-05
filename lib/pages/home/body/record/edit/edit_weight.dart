// ignore_for_file: unnecessary_brace_in_string_interps, prefer_function_declarations_over_variables
import 'dart:math';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/common/CommonButton.dart';
import 'package:flutter_app_weight_management/common/CommonText.dart';
import 'package:flutter_app_weight_management/widgets/area/empty_area.dart';
import 'package:flutter_app_weight_management/widgets/bottomSheet/WeightBottomSheet.dart';
import 'package:flutter_app_weight_management/widgets/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/widgets/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/widgets/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/main.dart';
import 'package:flutter_app_weight_management/model/record_box/record_box.dart';
import 'package:flutter_app_weight_management/model/user_box/user_box.dart';
import 'package:flutter_app_weight_management/pages/home/body/record/edit/container/title_container.dart';
import 'package:flutter_app_weight_management/provider/enabled_provider.dart';
import 'package:flutter_app_weight_management/provider/import_date_time_provider.dart';
import 'package:flutter_app_weight_management/utils/class.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:flutter_app_weight_management/utils/variable.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:url_launcher/url_launcher.dart';

class EditWeight extends StatefulWidget {
  EditWeight({super.key});

  @override
  State<EditWeight> createState() => _EditWeightState();
}

class _EditWeightState extends State<EditWeight> {
  TextEditingController textController = TextEditingController();
  String weightType = '';
  bool isShowInput = false;
  // bool isGoalWeight = false;

  @override
  Widget build(BuildContext context) {
    DateTime importDateTime =
        context.watch<ImportDateTimeProvider>().getImportDateTime();
    int recordKey = getDateTimeToInt(importDateTime);
    RecordBox? recordInfo = recordRepository.recordBox.get(recordKey);
    UserBox user = userRepository.user;
    String weightUnit = user.weightUnit ?? 'kg';
    bool? isOpen = user.filterList?.contains(fWeight) == true;
    Color borderColor = weightType == eWeightMorning ? indigo.s200 : red.s200;
    bool isWeight =
        recordInfo?.weight != null || recordInfo?.weightNight != null;

    isError() {
      return isShowErorr(
        unit: weightUnit,
        value: double.tryParse(textController.text),
      );
    }

    onInit() {
      setState(() {
        textController.text = '';
        isShowInput = false;
        weightType = '';
        // isGoalWeight = false;
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

    onSaveWeight() async {
      if (isDoubleTryParse(text: textController.text)) {
        DateTime now = DateTime.now();
        double weight = stringToDouble(textController.text);
        bool isWeightMorning = weightType == eWeightMorning;

        if (recordInfo == null) {
          recordRepository.recordBox.put(
            recordKey,
            RecordBox(
              createDateTime: importDateTime,
              weightDateTime: isWeightMorning ? now : null,
              weight: isWeightMorning ? weight : null,
              weightNightDateTime: isWeightMorning ? null : now,
              weightNight: isWeightMorning ? null : weight,
            ),
          );
        } else {
          if (isWeightMorning) {
            recordInfo.weightDateTime = now;
            recordInfo.weight = weight;
          } else {
            recordInfo.weightNightDateTime = now;
            recordInfo.weightNight = weight;
          }
        }

        await recordInfo?.save();

        onInit();
        closeDialog(context);
      }
    }

    // onSaveGoalWeight() {
    //   if (isDoubleTryParse(text: textController.text)) {
    //     user.goalWeight = stringToDouble(textController.text);
    //     user.save();

    //     onInit();
    //     closeDialog(context);
    //   }
    // }

    onCancel() {
      onInit();
      closeDialog(context);
    }

    onTapWeight(String type) {
      setState(() {
        textController.text = type == eWeightMorning
            ? '${recordInfo?.weight ?? ''}'
            : '${recordInfo?.weightNight ?? ''}';
        weightType = type;
        isShowInput = true;

        context.read<EnabledProvider>().setEnabled(true);
      });

      showModalBottomSheet(
        barrierColor: Colors.transparent,
        context: context,
        builder: (context) {
          return WeightBottmSheet(
            onCompleted: onSaveWeight,
            onCancel: onCancel,
          );
        },
      ).whenComplete(() => onInit());
    }

    // onTapGoalWeight() {
    //   setState(() {
    //     textController.text = '${user.goalWeight}';
    //     context.read<EnabledProvider>().setEnabled(true);
    //     isShowInput = true;
    //     isGoalWeight = true;
    //   });

    //   showModalBottomSheet(
    //     barrierColor: Colors.transparent,
    //     context: context,
    //     builder: (context) {
    //       return WeightButtonBottmSheet(
    //         onCompleted: onSaveGoalWeight,
    //         onCancel: onCancel,
    //       );
    //     },
    //   ).whenComplete(() => onInit());
    // }

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

    button({
      required String text,
      required Color textColor,
      required Color bgColor,
      required Function() onTap,
    }) {
      return CommonButton(
        text: text,
        fontSize: 13,
        isBold: true,
        height: 50,
        textColor: textColor,
        bgColor: bgColor,
        radious: 7,
        onTap: onTap,
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: ContentsBox(
        child: Column(
          children: [
            TitleContainer(
              isDivider: isOpen,
              title: '체중',
              svg: 't-weight',
              tags: [
                TagClass(
                  text:
                      '아침 ${recordInfo?.weight ?? '-'}${weightUnit}, 저녁 ${recordInfo?.weightNight ?? '-'}${weightUnit}',
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
                        cursorColor: borderColor,
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: borderColor),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: borderColor),
                          ),
                          suffixText: user.weightUnit,
                          hintText:
                              '${weightType == eWeightMorning ? '아침' : '저녁'} ${weightHintText}.'
                                  .tr(),
                          helperText: helperText(),
                        ),
                        onChanged: onChangedText,
                        onEditingComplete: onSaveWeight,
                      )
                    : Column(
                        children: [
                          isWeight
                              ? WeeklyWeightGraph(
                                  locale: context.locale.toString(),
                                  weightType: weightType,
                                  weight: recordInfo?.weight,
                                  goalWeight: user.goalWeight,
                                  importDateTime: importDateTime,
                                  onTapWeight: onTapWeight,
                                  // onTapGoalWeight: onTapGoalWeight,
                                )
                              : const EmptyArea(),
                          Row(
                            children: [
                              button(
                                text: recordInfo?.weight != null
                                    ? '아침: ${recordInfo!.weight}$weightUnit'
                                    : '아침 기록',
                                textColor: indigo.s300,
                                bgColor: whiteBgBtnColor,
                                onTap: () => onTapWeight(eWeightMorning),
                              ),
                              SpaceWidth(width: 5),
                              button(
                                text: recordInfo?.weightNight != null
                                    ? '저녁: ${recordInfo!.weightNight}$weightUnit'
                                    : '저녁 기록',
                                textColor: red.s300,
                                bgColor: red.s50,
                                onTap: () => onTapWeight(eWeightNight),
                              ),
                            ],
                          )
                        ],
                      )
                : const EmptyArea()
          ],
        ),
      ),
    );
  }
}

class WeeklyWeightGraph extends StatefulWidget {
  WeeklyWeightGraph({
    super.key,
    required this.locale,
    required this.weightType,
    required this.importDateTime,
    required this.weight,
    required this.goalWeight,
    required this.onTapWeight,
    // required this.onTapGoalWeight,
  });

  String locale, weightType;
  DateTime importDateTime;
  double? weight, goalWeight;
  Function(String) onTapWeight;
  // Function() onTapGoalWeight;

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

    return Container(
      padding: const EdgeInsets.only(bottom: 10),
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
            emptyPointSettings: EmptyPointSettings(mode: EmptyPointMode.drop),
            enableTooltip: true,
            markerSettings: const MarkerSettings(isVisible: true),
            dataLabelSettings: DataLabelSettings(
              isVisible: true,
              useSeriesColor: true,
              textStyle: TextStyle(
                color: indigo.s200,
                fontWeight: FontWeight.bold,
              ),
            ),
            color: indigo.s50,
            dataSource: dataSource,
            xValueMapper: (data, _) => data.x,
            yValueMapper: (data, _) => data.y,
          )
        ],
      ),
    );
  }
}
