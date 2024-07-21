import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/common/CommonName.dart';
import 'package:flutter_app_weight_management/components/bottomSheet/HashTagTextBottomSheet.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/main.dart';
import 'package:flutter_app_weight_management/model/user_box/user_box.dart';
import 'package:flutter_app_weight_management/pages/home/body/record/record_body.dart';
import 'package:flutter_app_weight_management/utils/class.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:flutter_app_weight_management/utils/variable.dart';
import 'package:multi_value_listenable_builder/multi_value_listenable_builder.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class SearchHashTag extends StatefulWidget {
  SearchHashTag({
    super.key,
    required this.keyword,
    required this.initialScrollIndex,
    required this.onHashTag,
  });

  String keyword;
  int initialScrollIndex;
  Function(String) onHashTag;

  @override
  State<SearchHashTag> createState() => _SearchHashTagState();
}

class _SearchHashTagState extends State<SearchHashTag> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: MultiValueListenableBuilder(
          valueListenables: valueListenables,
          builder: (context, values, child) {
            UserBox user = userRepository.user;
            List<HashTagClass> userHashTagClassList =
                getHashTagClassList(user.hashTagList ?? []);

            onAddHashTag(_) {
              showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                builder: (btx) => HashTagTextBottomSheet(),
              );
            }

            List<Widget> hashTagWidgetList = userHashTagClassList
                .map((hashTag) => HashTagKeyword(
                      keyword: widget.keyword,
                      text: hashTag.text,
                      color: getColorClass(hashTag.colorName),
                      onHashTag: widget.onHashTag,
                    ))
                .toList();

            hashTagWidgetList.add(HashTagKeyword(
              keyword: widget.keyword,
              text: '해시태그 만들기',
              isImage: true,
              onHashTag: onAddHashTag,
            ));

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 7),
              child: ContentsBox(
                width: widget.keyword == '' ? double.infinity : null,
                padding: const EdgeInsets.all(15),
                contentsWidget: widget.keyword == ''
                    ? Wrap(
                        spacing: 7, runSpacing: 7, children: hashTagWidgetList)
                    : HorizontalHashTagList(
                        initialScrollIndex: widget.initialScrollIndex,
                        hashTagWidgetList: hashTagWidgetList,
                      ),
              ),
            );
          }),
    );
  }
}

class HorizontalHashTagList extends StatefulWidget {
  HorizontalHashTagList({
    super.key,
    required this.initialScrollIndex,
    required this.hashTagWidgetList,
  });

  int initialScrollIndex;
  List<Widget> hashTagWidgetList;

  @override
  State<HorizontalHashTagList> createState() => _HorizontalHashTagListState();
}

class _HorizontalHashTagListState extends State<HorizontalHashTagList> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 30,
        child: ScrollablePositionedList.builder(
          scrollDirection: Axis.horizontal,
          itemCount: widget.hashTagWidgetList.length,
          itemBuilder: (ctx, index) => widget.hashTagWidgetList[index],
          initialScrollIndex: widget.initialScrollIndex,
        ));
  }
}

class HashTagKeyword extends StatelessWidget {
  HashTagKeyword({
    super.key,
    required this.text,
    required this.keyword,
    required this.onHashTag,
    this.color,
    this.isImage,
  });

  String text, keyword;
  ColorClass? color;
  bool? isImage;
  Function(String) onHashTag;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: keyword == '' ? 0 : 6),
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
            color: isImage == true
                ? null
                : text == keyword
                    ? indigo.s300
                    : color!.s50,
            borderRadius: BorderRadius.circular(100),
          ),
          child: CommonName(
            text: '${isImage == true ? '+ ' : '#'}$text',
            color: isImage == true || text == keyword
                ? Colors.white
                : color!.original,
            fontSize: 13,
            isBold: isImage == true || text == keyword,
            isNotTr: true,
          ),
        ),
      ),
    );
  }
}
