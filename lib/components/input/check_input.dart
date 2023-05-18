import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';

class CheckInput extends StatefulWidget {
  CheckInput({
    super.key,
    required this.onEditingResult,
    required this.onTapEnbledIcon,
    required this.onTapDisEnbledIcon,
  });

  Function({String text, bool isChecked}) onEditingResult;
  IconData onTapEnbledIcon;
  IconData onTapDisEnbledIcon;

  @override
  State<CheckInput> createState() => _CheckInputState();
}

class _CheckInputState extends State<CheckInput> {
  var text = '';
  var isChecked = true;

  @override
  Widget build(BuildContext context) {
    onTap() {
      setState(() => isChecked = !isChecked);
    }

    onChanged(String value) {
      setState(() => text = value);
    }

    onEditingComplete() {
      widget.onEditingResult(text: text, isChecked: isChecked);
    }

    return TextFormField(
      autofocus: true,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.done,
      maxLength: 30,
      decoration: InputDecoration(
        contentPadding: inputContentPadding,
        icon: InkWell(
          onTap: onTap,
          child: isChecked
              ? Icon(widget.onTapEnbledIcon)
              : Icon(widget.onTapDisEnbledIcon),
        ),
      ),
      onChanged: onChanged,
      onEditingComplete: onEditingComplete,
    );
  }
}
