import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';

class SearchItemBar extends StatefulWidget {
  SearchItemBar({
    super.key,
    required this.controller,
    required this.onSuffixIcon,
    required this.onEditingComplete,
    required this.onChanged,
  });

  TextEditingController controller;
  Function() onSuffixIcon, onEditingComplete;
  Function(String)? onChanged;

  @override
  State<SearchItemBar> createState() => _SearchItemBarState();
}

class _SearchItemBarState extends State<SearchItemBar> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, left: 7, right: 7),
      child: SizedBox(
        height: 40,
        child: TextFormField(
          controller: widget.controller,
          style: const TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
          cursorColor: Colors.indigo.shade200,
          cursorHeight: 14,
          decoration: InputDecoration(
            isDense: true,
            contentPadding: const EdgeInsets.only(top: 5),
            hintText: '키워드 또는 #해시태그 검색',
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
            filled: true,
            fillColor: Colors.white,
            prefixIcon: UnconstrainedBox(
              child: Container(
                width: 25,
                height: 25,
                decoration: BoxDecoration(
                  color: Colors.indigo.shade100,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: const Icon(
                  Icons.search_rounded,
                  color: Colors.white,
                  size: 14,
                ),
              ),
            ),
            suffixIcon: GestureDetector(
              onTap: widget.onSuffixIcon,
              child: Icon(
                widget.controller.text != ''
                    ? Icons.close_rounded
                    : Icons.info_outline_rounded,
                color: Colors.grey.shade300,
              ),
            ),
            border: OutlineInputBorder(
              borderSide: const BorderSide(width: 0, style: BorderStyle.none),
              borderRadius: BorderRadius.circular(100),
            ),
          ),
          onChanged: widget.onChanged,
          onEditingComplete: widget.onEditingComplete,
        ),
      ),
    );
  }
}
