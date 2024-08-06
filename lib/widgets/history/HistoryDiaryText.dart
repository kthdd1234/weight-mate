import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/widgets/area/empty_area.dart';
import 'package:flutter_app_weight_management/widgets/history/HistoryRemove.dart';
import 'package:flutter_app_weight_management/widgets/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/model/record_box/record_box.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:flutter_app_weight_management/utils/variable.dart';

class HistoryDiaryText extends StatelessWidget {
  HistoryDiaryText({
    super.key,
    required this.isRemoveMode,
    required this.recordInfo,
  });

  bool isRemoveMode;
  RecordBox? recordInfo;

  onTapRemoveDiary() async {
    recordInfo?.diaryDateTime = null;
    recordInfo?.whiteText = null;

    await recordInfo?.save();
  }

  @override
  Widget build(BuildContext context) {
    return recordInfo?.whiteText != null
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        recordInfo!.whiteText!,
                        style: const TextStyle(
                          color: textColor,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    isRemoveMode
                        ? Padding(
                            padding: const EdgeInsets.only(top: 3, left: 3),
                            child: HistoryRemove(onTap: onTapRemoveDiary),
                          )
                        : const EmptyArea(),
                  ],
                ),
              ),
              SpaceHeight(height: tinySpace),
              Text(
                hm(
                  locale: context.locale.toString(),
                  dateTime: recordInfo?.diaryDateTime ?? DateTime.now(),
                ),
                style: TextStyle(color: grey.original, fontSize: 11),
              ),
            ],
          )
        : const EmptyArea();
  }
}
