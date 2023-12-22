import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/widget(etc)/widgets/history_segmented_empty_widget.dart';
import 'package:flutter_app_weight_management/widget(etc)/widgets/history_segmented_item_widget.dart';
import 'package:flutter_app_weight_management/provider/diet_Info_provider.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';
import 'package:flutter_app_weight_management/widgets/history_edit_button_widget.dart';
import 'package:flutter_app_weight_management/widgets/history_sub_text_widget.dart';
import 'package:provider/provider.dart';

class HistorySegmentedWeightWidget extends StatelessWidget {
  const HistorySegmentedWeightWidget({super.key});

  @override
  Widget build(BuildContext context) {
    String weightText = context.watch<DietInfoProvider>().getWeightText();
    // String bodyFatText = context.watch<DietInfoProvider>().getBodyFatText();
    // todo: hive 데이터 사용해야 함.

    setWeight() {
      return weightText != '' ? '$weightText kg' : '-';
    }

    setBodyFat() {
      return '' != '' ? '%' : '-';
    }

    onTapSuffixWidget(String id) {}

    setWidget() {
      if (weightText == '') {
        return HistorySegmentedEmptyWidget(segmented: SegmentedTypes.weight);
      }

      return Column(
        children: [
          HistorySegmentedItemWidget(
            icon: Icons.monitor_weight,
            name: '체중',
            subWidget: HistorySubTextWidget(
              text: setWeight(),
              color: themeColor,
            ),
            suffixWidget: HistoryEditButtonWidget(
              id: 'weight',
              onTap: onTapSuffixWidget,
            ),
          ),
          HistorySegmentedItemWidget(
            name: '체지방률',
            icon: Icons.align_vertical_bottom,
            subWidget: HistorySubTextWidget(
              text: setBodyFat(),
              color: themeColor,
            ),
            suffixWidget: HistoryEditButtonWidget(
              id: 'bodyFat',
              onTap: onTapSuffixWidget,
            ),
          )
        ],
      );
    }

    return Container(child: setWidget());
  }
}
