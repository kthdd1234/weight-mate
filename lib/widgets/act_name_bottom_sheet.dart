import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/area/empty_area.dart';
import 'package:flutter_app_weight_management/components/button/bottom_submit_button.dart';
import 'package:flutter_app_weight_management/components/button/ok_and_cancel_button.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/framework/app_framework.dart';
import 'package:flutter_app_weight_management/components/icon/circular_icon.dart';
import 'package:flutter_app_weight_management/components/icon/default_icon.dart';
import 'package:flutter_app_weight_management/components/input/text_input.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/text/contents_title_text.dart';
import 'package:flutter_app_weight_management/components/text/headline_text.dart';
import 'package:flutter_app_weight_management/provider/diet_Info_provider.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/variable.dart';
import 'package:provider/provider.dart';

class ActNameBottomSheet extends StatefulWidget {
  const ActNameBottomSheet({super.key});

  @override
  State<ActNameBottomSheet> createState() => _ActNameBottomSheetState();
}

class _ActNameBottomSheetState extends State<ActNameBottomSheet> {
  String name = '';

  @override
  Widget build(BuildContext context) {
    final actType = context.watch<DietInfoProvider>().getActType();

    onChangedName(String value) {
      setState(() => name = value);
    }

    onCloseButton(String id) {
      //
    }

    onPressedButton() {}

    return Container(
      height: 325,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10.0),
        image: const DecorationImage(
          image: AssetImage('assets/images/Cloudy_Apple.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Padding(
        padding: pagePadding,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DefaultIcon(
                  id: 'close',
                  icon: Icons.close,
                  onTap: (id) {},
                  color: Colors.transparent,
                ),
                ContentsTitleText(text: '사용자 정의 (${actTitles[actType]})'),
                DefaultIcon(
                    id: 'close', icon: Icons.close, onTap: onCloseButton)
              ],
            ),
            SpaceHeight(height: regularSapce),
            ContentsBox(
              contentsWidget: Column(
                children: [
                  ContentsTitleText(text: '이름'),
                  SpaceHeight(height: smallSpace),
                  TextInput(
                    autofocus: true,
                    maxLength: 12,
                    prefixIcon: Icons.edit,
                    suffixText: '',
                    hintText: '${actTitles[actType]} 이름을 입력해주세요.',
                    counterText: '(예: 줄넘기, 등산, 테니스 등)',
                    onChanged: onChangedName,
                    errorText: null,
                  ),
                ],
              ),
            ),
            SpaceHeight(height: regularSapce),
            BottomSubmitButton(
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
              width: MediaQuery.of(context).size.width,
              text: '다음',
              onPressed: onPressedButton,
              isEnabled: name != '',
            )
          ],
        ),
      ),
    );
  }
}
