import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/common/CommonName.dart';
import 'package:flutter_app_weight_management/common/CommonPopup.dart';
import 'package:flutter_app_weight_management/widgets/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/widgets/popup/AlertPopup.dart';
import 'package:flutter_app_weight_management/widgets/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/main.dart';
import 'package:flutter_app_weight_management/model/user_box/user_box.dart';
import 'package:flutter_app_weight_management/provider/premium_provider.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:flutter_app_weight_management/utils/variable.dart';
import 'package:provider/provider.dart';

class CalendarMakerPopup extends StatefulWidget {
  const CalendarMakerPopup({super.key});

  @override
  State<CalendarMakerPopup> createState() => _CalendarMakerPopupState();
}

class _CalendarMakerPopupState extends State<CalendarMakerPopup> {
  UserBox user = userRepository.user;

  onMaker(String id, bool isPremium) async {
    if (isPremium == false && id == CalendarMaker.picture.toString()) {
      showDialog(
        context: context,
        builder: (context) => AlertPopup(
          height: 185,
          text1: '프리미엄을 구매한 분들이게만',
          text2: '제공되는 기능이에요',
          buttonText: '프리미엄 구매 페이지로 이동',
          onTap: () => Navigator.pushNamed(context, '/premium-page'),
        ),
      );
    } else {
      userRepository.user.calendarMaker = id;

      await user.save();
      closeDialog(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isPremium = context.watch<PremiumProvider>().isPremium;
    String calendarMaker =
        user.calendarMaker ?? CalendarMaker.sticker.toString();

    return CommonPopup(
      height: 304,
      horizontal: 0,
      child: Column(
        children: [
          CommonName(text: '캘린더 표시 유형'),
          SpaceHeight(height: 10),
          Expanded(
            child: ContentsBox(
              width: double.infinity,
              child: Column(
                children: calendarMakerList
                    .map((item) => CalendarMakerItem(
                          id: item.id,
                          title: item.title,
                          desc: item.desc,
                          isSelected: item.id == calendarMaker,
                          widget: item.widget,
                          isLast: item.id == CalendarMaker.picture.toString(),
                          onTap: (id) => onMaker(id, isPremium),
                        ))
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CalendarMakerItem extends StatelessWidget {
  CalendarMakerItem({
    super.key,
    required this.id,
    required this.title,
    required this.desc,
    required this.isSelected,
    required this.widget,
    required this.onTap,
    this.isLast,
  });

  String id, title, desc;
  bool isSelected;
  bool? isLast;
  Widget widget;
  Function(String id) onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast == true ? 0 : 7),
      child: InkWell(
        onTap: () => onTap(id),
        child: ContentsBox(
          width: double.infinity,
          padding: const EdgeInsets.all(10),
          backgroundColor: isSelected ? themeColor : whiteBgBtnColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonName(
                    text: title,
                    color: isSelected ? Colors.white : themeColor,
                    isBold: isSelected,
                  ),
                  SpaceHeight(height: 3),
                  CommonName(
                    text: desc,
                    color: isSelected ? grey.s300 : grey.original,
                    isBold: isSelected,
                    fontSize: 10,
                  ),
                ],
              ),
              CircleAvatar(backgroundColor: Colors.white, child: widget)
            ],
          ),
        ),
      ),
    );
  }
}
