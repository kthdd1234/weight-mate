import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';

class TextInput extends StatefulWidget {
  TextInput({
    super.key,
    this.maxLength,
    required this.suffixText,
    required this.hintText,
    this.prefixIcon,
    this.counterText,
    required this.onChanged,
    required this.errorText,
    this.autofocus,
    this.controller,
    this.keyboardType,
    this.helperText,
  });

  int? maxLength;
  IconData? prefixIcon;
  String suffixText;
  String hintText;
  String? counterText;
  String? errorText;
  String? helperText;
  Function(String value) onChanged;
  bool? autofocus;
  TextEditingController? controller;
  TextInputType? keyboardType;

  @override
  State<TextInput> createState() => _TextInputState();
}

class _TextInputState extends State<TextInput> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      style: Theme.of(context).textTheme.bodyLarge,
      autofocus: widget.autofocus != null,
      keyboardType: widget.keyboardType ?? inputKeyboardType,
      textInputAction: TextInputAction.next,
      maxLength: widget.maxLength,
      decoration: InputDecoration(
        prefixIcon: widget.prefixIcon != null ? Icon(widget.prefixIcon) : null,
        suffixText: widget.suffixText,
        errorText: widget.errorText,
        counterText: widget.counterText,
        hintText: widget.hintText,
        helperText: widget.helperText,
        contentPadding: inputContentPadding,
      ),
      onChanged: widget.onChanged,
    );
  }
}
