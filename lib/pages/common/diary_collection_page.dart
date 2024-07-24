import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/common/CommonBackground.dart';
import 'package:flutter_app_weight_management/common/CommonBlur.dart';
import 'package:flutter_app_weight_management/common/CommonBottomSheet.dart';
import 'package:flutter_app_weight_management/common/CommonIcon.dart';
import 'package:flutter_app_weight_management/common/CommonScaffold.dart';
import 'package:flutter_app_weight_management/common/CommonSvg.dart';
import 'package:flutter_app_weight_management/common/CommonText.dart';
import 'package:flutter_app_weight_management/components/area/empty_area.dart';
import 'package:flutter_app_weight_management/components/button/expanded_button_verti.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/main.dart';
import 'package:flutter_app_weight_management/model/record_box/record_box.dart';
import 'package:flutter_app_weight_management/pages/common/diary_write_page.dart';
import 'package:flutter_app_weight_management/pages/common/weight_chart_page.dart';
import 'package:flutter_app_weight_management/pages/home/body/record/edit/edit_diary.dart';
import 'package:flutter_app_weight_management/utils/class.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:flutter_app_weight_management/utils/variable.dart';

class DiaryCollectionPage extends StatefulWidget {
  const DiaryCollectionPage({super.key});

  @override
  State<DiaryCollectionPage> createState() => _DiaryCollectionPageState();
}

class _DiaryCollectionPageState extends State<DiaryCollectionPage> {
  DateTime selectedYear = DateTime.now();
  bool isRecent = true;

  @override
  Widget build(BuildContext context) {
    List<RecordBox> recordList = recordRepository.recordBox.values.toList();
    List<RecordBox> selectedRecordList = recordList
        .where(
          (record) =>
              (yToInt(record.createDateTime) == yToInt(selectedYear)) &&
              (record.emotion != null ||
                  record.whiteText != null ||
                  (record.recordHashTagList != null &&
                      record.recordHashTagList?.length != 0)),
        )
        .toList();
    List<RecordBox> orderList =
        isRecent ? selectedRecordList.reversed.toList() : selectedRecordList;

    onTapYear() {
      showDialogDateTimeYear(
        context: context,
        initialSelectedDate: selectedYear,
        onDateTime: (DateTime dateTime) {
          setState(() => selectedYear = dateTime);
        },
      );
    }

    onTapOrder() {
      setState(() => isRecent = !isRecent);
    }

    onEdit(DateTime dateTime) async {
      closeDialog(context);

      await Navigator.push(
        context,
        MaterialPageRoute<void>(
          builder: (BuildContext context) => DiaryWritePage(
            dateTime: dateTime,
          ),
        ),
      );

      setState(() => {});
    }

    onRemove(DateTime dateTime) async {
      int recordKey = getDateTimeToInt(dateTime);
      RecordBox? record = recordRepository.recordBox.get(recordKey);

      record?.emotion = null;
      record?.whiteText = null;
      record?.diaryDateTime = null;

      await record?.save();

      setState(() => {});
      closeDialog(context);
    }

    return CommonBackground(
      child: CommonScaffold(
        appBarInfo: AppBarInfoClass(
          title: '일기 모아보기',
          actions: [
            RowTags(
              selectedYear: selectedYear,
              isRecent: isRecent,
              onTapYear: onTapYear,
              onTapOrder: onTapOrder,
            )
          ],
        ),
        body: Stack(
          children: [
            orderList.isNotEmpty
                ? ListView(
                    children: orderList
                        .map(
                          (record) => Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: ContentsBox(
                              contentsWidget: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  DiaryItemTitle(
                                    dateTime: record.createDateTime,
                                    emotion: record.emotion,
                                    onEdit: onEdit,
                                    onRemove: onRemove,
                                  ),
                                  DiaryItemContent(
                                    whiteText: record.whiteText,
                                    whiteDateTime: record.diaryDateTime,
                                  ),
                                  DiaryHashTag(
                                    hashTagClassList: getHashTagClassList(
                                      record.recordHashTagList,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  )
                : EmptyWidget(icon: Icons.edit, text: "기록이 없어요."),
            CommonBlur()
          ],
        ),
      ),
    );
  }
}

class DiaryItemTitle extends StatelessWidget {
  DiaryItemTitle({
    super.key,
    required this.dateTime,
    required this.onEdit,
    required this.onRemove,
    this.emotion,
  });

  DateTime dateTime;
  String? emotion;
  Function(DateTime) onEdit;
  Function(DateTime) onRemove;

  @override
  Widget build(BuildContext context) {
    String locale = context.locale.toString();

    onTapMore() {
      showModalBottomSheet(
        context: context,
        builder: (context) => CommonBottomSheet(
          title: md(locale: locale, dateTime: dateTime),
          height: 200,
          contents: Row(
            children: [
              ExpandedButtonVerti(
                mainColor: textColor,
                icon: Icons.edit,
                title: '일기 수정',
                onTap: () => onEdit(dateTime),
              ),
              SpaceWidth(width: 5),
              ExpandedButtonVerti(
                mainColor: Colors.red,
                icon: Icons.delete,
                title: '일기 삭제',
                onTap: () => onRemove(dateTime),
              )
            ],
          ),
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            emotion != null
                ? Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: CommonSvg(
                      name: emotion!,
                      width: 45,
                    ),
                  )
                : const EmptyArea(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonText(
                  text: md(locale: locale, dateTime: dateTime),
                  size: 14,
                  isNotTr: true,
                  color: themeColor,
                ),
                SpaceHeight(height: 2),
                CommonText(
                  text: e(locale: locale, dateTime: dateTime),
                  size: 14,
                  color: grey.original,
                  isNotTr: true,
                )
              ],
            ),
          ],
        ),
        InkWell(
          onTap: onTapMore,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 0, 20),
            child: CommonIcon(
              icon: Icons.more_vert_rounded,
              size: 18,
            ),
          ),
        )
      ],
    );
  }
}

class DiaryItemContent extends StatelessWidget {
  DiaryItemContent({
    super.key,
    this.whiteText,
    this.whiteDateTime,
  });

  String? whiteText;
  DateTime? whiteDateTime;

  @override
  Widget build(BuildContext context) {
    String locale = context.locale.toString();

    return whiteText != null
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 5),
                child: Text(whiteText!),
              ),
              CommonText(
                text: hm(locale: locale, dateTime: whiteDateTime!),
                size: 13,
                color: grey.original,
                isNotTr: true,
              )
            ],
          )
        : const EmptyArea();
  }
}

class DiaryItemHashTag extends StatelessWidget {
  const DiaryItemHashTag({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [],
    );
  }
}
