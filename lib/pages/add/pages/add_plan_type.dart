import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/text/bottom_text.dart';
import 'package:flutter_app_weight_management/provider/diet_Info_provider.dart';
import 'package:flutter_app_weight_management/utils/class.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';
import 'package:flutter_app_weight_management/utils/variable.dart';
import 'package:flutter_app_weight_management/widgets/plan_type_widget.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/pages/add/add_container.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/widgets/add_title_widget.dart';
import 'package:provider/provider.dart';

class AddPlanType extends StatefulWidget {
  AddPlanType({
    super.key,
    required this.planInfo,
  });

  PlanInfoClass planInfo;

  @override
  State<AddPlanType> createState() => _AddPlanTypeState();
}

class _AddPlanTypeState extends State<AddPlanType> {
  PlanTypeEnum planType = PlanTypeEnum.diet;

  @override
  Widget build(BuildContext context) {
    final argmentsType =
        ModalRoute.of(context)!.settings.arguments as argmentsTypeEnum;

    buttonEnabled() {
      return planType != PlanTypeEnum.none;
    }

    onPressedBottomNavigationButton() {
      if (buttonEnabled()) {
        Map<PlanTypeEnum, String> planTitle = {
          PlanTypeEnum.none: '',
          PlanTypeEnum.diet: '식이요법',
          PlanTypeEnum.exercise: '운동',
          PlanTypeEnum.lifestyle: '생활습관'
        };

        widget.planInfo.type = planType;
        widget.planInfo.title = planTitle[planType]!;

        context.read<DietInfoProvider>().changePlanInfo(widget.planInfo);
        Navigator.pushNamed(
          context,
          '/add-plan-item',
          arguments: argmentsType,
        );
      }

      return null;
    }

    onTap(dynamic type) {
      setState(() => planType = type);
    }

    List<PlanTypeWidget> planTypeWidgets = planTypeClassList
        .map((item) => PlanTypeWidget(
              id: item.id,
              title: item.title,
              desc: item.desc,
              icon: item.icon,
              isEnabled: planType == item.id,
              onTap: onTap,
            ))
        .toList();

    return AddContainer(
      body: Column(
        children: [
          AddTitleWidget(
            argmentsType: argmentsType,
            step: 2,
            title: '어떤 방법으로 시작할까요?',
          ),
          Column(children: planTypeWidgets),
          SpaceHeight(height: smallSpace),
          BottomText(bottomText: '식이요법, 운동, 생활 습관은 목표 체중에 달성하기 위한 방법입니다.')
        ],
      ),
      buttonEnabled: buttonEnabled(),
      bottomSubmitButtonText: '다음',
      onPressedBottomNavigationButton: onPressedBottomNavigationButton,
    );
  }
}
