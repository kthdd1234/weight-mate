import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/common/widget/CommonCheckBox.dart';
import 'package:flutter_app_weight_management/common/widget/CommonIcon.dart';
import 'package:flutter_app_weight_management/common/widget/CommonTag.dart';
import 'package:flutter_app_weight_management/common/widget/CommonText.dart';
import 'package:flutter_app_weight_management/components/area/empty_area.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/function.dart';

class TodoContainer extends StatefulWidget {
  TodoContainer({
    super.key,
    required this.containerId,
    required this.color,
    required this.title,
    required this.icon,
  });

  String containerId, color, title;
  IconData icon;

  @override
  State<TodoContainer> createState() => _TodoContainerState();
}

class _TodoContainerState extends State<TodoContainer> {
  bool isShowInput = false;

  @override
  Widget build(BuildContext context) {
    Color mainColor = tagColors[widget.color]!['textColor']!;

    onTapCheckBox({required dynamic id, required bool newValue}) {
      //
    }

    onTapMoreTodo({required dynamic id}) {
      //
    }

    onComplted({
      required dynamic id,
      required bool newValue,
      required String text,
    }) {
      //
    }

    return Column(
      children: [
        TodoTitle(
          id: widget.containerId,
          title: widget.title,
          icon: widget.icon,
          color: widget.color,
        ),
        TodoList(
          mainColor: mainColor,
          onTapCheckBox: onTapCheckBox,
          onTapMoreTodo: onTapMoreTodo,
        ),
        TodoInput(
          title: widget.title,
          mainColor: mainColor,
          onComplted: onComplted,
        ),
      ],
    );
  }
}

class TodoTitle extends StatelessWidget {
  TodoTitle({
    super.key,
    required this.id,
    required this.title,
    required this.icon,
    required this.color,
  });

  String id, title, color;
  IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CommonText(text: title, size: 15, isBold: true),
        CommonTag(color: color, text: '실천율: 0.0%'),
      ],
    );
  }
}

class TodoList extends StatelessWidget {
  TodoList({
    super.key,
    required this.mainColor,
    required this.onTapCheckBox,
    required this.onTapMoreTodo,
  });

  Color mainColor;
  Function({required dynamic id, required bool newValue}) onTapCheckBox;
  Function({required dynamic id}) onTapMoreTodo;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: smallSpace),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonCheckBox(
            id: 'test-id',
            isCheck: false,
            checkColor: mainColor,
            onTap: onTapCheckBox,
          ),
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CommonText(text: '테스트', size: 15, color: themeColor),
                SpaceHeight(height: 3),
                CommonText(
                  text: '오전 08:30',
                  size: 12,
                  leftIcon: Icons.alarm,
                ),
              ],
            ),
          ),
          CommonIcon(
            icon: Icons.more_horiz,
            size: 22,
            color: Colors.grey,
            onTap: () => onTapMoreTodo(id: 'test-id'),
          ),
        ],
      ),
    );
  }
}

class TodoInput extends StatefulWidget {
  TodoInput({
    super.key,
    required this.title,
    required this.mainColor,
    required this.onComplted,
  });

  String title;
  Color mainColor;
  Function({required dynamic id, required String text, required bool newValue})
      onComplted;

  @override
  State<TodoInput> createState() => _TodoInputState();
}

class _TodoInputState extends State<TodoInput> {
  TextEditingController textController = TextEditingController();
  bool isShowInput = false;
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    onTapTodoAdd() {
      setState(() => isShowInput = true);
    }

    onEditingComplete() {
      if (textController.text != '') {
        widget.onComplted(
          id: uuid(),
          text: textController.text,
          newValue: isChecked,
        );
      }

      setState(() {
        isShowInput = false;
        isChecked = false;
        textController.text = '';
      });
    }

    onTapCheckBox({required dynamic id, required bool newValue}) {
      if (!isShowInput) {
        setState(() => isShowInput = true);
      }

      if (id != 'disabled') {
        setState(() => isChecked = newValue);
      }
    }

    return InkWell(
      onTap: onTapTodoAdd,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CommonCheckBox(
            id: isShowInput ? 'planId' : 'disabled',
            isCheck: isChecked,
            checkColor: isChecked ? widget.mainColor : Colors.grey,
            isDisabled: !isShowInput,
            onTap: onTapCheckBox,
          ),
          !isShowInput
              ? Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: CommonText(
                    text: '${widget.title} 추가',
                    size: 15,
                    color: Colors.grey,
                  ),
                )
              : Expanded(
                  child: TextFormField(
                    maxLength: 30,
                    controller: textController,
                    autofocus: true,
                    textInputAction: TextInputAction.done,
                    style: Theme.of(context).textTheme.bodyLarge,
                    decoration: const InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.only(bottom: tinySpace),
                      counterText: '',
                    ),
                    onEditingComplete: onEditingComplete,
                  ),
                ),
        ],
      ),
    );
  }
}

class TodoAboveKeyboard extends StatelessWidget {
  const TodoAboveKeyboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        color: const Color(0xffCCCDD3),
        // padding: const EdgeInsets.all(tinySpace),
        child: Row(
          children: [Switch(value: false, onChanged: (_) {})],
        ),
      ),
    );
  }
}
