import 'dart:typed_data';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/common/CommonAppBar.dart';
import 'package:flutter_app_weight_management/common/CommonName.dart';
import 'package:flutter_app_weight_management/components/area/empty_area.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/image/default_image.dart';
import 'package:flutter_app_weight_management/components/maker/PictureMaker.dart';
import 'package:flutter_app_weight_management/components/segmented/default_segmented.dart';
import 'package:flutter_app_weight_management/main.dart';
import 'package:flutter_app_weight_management/model/record_box/record_box.dart';
import 'package:flutter_app_weight_management/pages/home/body/record/record_body.dart';
import 'package:flutter_app_weight_management/provider/premium_provider.dart';
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

    onSegmentedDateTimeChanged(SegmentedTypes? type) {
      if (isPremium == false) {
        return;
      }

      setState(() => selectedDateTimeSegment = type!);
    }

    return MultiValueListenableBuilder(
      valueListenables: valueListenables,
      builder: (context, values, child) => Column(
        children: [
          CommonAppBar(),
          TrackerContainer(
            range: rangeInfo[selectedDateTimeSegment]!,
            startDateTime: startDateTime,
            endDateTime: endDateTime,
          ),
          // const Spacer(),
          Padding(
            padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
            child: DefaultSegmented(
              selectedSegment: selectedDateTimeSegment,
              children: rangeSegmented(selectedDateTimeSegment),
              backgroundColor: typeBackgroundColor,
              thumbColor: whiteBgBtnColor,
              onSegmentedChanged: onSegmentedDateTimeChanged,
            ),
          )
        ],
      ),
    );
  }
}

class TrackerContainer extends StatefulWidget {
  TrackerContainer({
    super.key,
    required this.range,
    required this.startDateTime,
    required this.endDateTime,
  });

  int range;
  DateTime startDateTime, endDateTime;

  @override
  State<TrackerContainer> createState() => _TrackerContainerState();
}

class _TrackerContainerState extends State<TrackerContainer> {
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

    setState(() => trackerItemList = result);
  }

  @override
  void initState() {
    getTrackerItemList();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant TrackerContainer oldWidget) {
    getTrackerItemList();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
          child: ContentsBox(
            width: double.infinity,
            padding: const EdgeInsets.all(5),
            contentsWidget: Table(
              border: TableBorder.symmetric(
                inside: BorderSide(width: 0.0, color: grey.s300),
              ),
              columnWidths: const <int, TableColumnWidth>{
                0: IntrinsicColumnWidth(),
                1: IntrinsicColumnWidth(),
                5: IntrinsicColumnWidth(),
              },
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
    return TableRow(
      children: tableTitleClassList
          .map(
            (tableTitle) => SizedBox(
              width: tableTitle.width,
              height: 32,
              child: Center(
                child: CommonName(
                  text: tableTitle.title,
                  color: grey.original,
                  fontSize: 13,
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

    return TableRow(
      children: <Widget>[
        SizedBox(
          width: 80,
          height: 32,
          child: Center(
            child: CommonName(
              text: mde(locale: locale, dateTime: item.dateTime),
              overflow: TextOverflow.ellipsis,
              fontSize: 12,
              isNotTr: true,
            ),
          ),
        ),
        SizedBox(
          width: 50,
          child: Center(
            child: CommonName(
              text: '${record?.weight ?? ''}',
              fontSize: 13,
              isNotTr: true,
            ),
          ),
        ),
        Center(
          child: unit8List != null
              ? DefaultImage(
                  unit8List: unit8List,
                  width: 23,
                  height: 23,
                  borderRadius: 5,
                )
              : const EmptyArea(),
        ),
        Center(
          child: isDiet
              ? getSvg(name: 'check', width: 17, color: teal.s200)
              : const EmptyArea(),
        ),
        Center(
          child: isExercise
              ? getSvg(name: 'check', width: 17, color: lightBlue.s200)
              : const EmptyArea(),
        ),
        SizedBox(
          width: 120,
          child: Padding(
            padding: const EdgeInsets.only(left: 8),
            child: CommonName(
              text: record?.whiteText ?? '',
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.start,
              isNotTr: true,
              fontSize: 13,
            ),
          ),
        )
      ],
    );
  }
}
