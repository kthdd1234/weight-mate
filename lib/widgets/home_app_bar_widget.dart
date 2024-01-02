import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/common/widget/CommonTag.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';
import 'package:flutter_app_weight_management/widgets/app_bar_calendar_day_widget.dart';
import 'package:provider/provider.dart';

class HomeAppBarWidget extends StatefulWidget implements PreferredSizeWidget {
  HomeAppBarWidget({super.key, required this.appBar, required this.id});

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
    String title = ['기록', '2023년 12월', '그래프', '설정'][widget.id.index];
    Widget child = widget.id.index < 0
        ? Row(
            children: [
              Text(title),
              const Icon(Icons.keyboard_arrow_down_rounded, size: 25)
            ],
          )
        : Text(title);

    onRecordHistoryPage() {
      Navigator.pushNamed(context, '/record-history-page');
    }

    List<Widget> actions = widget.id.index == 0
        ? [
            // IconButton(
            //   onPressed: () => onNavigationPage('/image-collections-page'),
            //   icon: const Icon(Icons.apps_rounded, color: themeColor),
            // ),
            IconButton(
              onPressed: onRecordHistoryPage,
              icon: const Icon(Icons.menu_book_rounded, color: themeColor),
            )
          ]
        : [];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: smallSpace),
      child: AppBar(
        title: InkWell(child: child),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        centerTitle: false,
        foregroundColor: themeColor,
        actions: actions,
      ),
    );
  }
}
