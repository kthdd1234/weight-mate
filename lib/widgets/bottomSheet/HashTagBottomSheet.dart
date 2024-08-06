import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/common/CommonBottomSheet.dart';
import 'package:flutter_app_weight_management/common/CommonText.dart';
import 'package:flutter_app_weight_management/widgets/area/empty_area.dart';
import 'package:flutter_app_weight_management/widgets/bottomSheet/HashTagTextBottomSheet.dart';
import 'package:flutter_app_weight_management/widgets/button/expanded_button_hori.dart';
import 'package:flutter_app_weight_management/widgets/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/widgets/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/widgets/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/main.dart';
import 'package:flutter_app_weight_management/model/user_box/user_box.dart';
import 'package:flutter_app_weight_management/utils/class.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:flutter_app_weight_management/utils/variable.dart';
import 'package:multi_value_listenable_builder/multi_value_listenable_builder.dart';

class HashTagBottomSheet extends StatefulWidget {
  HashTagBottomSheet({
    super.key,
    required this.hashTagIdList,
    required this.onCompleted,
  });

  List<String> hashTagIdList;
  Function(List<HashTagClass>) onCompleted;

  @override
  State<HashTagBottomSheet> createState() => _HashTagBottomSheetState();
}

class _HashTagBottomSheetState extends State<HashTagBottomSheet> {
  UserBox user = userRepository.user;
  List<String> selectedHashTagIdList = [];
  bool isEditMode = false;

  @override
  void initState() {
    selectedHashTagIdList = widget.hashTagIdList;
    super.initState();
  }

  onItem(String id) {
    if (isEditMode) {
      HashTagClass? hashTag = getHashTag(userRepository.user.hashTagList, id);

      showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) => HashTagTextBottomSheet(hashTag: hashTag),
      );
    } else {
      selectedHashTagIdList.contains(id)
          ? selectedHashTagIdList.remove(id)
          : selectedHashTagIdList.add(id);
      setState(() {});
    }
  }

  onRemove(String id) async {
    int idx = getHashTagIndex(user.hashTagList!, id);

    if (idx != -1) {
      user.hashTagList!.removeAt(idx);
    }

    await user.save();
  }

  onAdd() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) => HashTagTextBottomSheet(),
    );
  }

  onEdit(bool newValue) {
    setState(() {
      isEditMode = newValue;
      selectedHashTagIdList = newValue ? [] : widget.hashTagIdList;
    });
  }

  onCompleted() {
    List<Map<String, String>>? hashTagList = user.hashTagList ?? [];
    List<HashTagClass> hashTagClassList = [];

    for (var id in selectedHashTagIdList) {
      int index = hashTagList.indexWhere((hashTag) => hashTag['id'] == id);

      if (index != -1) {
        hashTagClassList.add(HashTagClass(
          id: id,
          text: hashTagList[index]['text']!,
          colorName: hashTagList[index]['colorName']!,
        ));
      }
    }

    widget.onCompleted(hashTagClassList);
    closeDialog(context);
  }

  btn({
    required String text,
    required int flex,
    required Function() onTap,
    Color? color,
    Color? textColor,
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
      textColor: textColor,
      onTap: onTap,
    );
  }

  onBack() {
    //
  }

  @override
  Widget build(BuildContext context) {
    return MultiValueListenableBuilder(
        valueListenables: valueListenables,
        builder: (context, values, child) {
          List<HashTagClass> hashTagClassList =
              getHashTagClassList(user.hashTagList ?? []);
          String path = 'assets/images';
          List<Widget> children = isEditMode
              ? [
                  btn(
                    text: '편집 해제',
                    flex: 1,
                    imgUrl: '$path/t-4.png',
                    onTap: () => onEdit(false),
                  )
                ]
              : [
                  btn(
                    text: '추가',
                    flex: 0,
                    imgUrl: '$path/t-3.png',
                    onTap: onAdd,
                  ),
                  SpaceWidth(width: 5),
                  btn(
                    text: '편집',
                    flex: 0,
                    imgUrl: '$path/t-4.png',
                    onTap: () => onEdit(true),
                  ),
                  SpaceWidth(width: 5),
                  btn(
                    text: '완료',
                    flex: 1,
                    textColor: Colors.white,
                    color: themeColor,
                    onTap: onCompleted,
                  ),
                ];

          return CommonBottomSheet(
            title: '#해시태그',
            height: 500,
            contents: Expanded(
              child: ContentsBox(
                child: hashTagClassList.isNotEmpty
                    ? SingleChildScrollView(
                        child: Column(
                          children: [
                            isEditMode
                                ? Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: whiteBgBtnColor,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          IconText(
                                            icon: Icons.remove_circle,
                                            iconColor: red.original,
                                            iconSize: 12,
                                            text: '버튼 터치 시 바로 삭제돼고',
                                            textColor: grey.original,
                                            textSize: 12,
                                          ),
                                          SpaceHeight(height: 3),
                                          CommonText(
                                            text: '해시태그 터치 시 수정할 수 있어요',
                                            size: 12,
                                            color: grey.original,
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                : EmptyArea(),
                            HashTagList(
                              hashTagClassList: hashTagClassList,
                              selectedHashTagList: selectedHashTagIdList,
                              isEditMode: isEditMode,
                              onItem: onItem,
                              onRemove: onRemove,
                            )
                          ],
                        ),
                      )
                    : CommonText(
                        text: '추가된 해시태그가 없어요.',
                        size: 14,
                        color: grey.original,
                        isCenter: true,
                      ),
              ),
            ),
            subContents: Row(children: children),
          );
        });
  }
}

class HashTagList extends StatelessWidget {
  HashTagList({
    super.key,
    required this.hashTagClassList,
    required this.selectedHashTagList,
    required this.isEditMode,
    required this.onItem,
    required this.onRemove,
  });

  List<HashTagClass> hashTagClassList;
  List<String> selectedHashTagList;
  bool isEditMode;
  Function(String) onItem, onRemove;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Wrap(
            spacing: 7,
            runSpacing: 7,
            children: hashTagClassList
                .map((hashTag) => HashTag(
                      id: hashTag.id,
                      text: hashTag.text,
                      colorName: hashTag.colorName,
                      isFilled: selectedHashTagList.contains(hashTag.id),
                      isEditMode: isEditMode,
                      isOutline: true,
                      onItem: onItem,
                      onRemove: onRemove,
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }
}

// HashTag
class HashTag extends StatelessWidget {
  HashTag({
    super.key,
    required this.id,
    required this.text,
    required this.colorName,
    required this.isFilled,
    required this.isEditMode,
    required this.onItem,
    required this.onRemove,
    this.isOutline,
  });

  String id, text, colorName;
  bool isFilled, isEditMode;
  bool? isOutline;
  Function(String id) onItem, onRemove;

  @override
  Widget build(BuildContext context) {
    ColorClass color = getColorClass(colorName);

    return Row(
      mainAxisSize: isEditMode ? MainAxisSize.min : MainAxisSize.min,
      children: [
        isEditMode
            ? Padding(
                padding: const EdgeInsets.only(right: 2, left: 7),
                child: InkWell(
                  child: Icon(
                    Icons.remove_circle,
                    color: red.original,
                    size: 18,
                  ),
                  onTap: () => onRemove(id),
                ),
              )
            : const EmptyArea(),
        InkWell(
          onTap: () => onItem(id),
          child: Container(
            padding: isOutline == true
                ? const EdgeInsets.symmetric(vertical: 5, horizontal: 15)
                : null,
            decoration: isOutline == true
                ? BoxDecoration(
                    color: isFilled ? color.s50 : null,
                    border: Border.all(
                      width: 0.5,
                      color: isFilled ? color.s50 : grey.s300,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  )
                : null,
            child: Text(
              '#$text',
              style: TextStyle(
                fontSize: 14,
                color: isFilled ? color.original : grey.original,
              ),
            ),
          ),
        )
      ],
    );
  }
}

class IconText extends StatelessWidget {
  IconText({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.iconSize,
    required this.text,
    required this.textColor,
    required this.textSize,
  });

  IconData icon;
  Color iconColor;
  double iconSize;
  String text;
  Color textColor;
  double textSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: iconSize, color: iconColor),
        SpaceWidth(width: 3),
        Column(
          children: [
            SpaceHeight(height: 2),
            Text(
              text,
              style: TextStyle(color: textColor, fontSize: textSize),
            ),
          ],
        )
      ],
    );
  }
}
