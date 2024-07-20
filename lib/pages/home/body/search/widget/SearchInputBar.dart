import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/variable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SearchInputBar extends StatelessWidget {
  SearchInputBar({
    super.key,
    required this.controller,
    required this.onSuffixIcon,
    required this.onEditingComplete,
  });

  TextEditingController controller;
  Function() onSuffixIcon, onEditingComplete;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
      child: SizedBox(
        height: 40,
        child: TextFormField(
          controller: controller,
          style: const TextStyle(
            color: textColor,
            fontSize: 13,
          ),
          cursorColor: Colors.indigo.shade200,
          cursorHeight: 14,
          decoration: InputDecoration(
            isDense: true,
            contentPadding: const EdgeInsets.only(top: 5),
            hintText: '키워드 검색',
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
            filled: true,
            fillColor: Colors.white,
            prefixIcon: UnconstrainedBox(
              child: Container(
                width: 25,
                height: 25,
                decoration: BoxDecoration(
                  color: controller.text == '' ? indigo.s100 : indigo.s300,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: const Icon(
                  Icons.search_rounded,
                  color: Colors.white,
                  size: 13,
                ),
              ),
            ),
            suffixIcon: GestureDetector(
              onTap: onSuffixIcon,
              child: Icon(
                controller.text != ''
                    ? Icons.close_rounded
                    : Icons.info_outline_rounded,
                color: controller.text == '' ? grey.s300 : grey.s400,
              ),
            ),
            border: OutlineInputBorder(
              borderSide: const BorderSide(width: 0, style: BorderStyle.none),
              borderRadius: BorderRadius.circular(100),
            ),
          ),
          onEditingComplete: onEditingComplete,
        ),
      ),
    );
  }
}
