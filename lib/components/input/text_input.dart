import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

class TextInput extends StatefulWidget {
  TextInput({
    super.key,
    required this.suffixText,
    required this.hintText,
    required this.onChanged,
    required this.errorText,
    this.maxLength,
    this.prefixIcon,
    this.counterText,
    this.autofocus,
    this.controller,
    this.keyboardType,
    this.helperText,
    this.inputBorderType,
    this.inputHeight,
    this.contentPadding,
    this.isMediumSize,
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
  InputBorder? inputBorderType;
  double? inputHeight;
  EdgeInsets? contentPadding;
  bool? isMediumSize;

  @override
  State<TextInput> createState() => _TextInputState();
}

class _TextInputState extends State<TextInput> {
  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return SizedBox(
      height: widget.inputHeight,
      child: TextFormField(
        controller: widget.controller,
        style: widget.isMediumSize == true
            ? textTheme.bodyMedium
            : textTheme.bodyLarge,
        autofocus: widget.autofocus != null,
        keyboardType: widget.keyboardType ?? inputKeyboardType,
        textInputAction: TextInputAction.next,
        maxLength: widget.maxLength,
        decoration: InputDecoration(
          focusedBorder: widget.inputBorderType ?? const UnderlineInputBorder(),
          border: widget.inputBorderType ?? const UnderlineInputBorder(),
          prefixIcon:
              widget.prefixIcon != null ? Icon(widget.prefixIcon) : null,
          suffixText: widget.suffixText,
          errorText: widget.errorText,
          counterText: widget.counterText,
          hintText: widget.hintText,
          helperText: widget.helperText,
          contentPadding: widget.contentPadding ?? inputContentPadding,
        ),
        onChanged: widget.onChanged,
        onTapOutside: ((event) => FocusScope.of(context).unfocus()),
      ),
    );
  }
}

      // showModalBottomSheet(
      //   barrierColor: Colors.transparent,
      //   context: context,
      //   builder: (context) {
      //     return PopScope(
      //       onPopInvoked: (didPop) {
      //         log('123213');
      //         FocusScope.of(context).unfocus();
      //       },
      //       child: Padding(
      //         padding: EdgeInsets.only(
      //           bottom: MediaQuery.of(context).viewInsets.bottom,
      //         ),
      //         child: AppFramework(
      //           widget: Container(
      //             child: Row(
      //               children: [
      //                 Text('취소'),
      //                 Text('완료'),
      //               ],
      //             ),
      //           ),
      //         ),
      //       ),
      //     );
      //   },
      // );