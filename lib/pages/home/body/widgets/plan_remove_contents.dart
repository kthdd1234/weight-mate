import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/icon/default_icon.dart';
import 'package:flutter_app_weight_management/components/icon/text_icon.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/components/text/body_small_text.dart';
import 'package:flutter_app_weight_management/model/plan_box/plan_box.dart';
import 'package:flutter_app_weight_management/model/record_box/record_box.dart';
import 'package:flutter_app_weight_management/utils/class.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:flutter_app_weight_management/widgets/dafault_bottom_sheet.dart';
import 'package:hive_flutter/hive_flutter.dart';

class PlanRemoveContents extends StatefulWidget {
  PlanRemoveContents({
    super.key,
    required this.recordBox,
    required this.planBox,
    required this.recordBoxList,
    required this.planInfoList,
  });

  Box<RecordBox> recordBox;
  Box<PlanBox> planBox;
  List<RecordBox> recordBoxList;
  List<PlanInfoClass> planInfoList;

  @override
  State<PlanRemoveContents> createState() => _PlanRemoveContentsState();
}

class _PlanRemoveContentsState extends State<PlanRemoveContents> {
  List<String> removeIds = [];

  @override
  Widget build(BuildContext context) {
    onTap(String id) {
      setState(
        () => removeIds.contains(id) ? removeIds.remove(id) : removeIds.add(id),
      );
    }

    onSubmit() {
      if (removeIds.isNotEmpty) {
        widget.planBox.deleteAll(removeIds);

        for (var i = 0; i < widget.recordBoxList.length; i++) {
          final recordInfo = widget.recordBoxList[i];
          final actions = recordInfo.actions;

          if (actions != null) {
            for (var removeId in removeIds) {
              if (actions.contains(removeId)) {
                actions.remove(removeId);
                recordInfo.save();
              }
            }
          }
        }

        closeDialog(context);
      }

      return null;
    }

    return DefaultBottomSheet(
      title: '계획 삭제',
      height: 380,
      contents: ContentsBox(
        height: 200,
        contentsWidget: ListView.builder(
            itemCount: widget.planInfoList.length,
            itemBuilder: (context, index) {
              final item = widget.planInfoList[index];
              int count = 0;

              for (var i = 0; i < widget.recordBoxList.length; i++) {
                final recordInfo = widget.recordBoxList[i];

                if (recordInfo.actions != null) {
                  if (recordInfo.actions!.contains(item.id)) {
                    count += 1;
                  }
                }
              }

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
                                icon: removeIds.contains(item.id)
                                    ? Icons.check_box
                                    : Icons.check_box_outline_blank,
                                color: buttonBackgroundColor,
                                onTap: (_) => onTap(item.id),
                              ),
                              SpaceWidth(width: regularSapce),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  BodySmallText(text: item.title),
                                  SpaceHeight(height: tinySpace),
                                  Text(item.name),
                                ],
                              )
                            ],
                          ),
                        ),
                        TextIcon(
                          backgroundColor: dialogBackgroundColor,
                          text: '실천 $count회',
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
            }),
      ),
      isEnabled: removeIds.isNotEmpty,
      submitText: '삭제 ${removeIds.length}',
      onSubmit: onSubmit,
    );
    ;
  }
}



// List<RemovePlanClass> removePlanList = [
      //   RemovePlanClass(
      //       id: 'remove-1',
      //       planName: '간헐적 단식 16:8',
      //       groupName: '식이요법',
      //       startDateTime: DateTime.now(),
      //       endDateTime: DateTime.now(),
      //       isChecked: false),
      //   RemovePlanClass(
      //       id: 'remove-2',
      //       planName: '간헐적 단식 16:8',
      //       groupName: '식이요법',
      //       startDateTime: DateTime.now(),
      //       endDateTime: DateTime.now(),
      //       isChecked: false),
      //   RemovePlanClass(
      //       id: 'remove-3',
      //       planName: '간헐적 단식 16:8',
      //       groupName: '식이요법',
      //       startDateTime: DateTime.now(),
      //       endDateTime: DateTime.now(),
      //       isChecked: false),
      //   RemovePlanClass(
      //       id: 'remove-4',
      //       planName: '간헐적 단식 16:8',
      //       groupName: '식이요법',
      //       startDateTime: DateTime.now(),
      //       endDateTime: DateTime.now(),
      //       isChecked: false),
      //   RemovePlanClass(
      //       id: 'remove-5',
      //       planName: '간헐적 단식 16:8',
      //       groupName: '식이요법',
      //       startDateTime: DateTime.now(),
      //       endDateTime: DateTime.now(),
      //       isChecked: false),
      //   RemovePlanClass(
      //       id: 'remove-6',
      //       planName: '간헐적 단식 16:8',
      //       groupName: '식이요법',
      //       startDateTime: DateTime.now(),
      //       endDateTime: DateTime.now(),
      //       isChecked: false),
      //   RemovePlanClass(
      //       id: 'remove-7',
      //       planName: '간헐적 단식 16:8',
      //       groupName: '식이요법',
      //       startDateTime: DateTime.now(),
      //       endDateTime: DateTime.now(),
      //       isChecked: false),
      // ];