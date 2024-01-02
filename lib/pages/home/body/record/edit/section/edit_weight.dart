// ignore_for_file: unnecessary_brace_in_string_interps, prefer_function_declarations_over_variables
import 'dart:developer';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/common/CommonButton.dart';
import 'package:flutter_app_weight_management/common/CommonCheckBox.dart';
import 'package:flutter_app_weight_management/common/CommonIcon.dart';
import 'package:flutter_app_weight_management/common/CommonText.dart';
import 'package:flutter_app_weight_management/components/area/empty_area.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/dialog/native_ad_dialog.dart';
import 'package:flutter_app_weight_management/components/icon/circular_icon.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/main.dart';
import 'package:flutter_app_weight_management/model/record_box/record_box.dart';
import 'package:flutter_app_weight_management/model/user_box/user_box.dart';
import 'package:flutter_app_weight_management/pages/home/body/record/edit/section/container/dash_container.dart';
import 'package:flutter_app_weight_management/pages/home/body/record/edit/section/container/title_container.dart';
import 'package:flutter_app_weight_management/provider/bottom_navigation_provider.dart';
import 'package:flutter_app_weight_management/utils/class.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:flutter_app_weight_management/widgets/alert_dialog_title_widget.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
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

class EditWeight extends StatefulWidget {
  EditWeight({
    super.key,
    required this.importDateTime,
    required this.recordType,
  });

  DateTime importDateTime;
  RECORD recordType;

  @override
  State<EditWeight> createState() => _EditWeightState();
}

class _EditWeightState extends State<EditWeight> {
  bool isShowInput = false;
  TextEditingController textController = TextEditingController();
  String? errorText;

  @override
  Widget build(BuildContext context) {
    int recordKey = getDateTimeToInt(widget.importDateTime);
    RecordBox? recordInfo = recordRepository.recordBox.get(recordKey);
    // String? emotion = recordInfo?.emotion;
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

    onErrorText() {
      String? errMsg = handleCheckErrorText(
        min: weightMin,
        max: weightMax,
        text: textController.text,
        errMsg: weightErrMsg2,
      );

      return errMsg;
    }

    onInit() {
      setState(() {
        isShowInput = false;
        textController.text = '';
      });

      FocusScope.of(context).unfocus();
      context.read<EnabledProvider>().setEnabled(false);
      closeDialog(context);
    }

    onValidWeight() {
      return textController.text != '' && onErrorText() == null;
    }

    onCompleted() {
      if (onValidWeight()) {
        DateTime now = DateTime.now();
        double weight = stringToDouble(textController.text);

        if (recordInfo == null) {
          recordRepository.recordBox.put(
            recordKey,
            RecordBox(
              createDateTime: widget.importDateTime,
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

    onTapInput() {
      setState(() {
        if (recordInfo?.weight != null) {
          textController.text = '${recordInfo!.weight}';
          context.read<EnabledProvider>().setEnabled(true);
        }

        isShowInput = true;
      });

      showModalBottomSheet(
        isDismissible: false,
        barrierColor: Colors.transparent,
        context: context,
        builder: (context) {
          return ButtonModal(
            onCompleted: onCompleted,
            onCancel: onInit,
          );
        },
      );
    }

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

      setState(() => errorText = onErrorText());
      context.read<EnabledProvider>().setEnabled(onValidWeight());
    }

    onTapGoalWeight() {
      //
    }

    onTapCollapse() {
      //
    }

    onTapTimeSetting() {}

    return Column(
      children: [
        ContentsBox(
          contentsWidget: Column(
            children: [
              TitleContainer(
                title: '체중',
                icon: Icons.monitor_weight_rounded,
                tags: [
                  TagClass(
                    text: '오전 8:30',
                    color: 'indigo',
                    onTap: onTapTimeSetting,
                  ),
                  TagClass(
                    text: '키보드 on',
                    color: 'indigo',
                    onTap: onTapGoalWeight,
                  ),
                  TagClass(
                    icon: Icons.keyboard_arrow_down_rounded,
                    color: 'indigo',
                    onTap: onTapCollapse,
                  ),
                ],
              ),
              isShowInput
                  ? TextFormField(
                      controller: textController,
                      keyboardType: inputKeyboardType,
                      autofocus: true,
                      maxLength: weightMaxLength,
                      decoration: InputDecoration(
                        suffixText: 'kg',
                        hintText: weightHintText,
                        errorText: errorText, // weightErrMsg2
                      ),
                      onChanged: onChangedText,
                    )
                  : recordInfo?.weight != null
                      ? Row(
                          children: [
                            CommonText(text: '${recordInfo!.weight}', size: 14)
                          ],
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
                              onTap: onTapInput,
                            ),
                          ],
                        )
            ],
          ),
        ),
        SpaceHeight(height: smallSpace)
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

    log('isEnabled => $isEnabled');

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
