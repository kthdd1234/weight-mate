import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/text/bottom_text.dart';
import 'package:flutter_app_weight_management/provider/diet_Info_provider.dart';
import 'package:flutter_app_weight_management/utils/class.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:flutter_app_weight_management/utils/variable.dart';
import 'package:flutter_app_weight_management/widgets/act_type_widget.dart';
import 'package:flutter_app_weight_management/components/simple_stepper/simple_stepper.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/text/headline_text.dart';
import 'package:flutter_app_weight_management/pages/add/add_container.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:provider/provider.dart';

class AddActType extends StatefulWidget {
  AddActType({
    super.key,
    required this.actInfo,
  });

  ActInfoClass actInfo;

  @override
  State<AddActType> createState() => _AddActTypeState();
}

class _AddActTypeState extends State<AddActType> {
  MainActTypes mainActType = MainActTypes.diet;

  @override
  Widget build(BuildContext context) {
    final screenPoint =
        ModalRoute.of(context)!.settings.arguments as screenPointEnum;

    buttonEnabled() {
      return mainActType != MainActTypes.none;
    }

    onPressedBottomNavigationButton() {
      if (buttonEnabled()) {
        Map<MainActTypes, String> mainActTitles = {
          MainActTypes.none: '',
          MainActTypes.diet: '식이요법',
          MainActTypes.exercise: '운동',
          MainActTypes.lifestyle: '생활습관'
        };

        widget.actInfo.mainActType = mainActType;
        widget.actInfo.mainActTitle = mainActTitles[mainActType]!;

        context.read<DietInfoProvider>().changeActInfo(widget.actInfo);
        Navigator.pushNamed(
          context,
          '/add-act-names',
          arguments: screenPoint,
        );
      }

      return null;
    }

    onTap(dynamic type) {
      setState(() => mainActType = type);
    }

    List<ActTypeWidget> itemTypeWidgets = mainAcyTypeClassList
        .map((item) => ActTypeWidget(
              id: item.id,
              title: item.title,
              desc: item.desc,
              icon: item.icon,
              isEnabled: mainActType == item.id,
              onTap: onTap,
            ))
        .toList();

    return AddContainer(
      body: Column(
        children: [
          SimpleStepper(
            step: setStep(screenPoint: screenPoint, step: 2),
            range: setRange(screenPoint: screenPoint),
          ),
          SpaceHeight(height: regularSapce),
          HeadlineText(text: '어떤 방법으로 시작할까요?'),
          SpaceHeight(height: regularSapce),
          Column(children: itemTypeWidgets),
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
