import 'dart:typed_data';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/common/CommonAppBar.dart';
import 'package:flutter_app_weight_management/common/CommonName.dart';
import 'package:flutter_app_weight_management/components/ads/banner_widget.dart';
import 'package:flutter_app_weight_management/components/area/empty_area.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/image/default_image.dart';
import 'package:flutter_app_weight_management/components/segmented/default_segmented.dart';
import 'package:flutter_app_weight_management/main.dart';
import 'package:flutter_app_weight_management/model/record_box/record_box.dart';
import 'package:flutter_app_weight_management/model/user_box/user_box.dart';
import 'package:flutter_app_weight_management/pages/home/body/record/record_body.dart';
import 'package:flutter_app_weight_management/provider/premium_provider.dart';
import 'package:flutter_app_weight_management/provider/tracker_filter_provider.dart';
import 'package:flutter_app_weight_management/utils/class.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:flutter_app_weight_management/utils/variable.dart';
import 'package:multi_value_listenable_builder/multi_value_listenable_builder.dart';
import 'package:provider/provider.dart';

class TrackerBody extends StatefulWidget {
  const TrackerBody({super.key});

  @override
  State<TrackerBody> createState() => _TrackerBodyState();
}

class _TrackerBodyState extends State<TrackerBody> {
  DateTime startDateTime = DateTime.now();
  DateTime endDateTime = DateTime.now();
  SegmentedTypes selectedDateTimeSegment = SegmentedTypes.week;

  @override
  void initState() {
    DateTime now = DateTime.now();

    startDateTime = jumpDayDateTime(
      type: jumpDayTypeEnum.subtract,
      dateTime: now,
      days: rangeInfo[selectedDateTimeSegment]!,
    );

    endDateTime = now;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isPremium = context.watch<PremiumProvider>().isPremium;
    bool isRecent = context.watch<TrackerFilterProvider>().trackerFilter ==
        TrackerFilter.recent;

    onSegmentedDateTimeChanged(SegmentedTypes? type) {
      setState(() => selectedDateTimeSegment = type!);
    }

    return MultiValueListenableBuilder(
      valueListenables: valueListenables,
      builder: (context, values, child) => Column(
        children: [
          CommonAppBar(),
          TrackerContainer(
            isRecent: isRecent,
            range: rangeInfo[selectedDateTimeSegment]!,
            startDateTime: startDateTime,
            endDateTime: endDateTime,
          ),
          // !isPremium
          //     ? Padding(
          //         padding: const EdgeInsets.symmetric(horizontal: 20),
          //         child: BannerWidget(),
          //       )
          //     : const EmptyArea(),
          Padding(
            padding:
                EdgeInsets.only(top: !isPremium ? 0 : 10, left: 15, right: 15),
            child: DefaultSegmented(
              selectedSegment: selectedDateTimeSegment,
              children: rangeSegmented(selectedDateTimeSegment),
              backgroundColor: typeBackgroundColor,
              thumbColor: whiteBgBtnColor,
              onSegmentedChanged: onSegmentedDateTimeChanged,
            ),
          ),
        ],
      ),
    );
  }
}

class TrackerContainer extends StatefulWidget {
  TrackerContainer({
    super.key,
    required this.isRecent,
    required this.range,
    required this.startDateTime,
    required this.endDateTime,
  });

  bool isRecent;
  int range;
  DateTime startDateTime, endDateTime;

  @override
  State<TrackerContainer> createState() => _TrackerContainerState();
}

class _TrackerContainerState extends State<TrackerContainer> {
  UserBox user = userRepository.user;
  List<TrackerItemClass> trackerItemList = [];

  getTrackerItemList() {
    List<TrackerItemClass> result = [];

    for (var day = 0; day <= widget.range; day++) {
      DateTime dateTime = jumpDayDateTime(
        type: jumpDayTypeEnum.subtract,
        dateTime: widget.endDateTime,
        days: day,
      );
      int recordKey = getDateTimeToInt(dateTime);
      RecordBox? record = recordRepository.recordBox.get(recordKey);
      TrackerItemClass trackerItem = TrackerItemClass(
        dateTime: dateTime,
        record: record,
      );

      result.add(trackerItem);
    }

    setState(
      () =>
          trackerItemList = widget.isRecent ? result : result.reversed.toList(),
    );
  }

  @override
  void initState() {
    getTrackerItemList();
    onWindowManager();

    super.initState();
  }

  @override
  void didUpdateWidget(covariant TrackerContainer oldWidget) {
    getTrackerItemList();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    Map<int, TableColumnWidth> columnWidths = const {0: IntrinsicColumnWidth()};
    List<String> trackerDisplayList = user.trackerDisplayList ?? [];
    trackerDisplayList
        .sort((a, b) => filterIndex[a]!.compareTo(filterIndex[b]!));

    bool isWeight = trackerDisplayList.contains(fWeight);
    bool isDiary = trackerDisplayList.contains(fDiary);
    int index = trackerDisplayList.indexOf(fDiary) + 1;

    if (isWeight && !isDiary) {
      columnWidths = const {
        0: FlexColumnWidth(2.5),
        1: FlexColumnWidth(1.5),
      };
    } else if (!isWeight && isDiary) {
      columnWidths = {
        0: const FlexColumnWidth(2.5),
        index: const FlexColumnWidth(6),
      };
    } else if (isWeight && isDiary) {
      columnWidths = {
        0: const FlexColumnWidth(2.5),
        1: const FlexColumnWidth(1.5),
        index: const FlexColumnWidth(4),
      };
    }

    return Expanded(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
          child: ContentsBox(
            width: double.infinity,
            padding: const EdgeInsets.all(5),
            contentsWidget: Table(
              border: TableBorder.symmetric(
                inside: BorderSide(width: 0.0, color: grey.s300),
              ),
              columnWidths: columnWidths,
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: <TableRow>[
                trackerTitle(),
                ...trackerItemList.map((item) => trackerItem(item)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  trackerTitle() {
    List<String>? trackerDisplayList = user.trackerDisplayList ?? [];
    List<TableTitleClass> trackerTitleList = trackerTitleClassList.where(
      (trackerTitle) {
        if (trackerTitle.id == 'dateTime') return true;
        return trackerDisplayList.contains(trackerTitle.id);
      },
    ).toList();

    return TableRow(
      children: trackerTitleList
          .map(
            (trackerTitle) => SizedBox(
              height: 32,
              child: Center(
                child: CommonName(
                  text: trackerTitle.title,
                  color: grey.original,
                  fontSize: 13,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  trackerItem(TrackerItemClass item) {
    String locale = context.locale.toString();
    RecordBox? record = item.record;
    Uint8List? unit8List = record?.leftFile ??
        record?.rightFile ??
        record?.topFile ??
        record?.bottomFile;
    bool isDiet = nullCheckAction(record?.actions, eDiet) != null;
    bool isExercise = nullCheckAction(record?.actions, eExercise) != null;
    List<String>? trackerDisplayList = user.trackerDisplayList ?? [];

    dateTime() {
      return SizedBox(
        height: 35,
        child: Center(
          child: CommonName(
            text: mdeS(locale: locale, dateTime: item.dateTime),
            overflow: TextOverflow.ellipsis,
            fontSize: 12,
            isNotTr: true,
            color: textColor,
          ),
        ),
      );
    }

    weight() {
      return SizedBox(
        width: 50,
        child: Center(
          child: CommonName(
            text: '${record?.weight ?? ''}',
            fontSize: 13,
            isNotTr: true,
          ),
        ),
      );
    }

    picture() {
      return Center(
        child: unit8List != null
            ? DefaultImage(
                unit8List: unit8List,
                width: 23,
                height: 23,
                borderRadius: 5,
              )
            : const EmptyArea(),
      );
    }

    diet() {
      return Center(
        child: isDiet
            ? getSvg(name: 'check', width: 17, color: teal.s200)
            : const EmptyArea(),
      );
    }

    exercise() {
      return Center(
        child: isExercise
            ? getSvg(name: 'check', width: 17, color: lightBlue.s200)
            : const EmptyArea(),
      );
    }

    diary() {
      return Padding(
        padding: const EdgeInsets.only(left: 8),
        child: CommonName(
          text: record?.whiteText ?? '',
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.start,
          isNotTr: true,
          fontSize: 13,
        ),
      );
    }

    List<Widget> children = [dateTime()];
    trackerDisplayList
        .sort((a, b) => filterIndex[a]!.compareTo(filterIndex[b]!));

    for (var i = 0; i < trackerDisplayList.length; i++) {
      String target = trackerDisplayList[i];

      if (target == fWeight) {
        children.add(weight());
      } else if (target == fPicture) {
        children.add(picture());
      } else if (target == fDiet) {
        children.add(diet());
      } else if (target == fExercise) {
        children.add(exercise());
      } else if (target == fDiary) {
        children.add(diary());
      }
    }

    return TableRow(children: children);
  }
}
