import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/widget(etc)/widgets/history_segmented_empty_widget.dart';
import 'package:flutter_app_weight_management/widget(etc)/widgets/history_segmented_item_widget.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';
import 'package:flutter_app_weight_management/widgets/history_edit_button_widget.dart';
import 'package:flutter_app_weight_management/widgets/history_sub_text_widget.dart';

class HistorySegmentedMemoWidget extends StatelessWidget {
  const HistorySegmentedMemoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // String todayMemoText = context.watch<DietInfoProvider>().getTodayMemoText();
    // hive box 를 통해 값을 가져오기

    setWidget() {
      if ('' == '') {
        return HistorySegmentedEmptyWidget(segmented: SegmentedTypes.diary);
      }

      onTapSuffixWidget(String id) {}

      return Column(
        children: [
          HistorySegmentedItemWidget(
            icon: Icons.textsms,
            name: '눈바디',
            subWidget: HistorySubTextWidget(
              text: '',
              color: buttonBackgroundColor,
            ),
            suffixWidget: HistoryEditButtonWidget(
              id: 'memo',
              onTap: onTapSuffixWidget,
            ),
          ),
          HistorySegmentedItemWidget(
            icon: Icons.photo,
            name: '눈바디',
            subWidget: ContentsBox(
              contentsWidget: Image.asset(
                'assets/images/Deep-Space-Travel.jpeg',
              ),
            ),
          ),
        ],
      );
    }

    return Container(child: setWidget());
  }
}
