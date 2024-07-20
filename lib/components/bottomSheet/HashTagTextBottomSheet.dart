import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/common/CommonModalItem.dart';
import 'package:flutter_app_weight_management/common/CommonModalSheet.dart';
import 'package:flutter_app_weight_management/common/CommonOutlineInputField.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/dialog/confirm_dialog.dart';
import 'package:flutter_app_weight_management/components/listView/ColorListView.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/main.dart';
import 'package:flutter_app_weight_management/model/user_box/user_box.dart';
import 'package:flutter_app_weight_management/utils/class.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HashTagTextBottomSheet extends StatefulWidget {
  HashTagTextBottomSheet({super.key, this.hashTag});

  HashTagClass? hashTag;

  @override
  State<HashTagTextBottomSheet> createState() => _HashTagTextBottomSheetState();
}

class _HashTagTextBottomSheetState extends State<HashTagTextBottomSheet> {
  UserBox? user = userRepository.user;
  String selectedColorName = '남색';
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    if (widget.hashTag != null) {
      selectedColorName = widget.hashTag!.colorName;
      controller.text = widget.hashTag!.text;
    }

    super.initState();
  }

  onColor(newColorName) {
    setState(() => selectedColorName = newColorName);
  }

  onEditingComplete() async {
    UserBox? user = userRepository.user;

    if (controller.text != '') {
      if (widget.hashTag == null) {
        Map<String, String> newHashTag = {
          'id': uuid(),
          'text': controller.text,
          'colorName': selectedColorName
        };
        user.hashTagList?.add(newHashTag);
      } else {
        int idx = getHashTagIndex(user.hashTagList!, widget.hashTag!.id);

        if (idx != -1) {
          user.hashTagList![idx]['text'] = controller.text;
          user.hashTagList![idx]['colorName'] = selectedColorName;
        }
      }

      await user.save();
      closeDialog(context);
    } else {
      showDialog(
        context: context,
        builder: (context) => ConfirmDialog(
          width: 300,
          titleText: '글자 수 0',
          contentIcon: Icons.text_fields_rounded,
          contentText1: '입력된 단어가 없어요',
          contentText2: '한 글자 이상 입력해주세요',
          onPressedOk: () => closeDialog(context),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: CommonModalSheet(
        title: '해시태그 ${widget.hashTag == null ? '추가' : '수정'}',
        height: 210,
        child: ContentsBox(
          padding: const EdgeInsets.only(
            left: 15,
            right: 15,
          ),
          contentsWidget: ListView(
            shrinkWrap: true,
            children: [
              CommonModalItem(
                title: '색상',
                onTap: () {},
                child: ColorListView(
                  selectedColorName: selectedColorName,
                  onColor: onColor,
                ),
              ),
              SpaceHeight(height: 17.5),
              CommonOutlineInputField(
                controller: controller,
                hintText: '키워드를 입력해주세요',
                selectedColor: getColorClass(selectedColorName).s200,
                onSuffixIcon: onEditingComplete,
                onEditingComplete: onEditingComplete,
                onChanged: (_) => setState(() {}),
              )
            ],
          ),
        ),
      ),
    );
  }
}
