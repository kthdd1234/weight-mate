import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';

class TextInput extends StatelessWidget {
  TextInput({
    super.key,
    required this.suffixText,
    required this.hintText,
    required this.onChanged,
    this.errorText,
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
    this.focusNode,
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
  FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return SizedBox(
      height: inputHeight,
      child: TextFormField(
        focusNode: focusNode,
        controller: controller,
        style:
            isMediumSize == true ? textTheme.bodyMedium : textTheme.bodyLarge,
        autofocus: autofocus != null,
        keyboardType: keyboardType ?? inputKeyboardType,
        textInputAction: TextInputAction.next,
        maxLength: maxLength,
        decoration: InputDecoration(
          focusedBorder: inputBorderType ?? const UnderlineInputBorder(),
          border: inputBorderType ?? const UnderlineInputBorder(),
          prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
          suffixText: suffixText,
          errorText: errorText,
          counterText: counterText,
          hintText: hintText,
          helperText: helperText,
          contentPadding: contentPadding ?? inputContentPadding,
        ),
        onChanged: onChanged,
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