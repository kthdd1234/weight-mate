// ignore_for_file: unnecessary_brace_in_string_interps, prefer_function_declarations_over_variables
import 'dart:math';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/common/CommonButton.dart';
import 'package:flutter_app_weight_management/common/CommonText.dart';
import 'package:flutter_app_weight_management/components/area/empty_area.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/dialog/native_ad_dialog.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/main.dart';
import 'package:flutter_app_weight_management/model/record_box/record_box.dart';
import 'package:flutter_app_weight_management/model/user_box/user_box.dart';
import 'package:flutter_app_weight_management/pages/home/body/record/edit/container/title_container.dart';
import 'package:flutter_app_weight_management/provider/bottom_navigation_provider.dart';
import 'package:flutter_app_weight_management/provider/enabled_provider.dart';
import 'package:flutter_app_weight_management/provider/import_date_time_provider.dart';
import 'package:flutter_app_weight_management/utils/class.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:flutter_app_weight_management/pages/home/body/graph/widget/graph_chart.dart';
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
  bool isShowInput = false;
  bool isGoalWeight = false;

  @override
  Widget build(BuildContext context) {
    DateTime importDateTime =
        context.watch<ImportDateTimeProvider>().getImportDateTime();
    int recordKey = getDateTimeToInt(importDateTime);
    RecordBox? recordInfo = recordRepository.recordBox.get(recordKey);
    UserBox user = userRepository.user;
    bool? isOpen = user.filterList?.contains(fWeight) == true;

    isError() {
      return isShowErorr(
        unit: user.weightUnit ?? 'kg',
        value: double.tryParse(textController.text),
      );
    }

    showAdDialog({
      required String title,
      required String loadingText,
      Map<String, String>? nameArgs,
    }) async {
      await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (buildContext) {
          onClick(BottomNavigationEnum enumId) async {
            buildContext
                .read<BottomNavigationProvider>()
                .setBottomNavigation(enumId: enumId);
            closeDialog(buildContext);
          }

          return NativeAdDialog(
            loadingText: loadingText,
            title: title,
            nameArgs: nameArgs,
            leftText: '히스토리',
            rightText: '그래프',
            onLeftClick: () => onClick(BottomNavigationEnum.history),
            onRightClick: () => onClick(BottomNavigationEnum.graph),
          );
        },
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

    onSaveWeight() {
      if (isDoubleTryParse(text: textController.text)) {
        DateTime now = DateTime.now();
        double weight = stringToDouble(textController.text);

        if (recordInfo == null) {
          recordRepository.recordBox.put(
            recordKey,
            RecordBox(
              createDateTime: importDateTime,
              weightDateTime: now,
              weight: stringToDouble(textController.text),
            ),
          );
        } else {
          recordInfo.weightDateTime = DateTime.now();
          recordInfo.weight = weight;
          recordRepository.recordBox.put(recordKey, recordInfo);
        }

        recordInfo?.save();

        onInit();
        closeDialog(context);

        List<RecordBox> recordList = recordRepository.recordBox.values.toList();
        List<RecordBox> weightList =
            recordList.where((e) => e.weight != null).toList();

        showAdDialog(
          title: '👏🏻 일째 기록 했어요!',
          loadingText: '체중 데이터 저장 중...',
          nameArgs: {'days': '${weightList.length}'},
        );
      }
    }

    onSaveGoalWeight() {
      if (isDoubleTryParse(text: textController.text)) {
        user.goalWeight = stringToDouble(textController.text);
        user.save();

        onInit();
        closeDialog(context);
        showAdDialog(
          title: '⛳ 목표 체중을 변경 했어요!',
          loadingText: '목표 체중 데이터 저장 중...',
        );
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
            onCompleted: onSaveWeight,
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

    onTapBMI() async {
      Uri url = Uri(
        scheme: 'https',
        host: 'ko.wikipedia.org',
        path: 'wiki/%EC%B2%B4%EC%A7%88%EB%9F%89_%EC%A7%80%EC%88%98',
      );

      await canLaunchUrl(url)
          ? await launchUrl(url)
          : throw 'Could not launch $url';
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

    return Column(
      children: [
        ContentsBox(
          contentsWidget: Column(
            children: [
              TitleContainer(
                isDivider: isOpen,
                title: isGoalWeight ? '목표 체중' : '체중',
                icon: isGoalWeight ? Icons.flag : Icons.monitor_weight_rounded,
                tags: [
                  TagClass(
                    text: '체중 ',
                    nameArgs: {
                      'weight': '${recordInfo?.weight ?? '- '}',
                      'unit': user.weightUnit ?? 'kg'
                    },
                    color: 'indigo',
                    isHide: isOpen,
                    onTap: onTapOpen,
                  ),
                  TagClass(
                      text: '통계표 보기',
                      color: 'indigo',
                      isHide: !isOpen,
                      onTap: onTapWeightChart),
                  TagClass(
                    text: 'BMI',
                    nameArgs: {
                      'bmi': bmi(
                        tall: user.tall,
                        weight: recordInfo?.weight,
                        tallUnit: user.tallUnit,
                        weightUnit: user.weightUnit,
                      )
                    },
                    color: 'indigo',
                    onTap: onTapBMI,
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
                          onEditingComplete:
                              isGoalWeight ? onSaveGoalWeight : onSaveWeight,
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
                          : Row(
                              children: [
                                CommonButton(
                                  text: '체중 기록하기',
                                  fontSize: 13,
                                  isBold: true,
                                  height: 50,
                                  bgColor: dialogBackgroundColor,
                                  radious: 7,
                                  textColor: Colors.indigo.shade300,
                                  onTap: onTapWeight,
                                ),
                              ],
                            )
                  : const EmptyArea()
            ],
          ),
        ),
        SpaceHeight(height: smallSpace)
      ],
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
              fontSize: 18,
              radious: 5,
              bgColor: Colors.white,
              textColor: themeColor,
              onTap: onCancel,
            ),
            SpaceWidth(width: tinySpace),
            CommonButton(
              text: '완료',
              fontSize: 18,
              radious: 5,
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
        imgNumber: '22',
        nameArgs: {'weight': '${widget.weight}', 'unit': weightUnit},
        onTap: widget.onTapWeight,
      ),
      WeightButtonClass(),
      WeightButtonClass(
        text: '목표 체중: ',
        imgNumber: '15',
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
                  textStyle: TextStyle(color: weightColor.shade300),
                ),
                color: weightColor.shade50,
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
