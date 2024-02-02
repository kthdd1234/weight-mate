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
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:url_launcher/url_launcher.dart';

List<SvgClass> svgData = [
  SvgClass(emotion: 'slightly-smiling-face', name: '흐뭇'),
  SvgClass(emotion: 'grinning-face-with-smiling-eyes', name: '기쁨'),
  SvgClass(emotion: 'grinning-squinting-face', name: '짜릿'),
  SvgClass(emotion: 'kissing-face', name: '신남'),
  SvgClass(emotion: 'neutral-face', name: '보통'),
  SvgClass(emotion: 'amazed-face', name: '놀람'),
  SvgClass(emotion: 'anxious-face', name: '서운'),
  SvgClass(emotion: 'crying-face', name: '슬픔'),
  SvgClass(emotion: 'determined-face', name: '다짐'),
  SvgClass(emotion: 'disappointed-face', name: '실망'),
  SvgClass(emotion: 'dizzy-face', name: '피곤'),
  SvgClass(emotion: 'grinning-face-with-sweat', name: '다행'),
  SvgClass(emotion: 'expressionless-face', name: '고요'),
  SvgClass(emotion: 'face-blowing-a-kiss', name: '사랑'),
  SvgClass(emotion: 'sneezing-face', name: '아픔'),
  SvgClass(emotion: 'worried-face', name: '걱정'),
  SvgClass(emotion: 'winking-face-with-tongue', name: '장난'),
  SvgClass(emotion: 'face-with-steam-from-nose', name: '화남'),
  SvgClass(emotion: 'loudly-crying-face', name: '감동'),
  SvgClass(emotion: 'smiling-face-with-halo', name: '해탈'),
];

class EditWeight extends StatefulWidget {
  EditWeight({super.key});

  @override
  State<EditWeight> createState() => _EditWeightState();
}

class _EditWeightState extends State<EditWeight> {
  bool isShowInput = false;
  bool isGoalWeight = false;
  TextEditingController textController = TextEditingController();
  String? errorText;

  @override
  Widget build(BuildContext context) {
    String fWeight = FILITER.weight.toString();
    DateTime importDateTime =
        context.watch<ImportDateTimeProvider>().getImportDateTime();
    int recordKey = getDateTimeToInt(importDateTime);
    RecordBox? recordInfo = recordRepository.recordBox.get(recordKey);
    UserBox user = userRepository.user;
    bool? isOpen = user.filterList?.contains(fWeight) == true;

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

    onErrorText() {
      String? errMsg = handleCheckErrorText(
        min: weightMin,
        max: weightMax,
        text: textController.text,
        errMsg: weightErrMsg2.tr(),
      );

      return errMsg;
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

    onValidWeight() {
      return textController.text != '' && onErrorText() == null;
    }

    onChangedText(_) {
      bool isParse = double.tryParse(textController.text) == null;

      if (isParse) {
        textController.text = '';
      }

      setState(() => errorText = onErrorText());
      context.read<EnabledProvider>().setEnabled(onValidWeight());
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
          return ButtonModal(
            onCompleted: () {
              if (onValidWeight()) {
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

                List<RecordBox> recordList =
                    recordRepository.recordBox.values.toList();
                recordList.where((e) => e.weight != null);

                showAdDialog(
                  title: '👏🏻 일째 기록 했어요!',
                  loadingText: '체중 데이터 저장 중...',
                  nameArgs: {
                    'days': '${recordList.length}',
                  },
                );
              }
            },
            onCancel: () {
              onInit();
              closeDialog(context);
            },
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
          return ButtonModal(
            onCompleted: () {
              if (onValidWeight()) {
                user.goalWeight = stringToDouble(textController.text);
                user.save();

                onInit();
                closeDialog(context);
                showAdDialog(
                  title: '⛳ 목표 체중을 변경 했어요!',
                  loadingText: '목표 체중 데이터 저장 중...',
                );
              }
            },
            onCancel: () {
              onInit();
              closeDialog(context);
            },
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
                    text: '체중 kg',
                    nameArgs: {'weight': '${recordInfo?.weight ?? '- '}'},
                    color: 'indigo',
                    isHide: isOpen,
                    onTap: onTapOpen,
                  ),
                  TagClass(
                    text: 'BMI',
                    nameArgs: {
                      'bmi': bmi(tall: user.tall, weight: recordInfo?.weight)
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
                          maxLength: weightMaxLength,
                          decoration: InputDecoration(
                            suffixText: 'kg',
                            hintText: weightHintText.tr(),
                            errorText: errorText,
                          ),
                          onChanged: onChangedText,
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

class ButtonModal extends StatelessWidget {
  ButtonModal({
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
    List<WeightButtonClass> weightButtonList = [
      WeightButtonClass(
        text: '현재 체중: kg',
        imgNumber: '22',
        nameArgs: {'weight': '${widget.weight}'},
        onTap: widget.onTapWeight,
      ),
      WeightButtonClass(),
      WeightButtonClass(
        text: '목표 체중: kg',
        imgNumber: '15',
        nameArgs: {'weight': '${widget.goalWeight}'},
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
                  text: '목표 체중: kg'
                      .tr(namedArgs: {'weight': '${widget.goalWeight}'}),
                  textStyle: const TextStyle(color: disabledButtonTextColor),
                  start: widget.goalWeight,
                  end: widget.goalWeight,
                )
              ],
            ),
            tooltipBehavior: TooltipBehavior(
              enable: true,
              header: '',
              format: 'point.x: point.ykg',
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
// ContentsBox(
//   padding: const EdgeInsets.all(smallSpace),
//   backgroundColor: Colors.indigo.shade50,
//   borderRadius: tinySpace,
//   contentsWidget: Row(
//     children: [
//       CircularIcon(
//         size: 40,
//         borderRadius: 10,
//         icon: Icons.keyboard_alt_outlined,
//         backgroundColor: Colors.white,
//       ),
//       CupertinoSwitch(
//         activeColor: themeColor,
//         value: false,
//         onChanged: (_) {},
//       )
//     ],
//   ),
// )
// onTapFilter() {
//   showDialog(
//     context: context,
//     builder: (context) {
//       return StatefulBuilder(
//         builder: ((context, setState) {
//           onTapCheckBox({required dynamic id, required bool newValue}) {
//             bool isNotWeight = filterClassList.first.id != id;
//             bool isFilterList = user.filterList != null;

//             if (isNotWeight && isFilterList) {
//               newValue
//                   ? user.filterList!.add(id)
//                   : user.filterList!.remove(id);
//               user.save();

//               setState(() {});
//             }
//           }

//           onCheckBox(String filterId) {
//             List<String>? filterList = user.filterList;
//             bool isWeight = filterClassList.first.id == filterId;

//             if (isWeight) {
//               return true;
//             }

//             return filterList != null
//                 ? filterList.contains(filterId)
//                 : false;
//           }

//           List<Widget> children = filterClassList
//               .map((data) => Column(
//                     children: [
//                       Row(
//                         children: [
//                           CommonCheckBox(
//                             id: data.id,
//                             isCheck: onCheckBox(data.id),
//                             checkColor: themeColor,
//                             onTap: onTapCheckBox,
//                           ),
//                           CommonText(
//                             text: data.name,
//                             size: 14,
//                             isNotTop: true,
//                           ),
//                           SpaceWidth(width: 3),
//                           filterClassList.first.id == data.id
//                               ? CommonText(
//                                   text: '(필수)',
//                                   size: 10,
//                                   color: Colors.red,
//                                 )
//                               : const EmptyArea()
//                         ],
//                       ),
//                       SpaceHeight(
//                         height: filterClassList.last.id == data.id
//                             ? 0.0
//                             : smallSpace,
//                       ),
//                     ],
//                   ))
//               .toList();

//           return Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               AlertDialog(
//                 backgroundColor: dialogBackgroundColor,
//                 shape: containerBorderRadious,
//                 title: AlertDialogTitleWidget(
//                   text: '항목 필터',
//                   onTap: () => closeDialog(context),
//                 ),
//                 content: ContentsBox(
//                   contentsWidget: Column(children: children),
//                 ),
//               ),
//             ],
//           );
//         }),
//       );
//     },
//   );
// }

// Row(
//       children: [
//         Expanded(
//           flex: 4,
//           child: Container(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     CommonText(
//                       text: '12월 31일 일요일',
//                       size: isEdit ? 14 : 12,
//                       isBold: true,
//                       rightIcon:
//                           isEdit ? Icons.keyboard_arrow_down_rounded : null,
//                     ),
//                     isEdit
//                         ? CommonText(
//                             text: '필터',
//                             size: 13,
//                             color: themeColor,
//                             leftIcon: Icons.filter_list_sharp,
//                             onTap: onTapFilter,
//                           )
//                         : CommonIcon(
//                             icon: Icons.more_vert,
//                             size: 14,
//                             color: Colors.grey,
//                           ),
//                   ],
//                 ),
//                 SpaceHeight(height: 7.5),
//                 Row(
//                   children: [
//                     isEdit
//                         ? isShowInput
//                             ? Expanded(
//                                 child: SizedBox(
//                                 height: 25,
//                                 child: TextFormField(
//                                   keyboardType: inputKeyboardType,
//                                   controller: textController,
//                                   maxLength: 4,
//                                   autofocus: true,
//                                   style: Theme.of(context).textTheme.bodyMedium,
//                                   decoration:
//                                       const InputDecoration(counterText: ''),
//                                   onChanged: onChangedText,
//                                 ),
//                               ))
//                             : recordInfo?.weight != null
//                                 ? Expanded(
//                                     child: Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceBetween,
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.end,
//                                       children: [
//                                         CommonText(
//                                           text:
//                                               '${recordInfo?.weight ?? '0.0'}kg',
//                                           size: 18,
//                                           onTap: onTapWeight,
//                                         ),
//                                         CommonText(
//                                           text: 'BMI ${onBMI()}',
//                                           size: 10,
//                                           color: Colors.grey,
//                                           onTap: onTapBMI,
//                                         ),
//                                       ],
//                                     ),
//                                   )
//                                 : DashContainer(
//                                     height: 40,
//                                     text: '체중 입력',
//                                     borderType: BorderType.RRect,
//                                     radius: 10,
//                                     onTap: onTapWeight,
//                                   )
//                         : Expanded(
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               crossAxisAlignment: CrossAxisAlignment.end,
//                               children: [
//                                 CommonText(
//                                   text: '${recordInfo?.weight ?? '--'}kg',
//                                   size: 15,
//                                 ),
//                                 CommonText(
//                                   text:
//                                       'BMI ${recordInfo?.weight != null ? onBMI() : '--'}',
//                                   size: 9,
//                                   color: Colors.grey,
//                                 ),
//                               ],
//                             ),
//                           ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );

// TagClass(
//             text: user.isAlarm
//                 ? '${timeToString(user.alarmTime)}'
//                 : '알림 없음',
//             color: 'indigo',
//             onTap: onTapTimeSetting,
//           ),
