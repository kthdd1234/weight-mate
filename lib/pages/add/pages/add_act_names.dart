import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/simple_stepper/simple_stepper.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/text/contents_title_text.dart';
import 'package:flutter_app_weight_management/components/text/headline_text.dart';
import 'package:flutter_app_weight_management/pages/add/add_container.dart';
import 'package:flutter_app_weight_management/provider/diet_Info_provider.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/variable.dart';
import 'package:flutter_app_weight_management/widgets/act_type_widget.dart';
import 'package:provider/provider.dart';

class AddActNames extends StatefulWidget {
  const AddActNames({super.key});

  @override
  State<AddActNames> createState() => _AddActNamesState();
}

class _AddActNamesState extends State<AddActNames> {
  ScrollController scrollController = ScrollController();
  dynamic selectedSubType;

  @override
  Widget build(BuildContext context) {
    final actType = context.watch<DietInfoProvider>().getActType();
    final subActType = context.watch<DietInfoProvider>().getSubActType();
    final itemTypeClassList = subItemTypeClassList[actType]!;
    final title = '${actTitles[actType]}${actSubs[actType]}';

    onTapItemType(dynamic type) {
      setState(() => selectedSubType = type);
    }

    buttonEnabled() {
      return selectedSubType != '';
    }

    onPressedBottomNavigationButton() {
      if (buttonEnabled()) {
        context.read<DietInfoProvider>().changeSubActType(selectedSubType);
        return Navigator.pushNamed(context, '/add-act-setting');
      }

      return null;
    }

    setIsEnabled(item) {
      if (subActType == item.id) {
        context.watch<DietInfoProvider>().changeSubActType('none');
        selectedSubType = subActType;

        return true;
      }

      return selectedSubType == item.id;
    }

    List<ActTypeWidget> itemTypeListView = itemTypeClassList
        .map((item) => ActTypeWidget(
              id: item.id,
              title: item.title,
              desc: item.desc,
              icon: item.icon,
              isEnabled: setIsEnabled(item),
              onTap: onTapItemType,
            ))
        .toList();

    return AddContainer(
      body: Column(
        children: [
          SimpleStepper(currentStep: 3),
          SpaceHeight(height: regularSapce),
          HeadlineText(
            text: '어떤 종류의 $title 하나요?',
          ),
          SpaceHeight(height: regularSapce),
          ContentsBox(
            contentsWidget: Column(
              children: [
                ContentsTitleText(
                  text: '${actTitles[actType]} 종류',
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

//  if (selectedType == 'custom') {
//           return showModalBottomSheet(
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(10.0),
//             ),
//             context: context,
//             builder: (context) => ActNameBottomSheet(),
//           );
//         }