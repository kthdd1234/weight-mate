import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/simple_stepper/simple_stepper.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/text/headline_text.dart';
import 'package:flutter_app_weight_management/pages/add/add_container.dart';
import 'package:flutter_app_weight_management/provider/diet_Info_provider.dart';
import 'package:flutter_app_weight_management/utils/class.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:flutter_app_weight_management/utils/variable.dart';
import 'package:flutter_app_weight_management/widgets/act_item_widget.dart';
import 'package:provider/provider.dart';

class AddActNames extends StatefulWidget {
  AddActNames({
    super.key,
    required this.actInfo,
  });

  ActInfoClass actInfo;

  @override
  State<AddActNames> createState() => _AddActNamesState();
}

class _AddActNamesState extends State<AddActNames> {
  ScrollController scrollController = ScrollController();
  late dynamic selectedSubType;
  String selectedSubTitle = '';

  @override
  void initState() {
    final mainActType = widget.actInfo.mainActType;

    selectedSubType = subActTypeClassList[mainActType]![0].id;
    selectedSubTitle = subActTypeClassList[mainActType]![0].title;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mainActType = widget.actInfo.mainActType;
    final itemClassList = subActTypeClassList[mainActType]!;
    final screenPoint =
        ModalRoute.of(context)!.settings.arguments as screenPointEnum;

    onTapActItem(dynamic id) {
      final itemType = itemClassList.firstWhere((element) => element.id == id);

      setState(() {
        selectedSubType = id;

        id == 'custom'
            ? selectedSubTitle = ''
            : selectedSubTitle = itemType.title;
      });
    }

    buttonEnabled() {
      return selectedSubType != '';
    }

    onPressedBottomNavigationButton() {
      if (buttonEnabled()) {
        widget.actInfo.subActType = selectedSubType;
        widget.actInfo.subActTitle = selectedSubTitle;

        context.read<DietInfoProvider>().changeActInfo(widget.actInfo);
        return Navigator.pushNamed(
          context,
          '/add-act-setting',
          arguments: screenPoint,
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
          mainAxisExtent: 150,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
        ),
        itemBuilder: (context, index) {
          final item = itemClassList[index];

          return ActItemWidget(
            id: item.id,
            title: item.title,
            desc1: item.desc1,
            desc2: item.desc2,
            icon: item.icon,
            isEnabled: selectedSubType == item.id,
            onTap: onTapActItem,
          );
        },
      );
    }

    return AddContainer(
      body: Column(
        children: [
          SimpleStepper(
            step: setStep(screenPoint: screenPoint, step: 3),
            range: setRange(screenPoint: screenPoint),
          ),
          SpaceHeight(height: regularSapce),
          HeadlineText(
            text: '어떤 ${widget.actInfo.mainActTitle}으로 진행하나요?',
          ),
          SpaceHeight(height: regularSapce),
          setGridView()
        ],
      ),
      buttonEnabled: buttonEnabled(),
      bottomSubmitButtonText: '다음',
      onPressedBottomNavigationButton: onPressedBottomNavigationButton,
    );
  }
}
