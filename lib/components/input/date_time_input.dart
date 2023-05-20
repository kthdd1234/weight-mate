import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';

class DateTimeInput extends StatelessWidget {
  DateTimeInput({
    super.key,
    required this.hintText,
    required this.prefixIcon,
    required this.onTap,
    required this.text,
  });

  String text;
  String hintText;
  IconData prefixIcon;
  Function() onTap;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: Theme.of(context).textTheme.bodyLarge,
      controller: TextEditingController(text: text),
      keyboardType: TextInputType.datetime,
      readOnly: true,
      decoration: InputDecoration(
        prefixIcon: Icon(prefixIcon),
        contentPadding: inputContentPadding,
        hintText: text == '' ? hintText : null,
      ),
      onTap: onTap,
    );
  }
}
