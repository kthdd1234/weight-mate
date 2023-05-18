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
  eBottomNavigationBarItem id;

  @override
  State<HomeAppBarWidget> createState() => _HomeAppBarWidgetState();

  @override
  Size get preferredSize => Size.fromHeight(appBar.preferredSize.height);
}

class _HomeAppBarWidgetState extends State<HomeAppBarWidget> {
  List<String> titleList = ['기록', '히스토리', '분석', '더보기'];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    setAppBarCalendarTextWidget() {
      if (eBottomNavigationBarItem.record == widget.id) {
        return AppBarCalendarDayWidget();
      }

      return Text(titleList[widget.id.index]);
    }

    return AppBar(
      title: setAppBarCalendarTextWidget(),
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      centerTitle: false,
      foregroundColor: buttonBackgroundColor,
      actions: [],
    );
  }
}
