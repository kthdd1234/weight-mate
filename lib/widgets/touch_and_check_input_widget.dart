import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/area/empty_text_area.dart';
import 'package:flutter_app_weight_management/components/button/ok_and_cancel_button.dart';
import 'package:flutter_app_weight_management/components/divider/width_divider.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';

class TouchAndCheckInputWidget extends StatefulWidget {
  TouchAndCheckInputWidget({
    super.key,
    required this.type,
    required this.title,
    required this.checkBoxEnabledIcon,
    required this.checkBoxDisEnabledIcon,
    required this.showEmptyTouchArea,
    required this.onTapEmptyArea,
    required this.mainColor,
    required this.onEditingComplete,
  });

  PlanTypeEnum type;
  String title;
  IconData checkBoxEnabledIcon;
  IconData checkBoxDisEnabledIcon;
  bool showEmptyTouchArea;
  Function(PlanTypeEnum type) onTapEmptyArea;
  bool? isDisEnabledIconColor;
  Color mainColor;
  Function({
    required String text,
    required bool isAction,
    required String title,
    required PlanTypeEnum type,
  }) onEditingComplete;

  @override
  State<TouchAndCheckInputWidget> createState() =>
      _TouchAndCheckInputWidgetState();
}

class _TouchAndCheckInputWidgetState extends State<TouchAndCheckInputWidget> {
  final TextEditingController _textController = TextEditingController();
  bool isAction = false;

  @override
  Widget build(BuildContext context) {
    onTap() {
      widget.onEditingComplete(
        text: _textController.text,
        isAction: isAction,
        title: widget.title,
        type: widget.type,
      );

      _textController.text = '';
      isAction = false;
    }

    return widget.showEmptyTouchArea
        ? EmptyTextArea(
            text: '${widget.title} 계획 추가하기',
            icon: Icons.add,
            topHeight: smallSpace,
            downHeight: smallSpace,
            onTap: () => widget.onTapEmptyArea(widget.type),
          )
        : Column(
            children: [
              WidthDivider(width: double.infinity),
              TextFormField(
                controller: _textController,
                autofocus: true,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
                maxLength: 30,
                decoration: InputDecoration(
                  contentPadding: inputContentPadding,
                  icon: Padding(
                    padding: const EdgeInsets.only(top: smallSpace + tinySpace),
                    child: InkWell(
                      onTap: () => setState(() => isAction = !isAction),
                      child: Icon(
                        isAction
                            ? widget.checkBoxEnabledIcon
                            : widget.checkBoxDisEnabledIcon,
                        color: isAction ? widget.mainColor : Colors.grey,
                      ),
                    ),
                  ),
                ),
                onTapOutside: (_) => onTap(),
                onEditingComplete: onTap,
              ),
            ],
          );
  }
}
