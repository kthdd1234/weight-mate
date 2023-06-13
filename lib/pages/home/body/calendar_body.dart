import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/area/empty_area.dart';
import 'package:flutter_app_weight_management/components/divider/height_divider.dart';
import 'package:flutter_app_weight_management/components/dot/color_dot.dart';
import 'package:flutter_app_weight_management/components/icon/default_icon.dart';
import 'package:flutter_app_weight_management/components/image/default_image.dart';
import 'package:flutter_app_weight_management/components/info/color_text_info.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/components/text/body_small_text.dart';
import 'package:flutter_app_weight_management/components/text/contents_title_text.dart';
import 'package:flutter_app_weight_management/model/plan_box/plan_box.dart';
import 'package:flutter_app_weight_management/model/record_box/record_box.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:table_calendar/table_calendar.dart';

final textUrl =
    '/Users/gimdonghyeon/Library/Developer/CoreSimulator/Devices/DBF8E57A-687E-4308-A94F-2F762A55E099/data/Containers/Data/Application/0DA7443F-8495-4477-BB2E-8F2AB1D738DC/Documents/eyeBody/images/1686543943937168.png';

Map<SegmentedTypes, Color> dotColors = <SegmentedTypes, Color>{
  SegmentedTypes.weight: weightDotColor,
  SegmentedTypes.actPlan: actionDotColor,
  SegmentedTypes.memo: memoDotColor,
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

  CalendarFormat calendarFormat = CalendarFormat.twoWeeks;

  @override
  void initState() {
    recordBox = Hive.box('recordBox');
    planBox = Hive.box('planbox');
    currentDay = DateTime.now();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    setContentsBox({
      required Color color,
      required List<Widget> rowWidgetList,
    }) {
      return Column(
        children: [
          ContentsBox(
            padding: const EdgeInsets.only(
              top: 20,
              right: 20,
              bottom: 20,
              left: 0,
            ),
            contentsWidget: Row(
              children: [
                HeightDivider(
                  width: 3,
                  height: 45,
                  color: color,
                  borderRadius: BorderRadius.circular(20),
                ),
                SpaceWidth(width: regularSapce),
                Expanded(child: Column(children: rowWidgetList))
              ],
            ),
          ),
          SpaceHeight(height: smallSpace)
        ],
      );
    }

    setColorTextInfo({
      required String text,
      required Color color,
    }) {
      return ColorTextInfo(
        width: 10,
        height: 10,
        text: text,
        color: color,
      );
    }

    setRowWidgets(List<Widget> children) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: children,
      );
    }

    onFormatChanged(CalendarFormat format) {
      setState(() => calendarFormat = format);
    }

    onDaySelected(selectedDay, focusedDay) {
      setState(() => currentDay = selectedDay);
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          ContentsBox(
            backgroundColor: Colors.transparent,
            padding: const EdgeInsets.all(0),
            contentsWidget: TableCalendar(
              currentDay: currentDay,
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
                leftChevronVisible: false,
                rightChevronVisible: false,
              ),
              onFormatChanged: onFormatChanged,
            ),
          ),
          SpaceHeight(height: regularSapce),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              setColorTextInfo(text: '체중 기록', color: Colors.green),
              setColorTextInfo(text: '계획 실천', color: Colors.purple),
              setColorTextInfo(text: '체중 기록', color: Colors.orange),
            ],
          ),
          SpaceHeight(height: largeSpace),
          ContentsTitleText(
            text: '6월 12일 월요일',
            sub: [
              DefaultIcon(
                id: RecordIconTypes.removeNote,
                icon: Icons.delete,
                onTap: (_) {},
              )
            ],
          ),
          SpaceHeight(height: regularSapce),
          setContentsBox(
            color: Colors.green,
            rowWidgetList: [
              setRowWidgets([
                ContentsTitleText(text: '체중 기록'),
                ColorDot(width: 10, height: 10, color: Colors.green),
              ]),
              SpaceHeight(height: smallSpace),
              setRowWidgets([
                Text('67.4 kg', style: TextStyle(fontSize: 16)),
                BodySmallText(text: '오전 7시 30분 기록 완료'),
              ]),
            ],
          ),
          setContentsBox(
            color: Colors.purple,
            rowWidgetList: [
              setRowWidgets([
                ContentsTitleText(text: '계획 실천'),
                ColorDot(width: 10, height: 10, color: Colors.purple),
              ]),
              SpaceHeight(height: smallSpace),
              setRowWidgets([
                Text('간헐적 단식 16:8'),
                Icon(Icons.check),
              ]),
              SpaceHeight(height: tinySpace),
              setRowWidgets([
                Text('필라테스'),
                Icon(Icons.check),
              ]),
              SpaceHeight(height: tinySpace),
              setRowWidgets([
                Text('10시 이후로 야식 안먹기'),
                Icon(Icons.check),
              ]),
              SpaceHeight(height: smallSpace),
              setRowWidgets([
                const EmptyArea(),
                BodySmallText(text: '총 실천 3회'),
              ]),
            ],
          ),
          setContentsBox(
            color: Colors.orange,
            rowWidgetList: [
              setRowWidgets([
                ContentsTitleText(text: '일기 작성'),
                ColorDot(width: 10, height: 10, color: Colors.orange),
              ]),
              SpaceHeight(height: smallSpace),
              DefaultImage(path: textUrl, height: 200),
              SpaceHeight(height: smallSpace),
              Row(children: [Expanded(child: Text('6월 12일 월요일 일기 작성해봤습니다.'))]),
              SpaceHeight(height: regularSapce),
              setRowWidgets([
                const EmptyArea(),
                BodySmallText(text: '오후 10시 20분 작성 완료'),
              ]),
            ],
          )
        ],
      ),
    );
  }
}

// ContentsTitleText(
//             text: '계획 실천',
//             sub: [ColorDot(width: 10, height: 10, color: Colors.purple)],
//           ),
//           ContentsTitleText(
//             text: '일기 작성',
//             sub: [ColorDot(width: 10, height: 10, color: Colors.orange)],
//           ),
// const HistoryCalendarTitleWidget(),
// SpaceHeight(height: regularSapce),
// HistorySegmentedWidget(
//   selectedSegment: selectedSegment,
//   onSegmentedChanged: onSegmentedChanged,
// ),
// SpaceHeight(height: smallSpace),
// SpaceHeight(height: smallSpace),
// Container(child: onSelectedSegmentedWidget())
// CustomDateRangePicker(
//               confirmText: '수정하기',
//               cancelText: '초기화',
//               selectedDateTime: selectedDateTime,
//               onSelectionChanged: onSelectionChanged,
//               onSubmit: onSubmit,
//               onCancel: onCancel,
//             )
//  sub: [
//                   RecordContentsTitleIcon(
//                     id: RecordIconTypes.addPlan,
//                     icon: Icons.edit,
//                     onTap: (_) {},
//                   ),
//                   RecordContentsTitleIcon(
//                     id: RecordIconTypes.addWeight,
//                     icon: Icons.delete,
//                     onTap: (_) {},
//                   )
//                 ],

    // onSubmit(Object? object) {
    //   showDialog(
    //     context: context,
    //     builder: (BuildContext context) => ConfirmDialog(
    //       width: 200,
    //       titleText: '초기화',
    //       contentIcon: Icons.replay_rounded,
    //       contentText1: '${getDateTimeToStr(selectedDateTime)}',
    //       contentText2: '기록을 초기화 하시겠습니까?',
    //       onPressedOk: () {},
    //     ),
    //   );
    // }
