import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/pages/home/body/search/widget/SearchItemEmpty.dart';

class SearchItemList extends StatefulWidget {
  SearchItemList({super.key, required this.controller});

  TextEditingController controller;

  @override
  State<SearchItemList> createState() => _SearchItemListState();
}

class _SearchItemListState extends State<SearchItemList> {
  @override
  Widget build(BuildContext context) {
    String keyword = widget.controller.text;

    return keyword != ''
        ? Column(
            children: [],
          )
        : SearchItemEmpty();
  }
}
