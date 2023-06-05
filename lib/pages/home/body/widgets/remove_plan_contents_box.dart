import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/divider/width_divider.dart';
import 'package:flutter_app_weight_management/components/icon/default_icon.dart';
import 'package:flutter_app_weight_management/components/icon/text_icon.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/components/text/body_small_text.dart';
import 'package:flutter_app_weight_management/utils/class.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';

class RemovePlanContentsBox extends StatelessWidget {
  const RemovePlanContentsBox({super.key});

  @override
  Widget build(BuildContext context) {
    columnWidgets() {
      List<RemovePlanClass> removePlanList = [
        RemovePlanClass(
            id: 'remove-1',
            planName: '간헐적 단식 16:8',
            groupName: '식이요법',
            startDateTime: DateTime.now(),
            endDateTime: DateTime.now(),
            isChecked: false),
        RemovePlanClass(
            id: 'remove-2',
            planName: '간헐적 단식 16:8',
            groupName: '식이요법',
            startDateTime: DateTime.now(),
            endDateTime: DateTime.now(),
            isChecked: false),
        RemovePlanClass(
            id: 'remove-3',
            planName: '간헐적 단식 16:8',
            groupName: '식이요법',
            startDateTime: DateTime.now(),
            endDateTime: DateTime.now(),
            isChecked: false),
        RemovePlanClass(
            id: 'remove-4',
            planName: '간헐적 단식 16:8',
            groupName: '식이요법',
            startDateTime: DateTime.now(),
            endDateTime: DateTime.now(),
            isChecked: false),
        RemovePlanClass(
            id: 'remove-5',
            planName: '간헐적 단식 16:8',
            groupName: '식이요법',
            startDateTime: DateTime.now(),
            endDateTime: DateTime.now(),
            isChecked: false),
        RemovePlanClass(
            id: 'remove-6',
            planName: '간헐적 단식 16:8',
            groupName: '식이요법',
            startDateTime: DateTime.now(),
            endDateTime: DateTime.now(),
            isChecked: false),
        RemovePlanClass(
            id: 'remove-7',
            planName: '간헐적 단식 16:8',
            groupName: '식이요법',
            startDateTime: DateTime.now(),
            endDateTime: DateTime.now(),
            isChecked: false),
      ];

      onTap(dynamic id) {
        print(id);
      }

      return ListView.builder(
          itemCount: removePlanList.length,
          itemBuilder: (context, index) {
            final item = removePlanList[index];

            return Column(
              children: [
                InkWell(
                  onTap: () => onTap(item.id),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 5,
                        child: Row(
                          children: [
                            DefaultIcon(
                              id: item.id,
                              iconSize: 25,
                              icon: item.isChecked
                                  ? Icons.check_box
                                  : Icons.check_box_outline_blank,
                              color: buttonBackgroundColor,
                              onTap: onTap,
                            ),
                            SpaceWidth(width: regularSapce),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                BodySmallText(text: item.groupName),
                                SpaceHeight(height: tinySpace),
                                Text(item.planName),
                              ],
                            )
                          ],
                        ),
                      ),
                      TextIcon(
                        backgroundColor: dialogBackgroundColor,
                        text: '실천 5회',
                        borderRadius: 10,
                        textColor: Colors.grey,
                        fontSize: 9,
                      )
                    ],
                  ),
                ),
                SpaceHeight(height: regularSapce),
              ],
            );
          });
    }

    return ContentsBox(
      height: 200,
      contentsWidget: columnWidgets(),
    );
  }
}
