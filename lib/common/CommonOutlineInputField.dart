import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/variable.dart';
import 'package:provider/provider.dart';

class CommonOutlineInputField extends StatelessWidget {
  CommonOutlineInputField({
    super.key,
    required this.hintText,
    required this.controller,
    required this.onEditingComplete,
    required this.onSuffixIcon,
    required this.selectedColor,
    this.autofocus,
    this.outerPadding,
    this.onChanged,
  });

  String hintText;
  TextEditingController controller;
  bool? autofocus;
  EdgeInsets? outerPadding;
  Color selectedColor;
  Function() onEditingComplete, onSuffixIcon;
  Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: outerPadding ?? const EdgeInsets.all(0.0),
      child: TextFormField(
        style: const TextStyle(color: textColor, fontWeight: FontWeight.normal),
        controller: controller,
        autofocus: autofocus ?? true,
        cursorColor: selectedColor,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(left: 25),
          hintText: hintText,
          hintStyle: TextStyle(color: grey.s400),
          filled: true,
          fillColor: whiteBgBtnColor,
          suffixIcon: GestureDetector(
            onTap: onSuffixIcon,
            child: UnconstrainedBox(
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: controller.text == '' ? grey.s300 : selectedColor,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: const Icon(
                  Icons.arrow_upward_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
          border: OutlineInputBorder(
            borderSide: const BorderSide(width: 0, style: BorderStyle.none),
            borderRadius: BorderRadius.circular(100),
          ),
        ),
        onEditingComplete: onEditingComplete,
        onChanged: onChanged,
      ),
    );
  }
}
