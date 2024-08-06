import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/common/CommonName.dart';
import 'package:flutter_app_weight_management/widgets/area/empty_area.dart';
import 'package:flutter_app_weight_management/widgets/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/main.dart';
import 'package:flutter_app_weight_management/model/record_box/record_box.dart';
import 'package:flutter_app_weight_management/model/user_box/user_box.dart';
import 'package:flutter_app_weight_management/provider/search_filter_provider.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:flutter_app_weight_management/utils/variable.dart';
import 'package:flutter_app_weight_management/widgets/history/HistoryDiaryText.dart';
import 'package:flutter_app_weight_management/widgets/history/HistoryHashTag.dart';
import 'package:flutter_app_weight_management/widgets/history/HistoryHeader.dart';
import 'package:flutter_app_weight_management/widgets/history/HistoryPicture.dart';
import 'package:flutter_app_weight_management/widgets/history/HistoryTodo.dart';
import 'package:flutter_app_weight_management/widgets/search/SearchHashTag.dart';
import 'package:provider/provider.dart';

class SearchItemContainer extends StatelessWidget {
  SearchItemContainer({
    super.key,
    required this.controller,
    required this.initialScrollIndex,
    required this.onHashTag,
  });

  TextEditingController controller;
  int initialScrollIndex;
  Function(String) onHashTag;

  @override
  Widget build(BuildContext context) {
    String keyword = controller.text;
    bool isEmptyKeyword = keyword == '';
    bool isRecent = context.watch<SearchFilterProvider>().searchFilter ==
        SearchFilter.recent;
    List<RecordBox> recordSearchList = isEmptyKeyword
        ? []
        : getSearchList(
            recordList: recordRepository.recordList,
            keyword: controller.text,
            isRecent: isRecent,
          );
    bool isShowEmptyResult = !isEmptyKeyword && recordSearchList.isEmpty;
    Widget wSpacer = isShowEmptyResult ? const Spacer() : const EmptyArea();

    return Column(
      children: [
        SearchHashTag(
          keyword: keyword,
          initialScrollIndex: initialScrollIndex,
          onHashTag: onHashTag,
        ),
        Expanded(
          child: isShowEmptyResult
              ? Column(
                  children: [
                    wSpacer,
                    Icon(Icons.search_rounded, color: grey.original),
                    CommonName(text: '검색 결과가 없어요', color: grey.original),
                    wSpacer
                  ],
                )
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Column(
                      children: recordSearchList
                          .map((recordInfo) =>
                              SearchItem(recordInfo: recordInfo))
                          .toList(),
                    ),
                  ),
                ),
        ),
      ],
    );
  }
}

class SearchItem extends StatelessWidget {
  SearchItem({super.key, required this.recordInfo});

  RecordBox recordInfo;

  @override
  Widget build(BuildContext context) {
    UserBox user = userRepository.user;
    List<String> searchDisplayList = user.searchDisplayList ?? [];
    // bool isWeight = searchDisplayList.contains(fWeight);
    // bool isPicture = searchDisplayList.contains(fPicture);
    // bool isDiaryText = searchDisplayList.contains(fDiary);
    // bool isDiaryHashTag = searchDisplayList.contains(fDiary_2);
    // bool isDietRecord = searchDisplayList.contains(fDiet);
    // bool isExerciseRecord = searchDisplayList.contains(fExercise);
    // bool isDietGoal = searchDisplayList.contains(fDiet_2);
    // bool isExerciseGoal = searchDisplayList.contains(fExercise_2);
    // bool isLife = searchDisplayList.contains(fLife);

    return Padding(
      padding: const EdgeInsets.only(left: 7, right: 7, bottom: 10),
      child: ContentsBox(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // HistoryHeader(
            //   recordInfo: recordInfo,
            //   isRemoveMode: false,
            //   isWeight: isWeight,
            //   isDiary: isDiaryText,
            // ),
            // isPicture
            //     ? HistoryPicture(
            //         isRemoveMode: false,
            //         recordInfo: recordInfo,
            //       )
            //     : const EmptyArea(),
            // HistoryTodo(
            //   recordInfo: recordInfo,
            //   isRemoveMode: false,
            //   isDietRecord: isDietRecord,
            //   isDietGoal: isDietGoal,
            //   isExerciseRecord: isExerciseRecord,
            //   isExerciseGoal: isExerciseGoal,
            //   isLife: isLife,
            // ),
            // isDiaryText
            //     ? HistoryDiaryText(
            //         isRemoveMode: false,
            //         recordInfo: recordInfo,
            //       )
            //     : const EmptyArea(),
            // isDiaryHashTag
            //     ? HistoryHashTag(
            //         isRemoveMode: false,
            //         recordInfo: recordInfo,
            //       )
            //     : const EmptyArea(),
          ],
        ),
      ),
    );
  }
}
