import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/area/empty_area.dart';
import 'package:flutter_app_weight_management/components/area/empty_text_vertical_area.dart';
import 'package:flutter_app_weight_management/components/dialog/confirm_dialog.dart';
import 'package:flutter_app_weight_management/components/dot/color_dot.dart';
import 'package:flutter_app_weight_management/components/icon/default_icon.dart';
import 'package:flutter_app_weight_management/components/info/color_text_info.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/components/text/contents_title_text.dart';
import 'package:flutter_app_weight_management/model/plan_box/plan_box.dart';
import 'package:flutter_app_weight_management/model/record_box/record_box.dart';
import 'package:flutter_app_weight_management/pages/common/record_info_page.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:flutter_app_weight_management/widgets/calendar_action_info.dart';
import 'package:flutter_app_weight_management/widgets/calendar_diary_info.dart';
import 'package:flutter_app_weight_management/widgets/calendar_weight_info.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:table_calendar/table_calendar.dart';

Map<SegmentedTypes, Color> dotColors = <SegmentedTypes, Color>{
  SegmentedTypes.weight: weightColor,
  SegmentedTypes.action: actionColor,
  SegmentedTypes.diary: diaryColor,
};

class CalendarBody extends StatefulWidget {
  const CalendarBody({super.key});

  @override
  State<CalendarBody> createState() => CalendarBodyState();
}

class CalendarBodyState extends State<CalendarBody> {
  late Box<RecordBox> recordBox;
  late Box<PlanBox> planBox;
  late DateTime currentDay;

  CalendarFormat calendarFormat = CalendarFormat.month;

  @override
  void initState() {
    recordBox = Hive.box('recordBox');
    planBox = Hive.box('planbox');
    currentDay = DateTime.now();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<RecordBox> recordValues = recordBox.values.toList();
    RecordBox? currentRecordInfo = recordBox.get(getDateTimeToInt(currentDay));

    onTapMoreInfo() {
      if (currentRecordInfo == null) {
        return showSnackBar(
          context: context,
          text: '기록된 정보가 없어요.',
          buttonName: '확인',
          width: 230,
        );
      }

      return Navigator.pushNamed(
        context,
        '/record-info-page',
        arguments: RecordInfoArgumentsClass(
          recordInfo: currentRecordInfo,
          currentDay: currentDay,
          planBox: planBox,
        ),
      );
    }

    onTapDeleteRecord() {
      showDialog(
        context: context,
        builder: (context) {
          return ConfirmDialog(
            titleText: '기록 삭제',
            contentIcon: Icons.delete_forever,
            contentText1: '${getDateTimeToStr(currentDay)}',
            contentText2: '기록을 삭제하시겠습니까?',
            onPressedOk: () {
              currentRecordInfo?.delete();
              setState(() {});
            },
            width: 230,
          );
        },
      );
    }

    setColorTextInfo({required String text, required Color color}) {
      return ColorTextInfo(
        width: 10,
        height: 10,
        text: text,
        color: color,
      );
    }

    onFormatChanged(CalendarFormat format) {
      setState(() => calendarFormat = format);
    }

    onDaySelected(selectedDay, focusedDay) {
      setState(() => currentDay = selectedDay);
    }

    createColorDot({
      required Color color,
      String? text,
    }) {
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ColorDot(width: 5, height: 5, color: color),
              SpaceWidth(width: 3),
              text != null
                  ? Text(text, style: const TextStyle(fontSize: 7))
                  : const EmptyArea()
            ],
          ),
          SpaceHeight(height: 3)
        ],
      );
    }

    setBottomButton({
      String? imgUrl,
      Color? color,
      required IconData icon,
      required String text,
      required Function() onTap,
    }) {
      return Expanded(
        child: InkWell(
          onTap: onTap,
          child: ContentsBox(
            imgUrl: imgUrl,
            backgroundColor: color,
            contentsWidget: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: Colors.white, size: 18),
                SpaceWidth(width: tinySpace),
                Text(
                  text,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          ContentsBox(
            backgroundColor: Colors.transparent,
            padding: const EdgeInsets.all(0),
            contentsWidget: TableCalendar(
              rowHeight: MediaQuery.of(context).size.height - 765,
              currentDay: currentDay,
              calendarBuilders: CalendarBuilders(
                markerBuilder: (context, day, events) {
                  Widget? weightDot;
                  List<Widget> colorDotList = [];

                  for (var i = 0; i < recordValues.length; i++) {
                    final recordInfo = recordValues[i];
                    final createDateTimeInt =
                        getDateTimeToInt(recordInfo.createDateTime);
                    final builerDayInt = getDateTimeToInt(day);
                    final weight = recordInfo.weight;
                    final actions = recordInfo.actions;
                    final imageFilePath = recordInfo.leftEyeBodyFilePath ??
                        recordInfo.rightEyeBodyFilePath;
                    final whiteText = recordInfo.whiteText;

                    addColorDot(dynamic target, Color color, String? text) {
                      if (target != null) {
                        if (color == weightColor) {
                          weightDot = createColorDot(color: color, text: text);
                        } else {
                          colorDotList
                              .add(createColorDot(color: color, text: text));
                        }
                      } else {
                        colorDotList
                            .add(createColorDot(color: Colors.transparent));
                      }
                    }

                    if (createDateTimeInt == builerDayInt) {
                      addColorDot(weight, weightColor, '$weight kg');
                      addColorDot(actions, actionColor, null);
                      addColorDot(imageFilePath, eyeBodyColor, null);
                      addColorDot(whiteText, diaryColor, null);
                    }
                  }

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      weightDot ?? const EmptyArea(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: colorDotList,
                      ),
                    ],
                  );
                },
              ),
              onDaySelected: onDaySelected,
              availableCalendarFormats: const {
                CalendarFormat.month: '1개월',
                CalendarFormat.twoWeeks: '2주일',
                CalendarFormat.week: '1주일'
              },
              calendarFormat: calendarFormat,
              locale: 'ko-KR',
              firstDay: DateTime.utc(2010, 10, 16),
              lastDay: DateTime.now(),
              focusedDay: DateTime.now(),
              headerStyle: const HeaderStyle(
                headerMargin: EdgeInsets.only(bottom: 10),
                titleCentered: true,
              ),
              onFormatChanged: onFormatChanged,
            ),
          ),
          SpaceHeight(height: regularSapce),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              setColorTextInfo(text: '체중 기록', color: weightColor),
              setColorTextInfo(text: '계획 실천', color: actionColor),
              setColorTextInfo(text: '사진 등록', color: eyeBodyColor),
              setColorTextInfo(text: '일기 작성', color: diaryColor),
            ],
          ),
          SpaceHeight(height: regularSapce),
          Row(
            children: [
              setBottomButton(
                imgUrl: 'assets/images/t-9.png',
                icon: Icons.search,
                text: '자세히 보기',
                onTap: onTapMoreInfo,
              ),
              SpaceWidth(width: smallSpace),
              setBottomButton(
                imgUrl: 'assets/images/t-14.png',
                icon: Icons.delete_outline,
                text: '기록 삭제하기',
                onTap: onTapDeleteRecord,
              ),
            ],
          ),
        ],
      ),
    );
  }
}


                    // addColorDot(dynamic target, Color color, String? text) {
                    //   if (target != null) {
                    //     if (color == weightColor) {
                    //       weightDot = createColorDot(color: color, text: text);
                    //     } else {
                    //       colorDotList
                    //           .add(createColorDot(color: color, text: text));
                    //     }
                    //   } else {
                    //     colorDotList
                    //         .add(createColorDot(color: Colors.transparent));
                    //   }
                    // }