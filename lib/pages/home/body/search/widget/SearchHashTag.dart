import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/common/CommonName.dart';
import 'package:flutter_app_weight_management/components/bottomSheet/HashTagBottomSheet.dart';
import 'package:flutter_app_weight_management/components/bottomSheet/HashTagTextBottomSheet.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/main.dart';
import 'package:flutter_app_weight_management/model/user_box/user_box.dart';
import 'package:flutter_app_weight_management/pages/home/body/record/record_body.dart';
import 'package:flutter_app_weight_management/utils/class.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:multi_value_listenable_builder/multi_value_listenable_builder.dart';

class SearchHashTag extends StatelessWidget {
  SearchHashTag({super.key, required this.controller, required this.onHashTag});

  TextEditingController controller;
  Function(String) onHashTag;

  @override
  Widget build(BuildContext context) {
    return MultiValueListenableBuilder(
        valueListenables: valueListenables,
        builder: (context, values, child) {
          bool isEmptyText = controller.text == '';
          UserBox user = userRepository.user;
          List<HashTagClass> userHashTagClassList =
              getHashTagClassList(user.hashTagList ?? []);
          List<Widget> hashTagWidgetList = userHashTagClassList
              .map((hashTag) => HashTagKeyword(
                    isEmptyText: isEmptyText,
                    text: hashTag.text,
                    color: getColorClass(hashTag.colorName),
                    onHashTag: onHashTag,
                  ))
              .toList();

          onAddHashTag(_) {
            showModalBottomSheet(
              isScrollControlled: true,
              context: context,
              builder: (btx) => HashTagTextBottomSheet(),
            );
          }

          hashTagWidgetList.add(HashTagKeyword(
            isEmptyText: isEmptyText,
            text: '해시태그 만들기',
            isImage: true,
            onHashTag: onAddHashTag,
          ));

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 7),
            child: ContentsBox(
              padding: const EdgeInsets.all(15),
              width: double.infinity,
              contentsWidget: isEmptyText
                  ? Wrap(spacing: 7, runSpacing: 7, children: hashTagWidgetList)
                  : SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(children: hashTagWidgetList),
                    ),
            ),
          );
        });
  }
}

class HashTagKeyword extends StatelessWidget {
  HashTagKeyword({
    super.key,
    required this.text,
    required this.isEmptyText,
    required this.onHashTag,
    this.color,
    this.isImage,
  });

  String text;
  ColorClass? color;
  bool isEmptyText;
  bool? isImage;
  Function(String) onHashTag;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: isEmptyText ? 0 : 6),
      child: InkWell(
        onTap: () => onHashTag(text),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          decoration: BoxDecoration(
            image: isImage == true
                ? const DecorationImage(
                    image: AssetImage('assets/images/t-23.png'),
                    fit: BoxFit.cover,
                  )
                : null,
            color: isImage == true ? null : color!.s50,
            borderRadius: BorderRadius.circular(100),
          ),
          child: CommonName(
            text: '${isImage == true ? '+ ' : '#'}$text',
            color: isImage == true ? Colors.white : color!.original,
            fontSize: 13,
            isBold: isImage == true,
          ),
        ),
      ),
    );
  }
}
