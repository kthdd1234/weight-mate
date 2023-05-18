import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';

class DateInput extends StatelessWidget {
  DateInput({
    super.key,
    required this.prefixIcon,
    required this.onTap,
    required this.text,
  });

  String text;
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
      ),
      onTap: onTap,
    );
  }
}
