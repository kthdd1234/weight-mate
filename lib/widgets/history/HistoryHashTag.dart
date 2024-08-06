import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/pages/home/record/edit/edit_diary.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:flutter_app_weight_management/widgets/area/empty_area.dart';
import 'package:flutter_app_weight_management/widgets/history/HistoryRemove.dart';
import 'package:flutter_app_weight_management/model/record_box/record_box.dart';
import 'package:flutter_app_weight_management/utils/class.dart';

class HistoryHashTag extends StatelessWidget {
  HistoryHashTag({
    super.key,
    required this.isRemoveMode,
    required this.recordInfo,
  });

  bool isRemoveMode;
  RecordBox? recordInfo;

  onTapRemoveHashTag() async {
    recordInfo?.recordHashTagList = [];
    await recordInfo?.save();
  }

  @override
  Widget build(BuildContext context) {
    List<HashTagClass> hashTagClassList =
        getHashTagClassList(recordInfo?.recordHashTagList);
    bool isShow = hashTagClassList.isNotEmpty;

    return isShow
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DiaryHashTag(
                hashTagClassList: hashTagClassList,
                paddingTop: 10,
              ),
              isRemoveMode
                  ? Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: HistoryRemove(onTap: onTapRemoveHashTag),
                    )
                  : const EmptyArea(),
            ],
          )
        : const EmptyArea();
  }
}
