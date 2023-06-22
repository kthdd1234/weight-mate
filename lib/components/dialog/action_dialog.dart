import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/icon/circular_icon.dart';
import 'package:flutter_app_weight_management/components/text/contents_title_text.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:flutter_app_weight_management/widgets/alert_dialog_title_widget.dart';

class ActionDialog extends StatelessWidget {
  ActionDialog({
    super.key,
    required this.title,
  });

  String title;

  @override
  Widget build(BuildContext context) {
    itemBuilder(buildContext, index) {
      return Row(children: [
        Text(index),
      ]);
    }

    return AlertDialog(
      shape: containerBorderRadious,
      backgroundColor: dialogBackgroundColor,
      elevation: 0.0,
      title: AlertDialogTitleWidget(
          text: title, onTap: () => closeDialog(context)),
      content: ContentsBox(
        height: 300,
        contentsWidget: SizedBox(
          width: 300,
          height: 300,
          child: Column(
            children: [
              ContentsTitleText(text: '식이요법'),
              ListView.builder(
                  itemCount: 10, shrinkWrap: true, itemBuilder: itemBuilder),
            ],
          ),
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