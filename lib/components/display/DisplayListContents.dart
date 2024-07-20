import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/common/CommonBottomSheet.dart';
import 'package:flutter_app_weight_management/common/CommonCheckBox.dart';
import 'package:flutter_app_weight_management/common/CommonText.dart';
import 'package:flutter_app_weight_management/components/area/empty_area.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/utils/class.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:flutter_app_weight_management/utils/variable.dart';

class DisplayListContents extends StatelessWidget {
  DisplayListContents({
    super.key,
    required this.isRequiredWeight,
    required this.bottomText,
    required this.classList,
    required this.onChecked,
    required this.onTap,
  });

  bool isRequiredWeight;
  String bottomText;
  List<FilterClass> classList;
  bool Function(String) onChecked;
  Function({required dynamic id, required bool newValue}) onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AlertDialog(
          backgroundColor: whiteBgBtnColor,
          shape: containerBorderRadious,
          title: DialogTitle(
            text: '카테고리 표시',
            onTap: () => closeDialog(context),
          ),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              ContentsBox(
                  contentsWidget: Column(
                children: classList
                    .map(
                      (data) => Column(
                        children: [
                          Row(
                            children: [
                              CommonCheckBox(
                                id: data.id,
                                isCheck: onChecked(data.id),
                                checkColor: textColor,
                                onTap: onTap,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 5),
                                child: CommonText(text: data.name, size: 14),
                              ),
                              classList.first.id == data.id && isRequiredWeight
                                  ? Padding(
                                      padding: const EdgeInsets.only(left: 5),
                                      child: CommonText(
                                        text: '(필수)',
                                        size: 10,
                                        color: Colors.red,
                                      ),
                                    )
                                  : const EmptyArea()
                            ],
                          ),
                          SpaceHeight(
                            height:
                                classList.last.id == data.id ? 0.0 : smallSpace,
                          ),
                        ],
                      ),
                    )
                    .toList(),
              )),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(bottomText,
                    style: TextStyle(fontSize: 10, color: grey.original)),
              )
            ],
          ),
        )
      ],
    );
  }
}
