import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/area/empty_text_area.dart';
import 'package:flutter_app_weight_management/components/button/ok_and_cancel_button.dart';
import 'package:flutter_app_weight_management/components/dialog/icon_list_dialog.dart';
import 'package:flutter_app_weight_management/components/divider/width_divider.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/material_icons.dart';

class TouchAndCheckInputWidget extends StatefulWidget {
  TouchAndCheckInputWidget({
    super.key,
    required this.checkBoxEnabledIcon,
    required this.checkBoxDisEnabledIcon,
    required this.showEmptyTouchArea,
    required this.onTapEmptyArea,
    required this.onPressedOk,
    required this.onPressedCancel,
  });

  IconData checkBoxEnabledIcon;
  IconData checkBoxDisEnabledIcon;
  bool showEmptyTouchArea;
  Function() onTapEmptyArea;
  Function({String text, IconData iconData}) onPressedOk;
  Function() onPressedCancel;
  bool? isDisEnabledIconColor;

  @override
  State<TouchAndCheckInputWidget> createState() =>
      _TouchAndCheckInputWidgetState();
}

class _TouchAndCheckInputWidgetState extends State<TouchAndCheckInputWidget> {
  final TextEditingController _textController = TextEditingController();
  bool isEnabledOnPressedOk = false;
  IconData selectedIcon = Icons.add_circle_outline_outlined;

  @override
  Widget build(BuildContext context) {
    setIcon(IconData iconData) {
      setState(() => selectedIcon = iconData);
    }

    onTapIcon() async {
      showDialog(
        context: context,
        builder: (context) => IconListDialog(setIcon: setIcon),
      );
    }

    setEditingComplete() {
      FocusScope.of(context).unfocus();
    }

    setPressedOk() {
      widget.onPressedOk(
        text: _textController.text,
        iconData: selectedIcon,
      );
      _textController.text = '';
      isEnabledOnPressedOk = false;
      selectedIcon = Icons.add_circle_outline_outlined;
    }

    onChanged(String value) {
      setState(() {
        isEnabledOnPressedOk = _textController.text != '';
      });
    }

    return widget.showEmptyTouchArea
        ? EmptyTextArea(
            text: '다이어트 계획을 추가해보세요.',
            icon: Icons.add,
            topHeight: smallSpace,
            downHeight: smallSpace,
            onTap: widget.onTapEmptyArea,
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
                      onTap: onTapIcon,
                      child: Icon(selectedIcon),
                    ),
                  ),
                ),
                onChanged: onChanged,
                onEditingComplete: setEditingComplete,
              ),
              SpaceHeight(height: smallSpace),
              OkAndCancelButton(
                okText: '추가',
                cancelText: '취소',
                onPressedOk: isEnabledOnPressedOk ? setPressedOk : null,
                onPressedCancel: widget.onPressedCancel,
              )
            ],
          );
  }
}

// isEnabled
//                           ? Icon(widget.checkBoxEnabledIcon)
//                           : Icon(
//                               widget.checkBoxDisEnabledIcon,
//                               color: widget.isDisEnabledIconColor == true
//                                   ? disabledButtonBackgroundColor
//                                   : null,
//                             )
