import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/divider/width_divider.dart';
import 'package:flutter_app_weight_management/components/dot/color_dot.dart';
import 'package:flutter_app_weight_management/components/icon/circular_icon.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/components/text/contents_title_text.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:flutter_app_weight_management/widgets/alert_dialog_title_widget.dart';

class ActionDialog extends StatelessWidget {
  ActionDialog({
    super.key,
    required this.dayTitle,
    required this.contentsTitle,
    required this.color,
    required this.names,
    required this.count,
  });

  String dayTitle, contentsTitle;
  int count;
  List<String> names;
  Color color;

  @override
  Widget build(BuildContext context) {
    itemBuilder(buildContext, index) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(Icons.task_alt, size: 15),
          SpaceWidth(width: tinySpace),
          Text(
            names[index],
            style: const TextStyle(
              fontSize: 14,
              decoration: TextDecoration.underline,
            ),
          ),
          SpaceWidth(width: smallSpace),
        ],
      );
    }

    return AlertDialog(
      shape: containerBorderRadious,
      backgroundColor: dialogBackgroundColor,
      elevation: 0.0,
      title: AlertDialogTitleWidget(
          text: dayTitle, onTap: () => closeDialog(context)),
      content: ContentsBox(
        width: double.maxFinite,
        height: 300,
        contentsWidget: Column(
          children: [
            ContentsTitleText(
              text: contentsTitle,
              sub: [Dot(size: 10, color: color)],
            ),
            SpaceHeight(height: smallSpace),
            WidthDivider(width: double.maxFinite, height: 1),
            SpaceHeight(height: tinySpace),
            SizedBox(
              height: 170,
              child: Scrollbar(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemExtent: 40,
                  itemCount: names.length,
                  itemBuilder: itemBuilder,
                ),
              ),
            ),
            WidthDivider(width: double.maxFinite, height: 1),
            SpaceHeight(height: regularSapce),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Text('실천 횟수: $count회')],
              ),
            )
          ],
        ),
      ),
    );
  }
}

   // sub: [
              //   CircularIcon(
              //     adjustSize: 10,
              //     icon: Icons.fitness_center,
              //     size: 25,
              //     borderRadius: 5,
              //     backgroundColor: typeBackgroundColor,
              //   )
              // ],