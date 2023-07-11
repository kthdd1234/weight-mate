import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';
import 'package:flutter_app_weight_management/widgets/app_bar_calendar_day_widget.dart';

class HomeAppBarWidget extends StatefulWidget implements PreferredSizeWidget {
  HomeAppBarWidget({
    super.key,
    required this.appBar,
    required this.id,
  });

  AppBar appBar;
  BottomNavigationEnum id;

  @override
  State<HomeAppBarWidget> createState() => _HomeAppBarWidgetState();

  @override
  Size get preferredSize => Size.fromHeight(appBar.preferredSize.height);
}

class _HomeAppBarWidgetState extends State<HomeAppBarWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<String> titleList = ['기록', '달력', '분석', '더보기'];

    setAppBarCalendarTextWidget() {
      if (BottomNavigationEnum.record == widget.id) {
        return const ImportDateTimeTitleWidget();
      }

      return Text(titleList[widget.id.index]);
    }

    return AppBar(
      title: setAppBarCalendarTextWidget(),
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      centerTitle: false,
      foregroundColor: buttonBackgroundColor,
    );
  }
}
