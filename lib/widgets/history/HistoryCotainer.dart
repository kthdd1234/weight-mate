import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/common/CommonBottomSheet.dart';
import 'package:flutter_app_weight_management/widgets/ads/native_container.dart';
import 'package:flutter_app_weight_management/widgets/area/empty_area.dart';
import 'package:flutter_app_weight_management/main.dart';
import 'package:flutter_app_weight_management/model/record_box/record_box.dart';
import 'package:flutter_app_weight_management/model/user_box/user_box.dart';
import 'package:flutter_app_weight_management/provider/bottom_navigation_provider.dart';
import 'package:flutter_app_weight_management/provider/import_date_time_provider.dart';
import 'package:flutter_app_weight_management/provider/title_datetime_provider.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:flutter_app_weight_management/utils/variable.dart';
import 'package:flutter_app_weight_management/widgets/history/HistoryDiaryText.dart';
import 'package:flutter_app_weight_management/widgets/history/HistoryHashTag.dart';
import 'package:flutter_app_weight_management/widgets/history/HistoryHeader.dart';
import 'package:flutter_app_weight_management/widgets/history/HistoryMore.dart';
import 'package:flutter_app_weight_management/widgets/history/HistoryPicture.dart';
import 'package:flutter_app_weight_management/widgets/history/HistoryTodo.dart';
import 'package:provider/provider.dart';

class HistoryContainer extends StatelessWidget {
  HistoryContainer({
    super.key,
    required this.recordInfo,
    required this.isRemoveMode,
  });

  RecordBox recordInfo;
  bool isRemoveMode;

  @override
  Widget build(BuildContext context) {
    String locale = context.locale.toString();
    DateTime createDateTime = recordInfo.createDateTime;
    bool isAd = createDateTime.year == 1000;
    int recordKey = getDateTimeToInt(createDateTime);
    String formatDateTime = mde(locale: locale, dateTime: createDateTime);

    /** 필터 */
    UserBox user = userRepository.user;
    List<String> historyDisplayList = user.historyDisplayList ?? [];
    bool isWeightMorning = historyDisplayList.contains(fWeight);
    bool isWeightNight = historyDisplayList.contains(fWeightNight);
    bool isPicture = historyDisplayList.contains(fPicture);
    bool isDiaryText = historyDisplayList.contains(fDiary);
    bool isDiaryHashTag = historyDisplayList.contains(fDiary_2);
    bool isDietRecord = historyDisplayList.contains(fDiet);
    bool isExerciseRecord = historyDisplayList.contains(fExercise);
    bool isDietGoal = historyDisplayList.contains(fDiet_2);
    bool isExerciseGoal = historyDisplayList.contains(fExercise_2);
    bool isLife = historyDisplayList.contains(fLife);

    onTapEdit() {
      context.read<ImportDateTimeProvider>().setImportDateTime(createDateTime);
      context.read<TitleDateTimeProvider>().setTitleDateTime(createDateTime);
      context
          .read<BottomNavigationProvider>()
          .setBottomNavigation(enumId: BottomNavigationEnum.record);

      closeDialog(context);
    }

    onTapRemove() async {
      recordRepository.recordBox.delete(recordKey);
      closeDialog(context);
    }

    onTapPartialDelete() {
      closeDialog(context);
      Navigator.pushNamed(
        context,
        '/partial-delete-page',
        arguments: recordKey,
      );
    }

    onTapMore() {
      if (isRemoveMode == false) {
        showModalBottomSheet(
          context: context,
          builder: (context) {
            return CommonBottomSheet(
              title: formatDateTime,
              height: 200,
              contents: HistoryMore(
                onTapEdit: onTapEdit,
                onTapPartialDelete: onTapPartialDelete,
                onTapRemove: onTapRemove,
              ),
            );
          },
        );
      }
    }

    return isAd
        ? NativeContainer()
        : GestureDetector(
            onTap: onTapMore,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HistoryHeader(
                  recordInfo: recordInfo,
                  isRemoveMode: isRemoveMode,
                  isWeightMorning: isWeightMorning,
                  isWeightNight: isWeightNight,
                  isDiary: isDiaryText,
                  onTapMore: onTapMore,
                ),
                isPicture
                    ? HistoryPicture(
                        isRemoveMode: isRemoveMode,
                        recordInfo: recordInfo,
                      )
                    : const EmptyArea(),
                HistoryTodo(
                  isRemoveMode: isRemoveMode,
                  recordInfo: recordInfo,
                  isDietRecord: isDietRecord,
                  isDietGoal: isDietGoal,
                  isExerciseRecord: isExerciseRecord,
                  isExerciseGoal: isExerciseGoal,
                  isLife: isLife,
                ),
                isDiaryText
                    ? HistoryDiaryText(
                        isRemoveMode: isRemoveMode,
                        recordInfo: recordInfo,
                      )
                    : const EmptyArea(),
                isDiaryHashTag
                    ? HistoryHashTag(
                        isRemoveMode: isRemoveMode,
                        recordInfo: recordInfo,
                      )
                    : const EmptyArea(),
              ],
            ),
          );
  }
}
