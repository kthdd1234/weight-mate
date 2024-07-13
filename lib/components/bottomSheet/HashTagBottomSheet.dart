import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/common/CommonBottomSheet.dart';
import 'package:flutter_app_weight_management/components/bottomSheet/HashTagTextBottomSheet.dart';
import 'package:flutter_app_weight_management/components/button/expanded_button_hori.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/utils/class.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:flutter_app_weight_management/utils/variable.dart';

class HashTagBottomSheet extends StatefulWidget {
  const HashTagBottomSheet({super.key});

  @override
  State<HashTagBottomSheet> createState() => _HashTagBottomSheetState();
}

class _HashTagBottomSheetState extends State<HashTagBottomSheet> {
  List<String> hashTagList = [];
  bool isEditMode = false;

  onHashTag(String id) {
    setState(() {
      hashTagList.contains(id) ? hashTagList.remove(id) : hashTagList.add(id);
    });
  }

  onAdd() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) => HashTagTextBottomSheet(),
    );
  }

  onEdit(bool newValue) {
    log('===> $newValue');
    setState(() => isEditMode = newValue);
  }

  onCompleted() {
    //
  }

  btn({
    required String text,
    required int flex,
    required Function() onTap,
    Color? color,
    String? imgUrl,
  }) {
    return ExpandedButtonHori(
      text: text,
      padding: text == '완료'
          ? const EdgeInsets.all(15)
          : const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      flex: flex,
      fontSize: 15,
      imgUrl: imgUrl,
      color: color,
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    String path = 'assets/images/';
    log('$isEditMode');
    List<Widget> children = isEditMode
        ? [
            btn(
              text: '편집 해제',
              flex: 1,
              imgUrl: '$path/t-23.png',
              onTap: () => onEdit(false),
            )
          ]
        : [
            btn(
              text: '추가',
              flex: 0,
              imgUrl: '$path/t-22.png',
              onTap: onAdd,
            ),
            SpaceWidth(width: 5),
            btn(
              text: '편집',
              flex: 0,
              imgUrl: '$path/t-23.png',
              onTap: () => onEdit(true),
            ),
            SpaceWidth(width: 5),
            btn(
              text: '완료',
              flex: 1,
              color: themeColor,
              onTap: onCompleted,
            ),
          ];

    return CommonBottomSheet(
      title: '#해시태그',
      height: 500,
      contents: Expanded(
        child: ContentsBox(
          contentsWidget: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Wrap(
                  children: initHashTagList
                      .map((hashTag) => HashTag(
                            id: hashTag.id,
                            text: hashTag.text,
                            colorName: hashTag.colorName,
                            isFilled: hashTagList.contains(hashTag.id),
                            onTap: onHashTag,
                          ))
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ),
      subContents: Row(children: children),
    );
  }
}

class HashTag extends StatelessWidget {
  HashTag({
    super.key,
    required this.id,
    required this.text,
    required this.colorName,
    required this.isFilled,
    required this.onTap,
  });

  String id, text, colorName;
  bool isFilled;
  Function(String id) onTap;

  @override
  Widget build(BuildContext context) {
    ColorClass color = getColorClass(colorName);

    return Padding(
      padding: const EdgeInsets.only(right: 5, bottom: 10),
      child: InkWell(
        onTap: () => onTap(id),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          decoration: BoxDecoration(
            color: isFilled ? color.s50 : null,
            border: Border.all(
              width: 0.5,
              color: isFilled ? color.s50 : grey.s300,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          child: Text(text,
              style: TextStyle(
                color: isFilled ? color.original : grey.original,
              )),
        ),
      ),
    );
  }
}
