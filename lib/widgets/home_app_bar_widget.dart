import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
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
    String title = ['2023년 12월', '2023년 12월', '그래프', '설정'][widget.id.index];
    Widget child = widget.id.index < 2
        ? Row(
            children: [
              Text(title),
              SpaceWidth(width: tinySpace / 2),
              const Icon(Icons.expand_circle_down_outlined, size: 21)
            ],
          )
        : Text(title);

    return AppBar(
      title: InkWell(child: child),
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      centerTitle: false,
      foregroundColor: buttonBackgroundColor,
    );
  }
}
