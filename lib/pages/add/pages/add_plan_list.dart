import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/common/CommonCheckBox.dart';
import 'package:flutter_app_weight_management/common/CommonIcon.dart';
import 'package:flutter_app_weight_management/common/CommonText.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/pages/add/add_container.dart';
import 'package:flutter_app_weight_management/pages/add/pages/add_body_info.dart';
import 'package:flutter_app_weight_management/provider/diet_Info_provider.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/variable.dart';
import 'package:provider/provider.dart';

class AddPlanList extends StatefulWidget {
  const AddPlanList({super.key});

  @override
  State<AddPlanList> createState() => _AddPlanListState();
}

class _AddPlanListState extends State<AddPlanList> {
  List<String> checkList = [initPlanItemList[0].name];

  @override
  Widget build(BuildContext context) {
    onCheckBox({required dynamic id}) {
      setState(
        () {
          checkList.contains(id) == false
              ? checkList.add(id)
              : checkList.remove(id);
        },
      );
    }

    onCompleted() {
      if (checkList.isNotEmpty) {
        context.read<DietInfoProvider>().changePlanItemList(checkList);
        Navigator.pushNamed(context, '/add-alarm-permission');
      }
    }

    return AddContainer(
      body: Column(
        children: [
          AddTitle(step: 2, title: '꾸준히 달성 할 목표를 모두 골라봐요 :)'),
          ContentsBox(
            height: 430,
            contentsWidget: ListView(
              shrinkWrap: true,
              children: initPlanItemList
                  .map(
                    (e) => GestureDetector(
                      onTap: () => onCheckBox(id: e.name),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              CommonIcon(
                                icon: checkList.contains(e.name)
                                    ? Icons.check_box_rounded
                                    : Icons.check_box_outline_blank_rounded,
                                size: 23,
                                color: checkList.contains(e.name)
                                    ? themeColor
                                    : Colors.grey.shade400,
                              ),
                              SpaceWidth(width: 10),
                              CommonText(
                                text: e.name,
                                size: 15,
                                isNotTop: true,
                              ),
                            ],
                          ),
                          SpaceHeight(height: 20)
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
      buttonEnabled: checkList.isNotEmpty,
      bottomSubmitButtonText: '완료',
      onPressedBottomNavigationButton: onCompleted,
    );
  }
}