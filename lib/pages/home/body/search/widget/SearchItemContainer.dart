import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/area/empty_area.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/main.dart';
import 'package:flutter_app_weight_management/model/record_box/record_box.dart';
import 'package:flutter_app_weight_management/pages/home/body/history/widget/history_container.dart';
import 'package:flutter_app_weight_management/utils/function.dart';

class SearchItemContainer extends StatelessWidget {
  SearchItemContainer({super.key, required this.controller});

  TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    String keyword = controller.text;
    return keyword != '' ? SearchItemList(keyword: keyword) : const EmptyArea();
  }
}

class SearchItemList extends StatelessWidget {
  SearchItemList({super.key, required this.keyword});

  String keyword;

  @override
  Widget build(BuildContext context) {
    List<RecordBox> recordList = recordRepository.recordList;
    List<RecordBox> recordSearchList = recordList.where((record) {
      List<Map<String, dynamic>>? actions = record.actions;
      String? whiteText = record.whiteText;
      List<Map<String, String>>? hashTagList = record.recordHashTagList;
      bool isKeywordInAction = actions?.any((action) {
            String name = action['name'] as String;
            return name.contains(keyword);
          }) ==
          true;
      bool isKeywordInWhiteText = whiteText?.contains(keyword) == true;
      bool isKeywordInHashTag =
          hashTagList?.any((hashTag) => hashTag['text']!.contains(keyword)) ==
              true;

      return isKeywordInAction || isKeywordInWhiteText || isKeywordInHashTag;
    }).toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 10),
      child: SingleChildScrollView(
        child: Column(
          children: recordSearchList
              .map((recordInfo) => SearchItem(recordInfo: recordInfo))
              .toList(),
        ),
      ),
    );
  }
}

class SearchItem extends StatelessWidget {
  SearchItem({super.key, required this.recordInfo});

  RecordBox recordInfo;

  @override
  Widget build(BuildContext context) {
    String locale = context.locale.toString();
    DateTime createDateTime = recordInfo.createDateTime;
    int recordKey = getDateTimeToInt(createDateTime);
    String formatDateTime = mde(locale: locale, dateTime: createDateTime);

    bool isPicture = true;
    bool isDiaryText = true;
    bool isDiaryHashTag = true;

    return ContentsBox(
      contentsWidget: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HistoryHeader(
            locale: locale,
            createDateTime: createDateTime,
            formatDateTime: formatDateTime,
            isRemoveMode: false,
            recordInfo: recordInfo,
            onTapMore: () {},
          ),
          isPicture
              ? HistoryPicture(
                  isRemoveMode: false,
                  recordInfo: recordInfo,
                )
              : const EmptyArea(),
          HistoryTodo(
            isRemoveMode: false,
            recordInfo: recordInfo,
          ),
          isDiaryText
              ? HistoryDiaryText(
                  isRemoveMode: false,
                  recordInfo: recordInfo,
                )
              : const EmptyArea(),
          isDiaryHashTag
              ? HistoryHashTag(
                  isRemoveMode: false,
                  recordInfo: recordInfo,
                )
              : const EmptyArea(),
        ],
      ),
    );
  }
}
