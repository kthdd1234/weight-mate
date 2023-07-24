import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/icon/default_icon.dart';
import 'package:flutter_app_weight_management/components/icon/text_icon.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/text/contents_title_text.dart';
import 'package:flutter_app_weight_management/model/record_box/record_box.dart';
import 'package:flutter_app_weight_management/provider/record_icon_type_provider.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';

class TodayDiaryDataWidget extends StatelessWidget {
  TodayDiaryDataWidget({
    super.key,
    required this.text,
    required this.recordInfo,
    required this.provider,
  });

  String text;
  RecordBox? recordInfo;
  RecordIconTypeProvider provider;

  @override
  Widget build(BuildContext context) {
    onPressedEditIcon(_) {
      provider.setSeletedRecordIconType(RecordIconTypes.editNote);
    }

    onPressedDeleteIcon(_) {
      recordInfo?.whiteText = null;
      recordInfo?.save();

      provider.setSeletedRecordIconType(RecordIconTypes.none);
    }

    return InkWell(
      onTap: () => onPressedEditIcon(null),
      child: ContentsBox(
        width: MediaQuery.of(context).size.width,
        backgroundColor: typeBackgroundColor,
        contentsWidget: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ContentsTitleText(
              text: '눈바디 메모',
              fontSize: 13,
              sub: [
                DefaultIcon(
                  id: '',
                  icon: Icons.edit,
                  onTap: onPressedEditIcon,
                  color: buttonBackgroundColor,
                ),
                DefaultIcon(
                  id: '',
                  icon: Icons.delete,
                  onTap: onPressedDeleteIcon,
                  color: buttonBackgroundColor,
                ),
              ],
            ),
            SpaceHeight(height: smallSpace),
            Text(text),
          ],
        ),
      ),
    );
  }
}
