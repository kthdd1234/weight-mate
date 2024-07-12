import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/common/CommonBottomSheet.dart';
import 'package:flutter_app_weight_management/components/button/expanded_button_hori.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/variable.dart';

class HashTagBottomSheet extends StatefulWidget {
  const HashTagBottomSheet({super.key});

  @override
  State<HashTagBottomSheet> createState() => _HashTagBottomSheetState();
}

class _HashTagBottomSheetState extends State<HashTagBottomSheet> {
  List<String> hashTagList = [];

  btn({
    required String text,
    required Function() onTap,
    Color? color,
    String? imgUrl,
  }) {
    return ExpandedButtonHori(
      padding: const EdgeInsets.all(15),
      imgUrl: imgUrl,
      text: text,
      color: color,
      fontSize: 15,
      onTap: onAdd,
    );
  }

  onAdd() {
    //
  }

  onEdit() {
    //
  }

  onCompleted() {
    //
  }

  @override
  Widget build(BuildContext context) {
    String path = 'assets/images/';

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
                      .map((name) => HashTag(name: name))
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ),
      subContents: Row(
        children: [
          btn(text: '+ 추가', imgUrl: '$path/t-22.png', onTap: onAdd),
          SpaceWidth(width: 5),
          btn(text: '편집', imgUrl: '$path/t-23.png', onTap: onEdit),
          SpaceWidth(width: 5),
          btn(text: '완료', color: themeColor, onTap: onCompleted),
        ],
      ),
    );
  }
}

class HashTag extends StatelessWidget {
  HashTag({super.key, required this.name});

  String name;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 5, bottom: 10),
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 5,
          horizontal: 20,
        ),
        decoration: BoxDecoration(
          border: Border.all(
            width: 1,
            color: Colors.grey.shade300,
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(30),
          ),
        ),
        child: Text(name),
      ),
    );
  }
}
