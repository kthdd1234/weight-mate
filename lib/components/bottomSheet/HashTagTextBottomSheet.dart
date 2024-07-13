import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/common/CommonBottomSheet.dart';
import 'package:flutter_app_weight_management/common/CommonModalItem.dart';
import 'package:flutter_app_weight_management/common/CommonModalSheet.dart';
import 'package:flutter_app_weight_management/common/CommonOutlineInputField.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/listView/ColorListView.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/utils/function.dart';

class HashTagTextBottomSheet extends StatefulWidget {
  const HashTagTextBottomSheet({super.key});

  @override
  State<HashTagTextBottomSheet> createState() => _HashTagTextBottomSheetState();
}

class _HashTagTextBottomSheetState extends State<HashTagTextBottomSheet> {
  String selectedColorName = '남색';
  TextEditingController controller = TextEditingController();

  onColor(newColorName) {
    setState(() => selectedColorName = newColorName);
  }

  onEditingComplete() {
    //
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: CommonModalSheet(
        title: '해시태그 추가',
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
                hintText: '제목을 입력해주세요',
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
