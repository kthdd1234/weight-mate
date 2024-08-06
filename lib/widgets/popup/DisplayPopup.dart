import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/common/CommonCheckBox.dart';
import 'package:flutter_app_weight_management/common/CommonName.dart';
import 'package:flutter_app_weight_management/common/CommonPopup.dart';
import 'package:flutter_app_weight_management/common/CommonText.dart';
import 'package:flutter_app_weight_management/widgets/area/empty_area.dart';
import 'package:flutter_app_weight_management/widgets/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/widgets/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/utils/class.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/variable.dart';
import 'package:multi_value_listenable_builder/multi_value_listenable_builder.dart';

class DisplayPopup extends StatelessWidget {
  DisplayPopup({
    super.key,
    required this.isRequiredWeight,
    required this.bottomText,
    required this.classList,
    required this.height,
    required this.onChecked,
    required this.onTap,
  });

  bool isRequiredWeight;
  String bottomText;
  double height;
  List<FilterClass> classList;
  bool Function(String) onChecked;
  Function({required dynamic id, required bool newValue}) onTap;

  @override
  Widget build(BuildContext context) {
    return MultiValueListenableBuilder(
      valueListenables: valueListenables,
      builder: (context, values, child) => CommonPopup(
        height: height,
        child: Column(
          children: [
            CommonName(text: '카테고리 표시'),
            SpaceHeight(height: 10),
            ContentsBox(
              child: Column(
                children: classList
                    .map(
                      (data) => Column(
                        children: [
                          Row(
                            children: [
                              CommonCheckBox(
                                id: data.id,
                                isCheck: onChecked(data.id),
                                checkColor: themeColor,
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
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                bottomText,
                style: TextStyle(fontSize: 10, color: grey.original),
              ),
            )
          ],
        ),
      ),
    );
  }
}
