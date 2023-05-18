import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:flutter_app_weight_management/utils/material_icons.dart';
import 'package:flutter_app_weight_management/widgets/alert_dialog_title_widget.dart';

class IconListDialog extends StatelessWidget {
  IconListDialog({
    super.key,
    required this.setIcon,
  });

  Function(IconData iconData) setIcon;

  @override
  Widget build(BuildContext context) {
    List<IconData> materialIconList = [];
    material_icons.forEach(((key, value) => materialIconList.add(value)));

    onTapIcon(IconData iconData) {
      setIcon(iconData);
      closeDialog(context);
    }

    onTapClose() {
      closeDialog(context);
    }

    setGridView() {
      return Scrollbar(
        child: GridView.builder(
          itemCount: materialIconList.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
          ),
          itemBuilder: (context, index) => InkWell(
            onTap: () => onTapIcon(materialIconList[index]),
            child: Icon(
              materialIconList[index],
              color: buttonBackgroundColor,
            ),
          ),
        ),
      );
    }

    return AlertDialog(
      shape: containerBorderRadious,
      backgroundColor: dialogBackgroundColor,
      elevation: 0.0,
      title: AlertDialogTitleWidget(text: '아이콘', onTap: onTapClose),
      content: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 330,
        child: Card(
          shape: containerBorderRadious,
          borderOnForeground: false,
          elevation: 0.0,
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: setGridView(),
          ),
        ),
      ),
    );
  }
}
