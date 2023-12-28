// ignore_for_file: unnecessary_brace_in_string_interps, prefer_function_declarations_over_variables
import 'dart:developer';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/common/widget/CommonButton.dart';
import 'package:flutter_app_weight_management/common/widget/CommonCheckBox.dart';
import 'package:flutter_app_weight_management/common/widget/CommonTag.dart';
import 'package:flutter_app_weight_management/common/widget/CommonText.dart';
import 'package:flutter_app_weight_management/components/area/empty_area.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/dialog/native_ad_dialog.dart';
import 'package:flutter_app_weight_management/components/input/text_input.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/main.dart';
import 'package:flutter_app_weight_management/model/record_box/record_box.dart';
import 'package:flutter_app_weight_management/model/user_box/user_box.dart';
import 'package:flutter_app_weight_management/pages/home/body/record/widget/section/container/dot_container.dart';
import 'package:flutter_app_weight_management/provider/bottom_navigation_provider.dart';
import 'package:flutter_app_weight_management/provider/import_date_time_provider.dart';
import 'package:flutter_app_weight_management/utils/class.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:flutter_app_weight_management/widgets/alert_dialog_title_widget.dart';
import 'package:flutter_app_weight_management/widgets/dafault_bottom_sheet.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
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

class RecordProfile extends StatefulWidget {
  const RecordProfile({super.key});

  @override
  State<RecordProfile> createState() => _RecordProfileState();
}

class _RecordProfileState extends State<RecordProfile> {
  bool isEditWeight = false;
  TextEditingController textController = TextEditingController();
  String helperText = '';

  @override
  Widget build(BuildContext context) {
    DateTime importDateTime =
        context.read<ImportDateTimeProvider>().getImportDateTime();
    int recordKey = getDateTimeToInt(DateTime.now());
    RecordBox? recordInfo = recordRepository.recordBox.get(recordKey);
    String? emotion = recordInfo?.emotion;
    UserBox user = userRepository.user;

    showAdDialog() {
      Iterable<RecordBox> recordList = recordRepository.recordBox.values
          .toList()
          .where((e) => e.weight != null);
      String title = '👏🏻 ${recordList.length}일째 기록 했어요!';

      showDialog(
        context: context,
        builder: (dContext) {
          onClick(BottomNavigationEnum enumId) async {
            dContext
                .read<BottomNavigationProvider>()
                .setBottomNavigation(enumId: enumId);
            closeDialog(dContext);
          }

          return NativeAdDialog(
            title: title,
            leftText: '달력 보기',
            rightText: '체중 보기',
            leftIcon: Icons.calendar_month,
            rightIcon: Icons.auto_graph_rounded,
            onLeftClick: () => onClick(BottomNavigationEnum.calendar),
            onRightClick: () => onClick(BottomNavigationEnum.analyze),
          );
        },
      );
    }

    onTap(String emotion) {
      if (recordInfo == null) {
        recordRepository.updateRecord(
          key: recordKey,
          record: RecordBox(
            createDateTime: importDateTime,
            emotion: emotion,
          ),
        );
      } else {
        recordInfo.emotion = emotion;
      }

      recordInfo?.save();
      closeDialog(context);
    }

    onTapEmotion() {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return DefaultBottomSheet(
            title: '감정',
            height: 600,
            contents: Expanded(
              child: GridView.builder(
                itemCount: svgData.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                ),
                itemBuilder: (context, index) {
                  SvgClass data = svgData[index];
                  String svgPath = 'assets/svgs/${data.emotion}.svg';
                  Widget wCheckIcon = data.emotion == emotion
                      ? Icon(
                          Icons.check_circle,
                          color: Colors.purple.shade200,
                          size: 18,
                        )
                      : const EmptyArea();

                  return InkWell(
                    onTap: () => onTap(data.emotion),
                    child: Column(
                      children: [
                        SvgPicture.asset(svgPath, height: 40),
                        SpaceHeight(height: tinySpace),
                        CommonText(text: data.name, size: 12, isCenter: true),
                        wCheckIcon,
                      ],
                    ),
                  );
                },
              ),
            ),
          );
        },
      );
    }

    onHelperText() {
      String? errMsg = handleCheckErrorText(
        min: weightMin,
        max: weightMax,
        text: textController.text,
        errMsg: weightErrMsg2,
      );

      return errMsg ?? '';
    }

    onInit() {
      setState(() {
        isEditWeight = false;
        textController.text = '';
      });

      FocusScope.of(context).unfocus();
      context.read<EnabledProvider>().setEnabled(false);
      closeDialog(context);
    }

    onValidWeight() {
      return textController.text != '' && onHelperText() == '';
    }

    onCompleted() {
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

        onInit();
        showAdDialog();
      }
    }

    onTapWeight() {
      setState(() {
        if (recordInfo?.weight != null) {
          textController.text = '${recordInfo!.weight}';
          context.read<EnabledProvider>().setEnabled(true);
        }

        isEditWeight = true;
      });

      showModalBottomSheet(
        isDismissible: false,
        barrierColor: Colors.transparent,
        context: context,
        builder: (context) {
          return WeightAboveKeyboard(
            onCompleted: onCompleted,
            onCancel: onInit,
          );
        },
      );
    }

    onTapFilter() {
      showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: ((context, setState) {
              onTapCheckBox({required dynamic id, required bool newValue}) {
                bool isNotWeight = filterClassList.first.id != id;
                bool isFilterList = user.filterList != null;

                if (isNotWeight && isFilterList) {
                  newValue
                      ? user.filterList!.add(id)
                      : user.filterList!.remove(id);
                  user.save();

                  setState(() {});
                }
              }

              onCheckBox(String filterId) {
                List<String>? filterList = user.filterList;
                bool isWeight = filterClassList.first.id == filterId;

                if (isWeight) {
                  return true;
                }

                return filterList != null
                    ? filterList.contains(filterId)
                    : false;
              }

              List<Widget> children = filterClassList
                  .map((data) => Column(
                        children: [
                          Row(
                            children: [
                              CommonCheckBox(
                                id: data.id,
                                isCheck: onCheckBox(data.id),
                                checkColor: themeColor,
                                onTap: onTapCheckBox,
                              ),
                              CommonText(
                                  text: data.name, size: 14, isNotTop: true),
                              SpaceWidth(width: 3),
                              filterClassList.first.id == data.id
                                  ? CommonText(
                                      text: '(필수)',
                                      size: 10,
                                      color: Colors.red,
                                    )
                                  : const EmptyArea()
                            ],
                          ),
                          SpaceHeight(
                            height: filterClassList.last.id == data.id
                                ? 0.0
                                : smallSpace,
                          ),
                        ],
                      ))
                  .toList();

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AlertDialog(
                    backgroundColor: dialogBackgroundColor,
                    shape: containerBorderRadious,
                    title: AlertDialogTitleWidget(
                      text: '항목 필터',
                      onTap: () => closeDialog(context),
                    ),
                    content: ContentsBox(
                      contentsWidget: Column(children: children),
                    ),
                  ),
                ],
              );
            }),
          );
        },
      );
    }

    onBMI() {
      double tall = user.tall;
      double weight = recordInfo?.weight ?? 0.0;

      final cmToM = tall / 100;
      final bmi = weight / (cmToM * cmToM);
      final bmiToFixed = bmi.toStringAsFixed(1);

      return bmiToFixed;
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

    onChangedText(_) {
      bool isParse = double.tryParse(textController.text) == null;

      if (isParse) {
        textController.text = '';
      }

      setState(() => helperText = onHelperText());
      context.read<EnabledProvider>().setEnabled(onValidWeight());
    }

    Widget wSvg = SvgPicture.asset('assets/svgs/$emotion.svg', height: 75);
    bool isEmotion = user.filterList!.contains(FILITER.emotion.toString());
    Widget wEmotion = isEmotion
        ? emotion != null
            ? InkWell(onTap: onTapEmotion, child: wSvg)
            : DashContainer(
                height: 75,
                text: '감정',
                borderType: BorderType.Circle,
                radius: 100,
                onTap: onTapEmotion,
              )
        : const EmptyArea();

    return Row(
      children: [
        wEmotion,
        SpaceWidth(width: isEmotion ? smallSpace + tinySpace : 0),
        Expanded(
          flex: 4,
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CommonText(
                      text: '21일 목요일 (오늘)',
                      size: 15,
                      isBold: true,
                    ),
                    CommonText(
                      text: '필터',
                      size: 14,
                      color: Colors.grey,
                      onTap: onTapFilter,
                    ),
                  ],
                ),
                SpaceHeight(height: smallSpace),
                Row(
                  children: [
                    isEditWeight
                        ? Expanded(
                            child: SizedBox(
                            height: largeSpace,
                            child: TextFormField(
                              keyboardType: inputKeyboardType,
                              controller: textController,
                              maxLength: 4,
                              autofocus: true,
                              style: Theme.of(context).textTheme.bodyMedium,
                              decoration:
                                  InputDecoration(helperText: helperText),
                              onChanged: onChangedText,
                            ),
                          ))
                        : recordInfo?.weight != null
                            ? Expanded(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    CommonText(
                                      text: '${recordInfo?.weight ?? '0.0'}kg',
                                      size: 20,
                                      onTap: onTapWeight,
                                    ),
                                    CommonText(
                                      text: 'BMI ${onBMI()}',
                                      size: 12,
                                      color: Colors.grey,
                                      onTap: onTapBMI,
                                    ),
                                  ],
                                ),
                              )
                            : DashContainer(
                                height: largeSpace,
                                text: '체중(kg)',
                                borderType: BorderType.RRect,
                                radius: 10,
                                onTap: onTapWeight,
                              ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class WeightAboveKeyboard extends StatelessWidget {
  WeightAboveKeyboard({
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

class EnabledProvider extends ChangeNotifier {
  bool isEnabled = false;

  setEnabled(enabled) {
    isEnabled = enabled;
    notifyListeners();
  }
}

                  // TextInput(
                            //   controller: textController,
                            //   maxLength: 4,
                            //   autofocus: true,
                            //   isMediumSize: true,
                            //   inputHeight: largeSpace,
                            //   inputBorderType: const OutlineInputBorder(
                            //     borderRadius:
                            //         BorderRadius.all(Radius.circular(10)),
                            //     borderSide:
                            //         BorderSide(color: themeColor, width: 2),
                            //   ),
                            //   suffixText: 'kg',
                            //   hintText: '',
                            //   counterText: '',
                            //   onChanged: (String newValue) {},
                            //   errorText: null,
                            //   contentPadding: const EdgeInsets.symmetric(
                            //     horizontal: smallSpace,
                            //   ),
                            //   onTapOutside: (inputContext) => onExecute(),
                            // ),