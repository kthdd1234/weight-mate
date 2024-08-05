import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/common/CommonIcon.dart';
import 'package:flutter_app_weight_management/widgets/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/widgets/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/pages/onboarding/add_container.dart';
import 'package:flutter_app_weight_management/pages/onboarding/pages/add_start_screen.dart';
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
          PageTitle(step: 3, title: '꾸준히 달성 할 목표를 모두 골라보세요 :)'),
          ContentsBox(
            height: 430,
            child: ListView(
              shrinkWrap: true,
              children: initPlanItemList
                  .map(
                    (e) => GestureDetector(
                      onTap: () => onCheckBox(id: e.name),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 0,
                              child: CommonIcon(
                                icon: checkList.contains(e.name)
                                    ? Icons.check_box_rounded
                                    : Icons.check_box_outline_blank_rounded,
                                size: 23,
                                color: checkList.contains(e.name)
                                    ? textColor
                                    : Colors.grey.shade400,
                              ),
                            ),
                            SpaceWidth(width: 10),
                            Expanded(
                              child: Text(
                                e.name.tr(),
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: textColor,
                                ),
                              ),
                            )
                          ],
                        ),
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
