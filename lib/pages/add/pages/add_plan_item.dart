import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/pages/add/add_container.dart';
import 'package:flutter_app_weight_management/provider/diet_Info_provider.dart';
import 'package:flutter_app_weight_management/utils/class.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';
import 'package:flutter_app_weight_management/utils/variable.dart';
import 'package:flutter_app_weight_management/widgets/plan_item_widget.dart';
import 'package:flutter_app_weight_management/widgets/add_title_widget.dart';
import 'package:provider/provider.dart';

class AddPlanItem extends StatefulWidget {
  AddPlanItem({
    super.key,
    required this.planInfo,
  });

  PlanInfoClass planInfo;

  @override
  State<AddPlanItem> createState() => _AddPlanItemState();
}

class _AddPlanItemState extends State<AddPlanItem> {
  ScrollController scrollController = ScrollController();
  late String selectedPlanId, selectedPlanName;

  @override
  void initState() {
    final planType = widget.planInfo.type;

    selectedPlanId = planTypeDetailInfo[planType]!.classList[0].id;
    selectedPlanName = planTypeDetailInfo[planType]!.classList[0].name;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final planType = widget.planInfo.type;
    final itemClassList = planTypeDetailInfo[planType]!.classList;
    final argmentsType =
        ModalRoute.of(context)!.settings.arguments as ArgmentsTypeEnum;

    onTap(dynamic id) {
      final itemType = itemClassList.firstWhere((element) => element.id == id);

      setState(() {
        selectedPlanId = id;
        selectedPlanName = id == 'custom' ? '' : itemType.name;
      });
    }

    buttonEnabled() {
      return selectedPlanId != '';
    }

    onPressedBottomNavigationButton() {
      if (buttonEnabled()) {
        final now = DateTime.now();

        widget.planInfo.id = selectedPlanId;
        widget.planInfo.name = selectedPlanName;
        widget.planInfo.alarmTime =
            DateTime(now.year, now.month, now.day, 10, 30);

        widget.planInfo.isAlarm = true;

        context.read<DietInfoProvider>().changePlanInfo(widget.planInfo);

        return Navigator.pushNamed(
          context,
          '/add-plan-setting',
          arguments: argmentsType,
        );
      }

      return null;
    }

    setGridView() {
      return GridView.builder(
        shrinkWrap: true,
        itemCount: itemClassList.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisExtent: 160,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
        ),
        itemBuilder: (context, index) {
          final item = itemClassList[index];

          return PlanItemWidget(
            id: item.id,
            name: item.name,
            desc: item.desc,
            icon: item.icon,
            isEnabled: selectedPlanId == item.id,
            onTap: onTap,
          );
        },
      );
    }

    return AddContainer(
      body: Column(
        children: [
          AddTitleWidget(
            argmentsType: argmentsType,
            step: 3,
            title: '어떤 ${widget.planInfo.title}으로 진행하나요?',
          ),
          setGridView()
        ],
      ),
      buttonEnabled: buttonEnabled(),
      bottomSubmitButtonText: '다음',
      onPressedBottomNavigationButton: onPressedBottomNavigationButton,
    );
  }
}
