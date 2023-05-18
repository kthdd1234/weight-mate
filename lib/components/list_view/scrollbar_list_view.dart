import 'package:flutter/material.dart';

class ScrollbarListView extends StatelessWidget {
  ScrollbarListView(
      {super.key, required this.controller, required this.dataList});

  ScrollController controller;
  List<Widget> dataList;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Scrollbar(
        controller: controller,
        thumbVisibility: true,
        child: ListView(
          controller: controller,
          children: [...dataList],
        ),
      ),
    );
  }
}
