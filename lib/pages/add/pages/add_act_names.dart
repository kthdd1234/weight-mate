import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/simple_stepper/simple_stepper.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/text/contents_title_text.dart';
import 'package:flutter_app_weight_management/components/text/headline_text.dart';
import 'package:flutter_app_weight_management/pages/add/add_container.dart';
import 'package:flutter_app_weight_management/provider/diet_Info_provider.dart';
import 'package:flutter_app_weight_management/utils/class.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/variable.dart';
import 'package:flutter_app_weight_management/widgets/act_type_widget.dart';
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
    final classList = subActTypeClassList[mainActType]!;

    onTapActType(dynamic id) {
      final itemType = classList.firstWhere((element) => element.id == id);

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
        return Navigator.pushNamed(context, '/add-act-setting');
      }

      return null;
    }

    List<ActTypeWidget> itemTypeListView = classList
        .map((item) => ActTypeWidget(
              id: item.id,
              title: item.title,
              desc: item.desc,
              icon: item.icon,
              isEnabled: selectedSubType == item.id,
              onTap: onTapActType,
            ))
        .toList();

    return AddContainer(
      body: Column(
        children: [
          SimpleStepper(currentStep: 3),
          SpaceHeight(height: regularSapce),
          HeadlineText(
            text: '${widget.actInfo.mainActTitle} 종류를 선택해주세요.',
          ),
          SpaceHeight(height: regularSapce),
          ContentsBox(
            contentsWidget: Column(
              children: [
                ContentsTitleText(
                  text: '${widget.actInfo.mainActTitle} 종류',
                  icon: Icons.task_alt,
                ),
                SpaceHeight(height: regularSapce),
                Column(children: itemTypeListView)
              ],
            ),
          ),
        ],
      ),
      buttonEnabled: buttonEnabled(),
      bottomSubmitButtonText: '다음',
      onPressedBottomNavigationButton: onPressedBottomNavigationButton,
    );
  }
}
