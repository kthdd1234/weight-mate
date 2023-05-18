import 'package:flutter/material.dart';

class MultiLineTextInput extends StatelessWidget {
  MultiLineTextInput(
      {super.key,
      required this.hintText,
      required this.controller,
      required this.maxLength,
      required this.onChanged});

  String hintText;
  TextEditingController controller;
  int maxLength;
  Function(String value) onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      style: Theme.of(context).textTheme.bodyLarge,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.done,
      autofocus: true,
      maxLength: maxLength,
      maxLines: null,
      minLines: null,
      decoration: InputDecoration(
        hintText: hintText,
        border: const UnderlineInputBorder(),
      ),
      onChanged: onChanged,
      onEditingComplete: () => FocusScope.of(context).unfocus(),
    );
  }
}
