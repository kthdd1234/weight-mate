import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/area/empty_text_area.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/icon/default_icon.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/text/contents_title_text.dart';
import 'package:flutter_app_weight_management/pages/home/body/widgets/today_memo_edit_widget.dart';
import 'package:flutter_app_weight_management/pages/home/body/widgets/today_memo_widget.dart';
import 'package:flutter_app_weight_management/provider/diet_Info_provider.dart';
import 'package:flutter_app_weight_management/provider/record_sub_type_provider.dart';
import 'package:flutter_app_weight_management/utils/class.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';
import 'package:provider/provider.dart';

class RecordMemoWidget extends StatelessWidget {
  RecordMemoWidget({
    super.key,
    required this.seletedRecordSubType,
  });

  RecordSubTypes seletedRecordSubType;

  @override
  Widget build(BuildContext context) {
    // String todayMemoText = context.watch<DietInfoProvider>().getTodayMemoText();
    // todo: hive 데이터 가져와야 한다.

    List<RecordSubTypeClass> subClassList = [
      RecordSubTypeClass(
        enumId: RecordSubTypes.editNote,
        icon: Icons.edit,
      ),
      RecordSubTypeClass(
        enumId: RecordSubTypes.addEyeBody,
        icon: Icons.add_photo_alternate,
      ),
      RecordSubTypeClass(
        enumId: RecordSubTypes.resetNote,
        icon: Icons.replay,
      )
    ];

    List<DefaultIcon> subWidgets = subClassList
        .map((element) => DefaultIcon(
              id: element.enumId,
              icon: element.icon,
              onTap: (id) {},
            ))
        .toList();

    Widget setRouteTodayOfMemoWidget() {
      if (RecordSubTypes.editNote == seletedRecordSubType) {
        return TodayMemoEditWidget(todayMemoText: '');
      } else if ('' == '') {
        return EmptyTextArea(
            topHeight: regularSapce,
            downHeight: regularSapce,
            text: '오늘의 메모를 추가해보세요.',
            icon: Icons.add,
            onTap: () => context
                .read<RecordSubTypeProvider>()
                .setSeletedRecordSubType(RecordSubTypes.editNote));
      }

      return TodayMemoWidget(text: '');
    }

    return ContentsBox(
      contentsWidget: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ContentsTitleText(
            text: '오늘의 메모',
            icon: Icons.textsms_outlined,
            sub: subWidgets,
          ),
          SpaceHeight(height: regularSapce),
          setRouteTodayOfMemoWidget(),
        ],
      ),
    );
  }
}
