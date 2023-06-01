import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/framework/app_framework.dart';
import 'package:flutter_app_weight_management/pages/home/body/history_body.dart';
import 'package:flutter_app_weight_management/pages/home/body/analyze_body.dart';
import 'package:flutter_app_weight_management/pages/home/body/more_see_body.dart';
import 'package:flutter_app_weight_management/pages/home/body/record_body.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';
import 'package:flutter_app_weight_management/widgets/home_app_bar_widget.dart';

class HomeContainer extends StatefulWidget {
  const HomeContainer({super.key});

  @override
  State<HomeContainer> createState() => _HomeContainerState();
}

class _HomeContainerState extends State<HomeContainer> {
  eBottomNavigationBarItem selectedId = eBottomNavigationBarItem.record;

  List<eBottomNavigationBarItem> idList = [
    eBottomNavigationBarItem.record,
    eBottomNavigationBarItem.calendar,
    eBottomNavigationBarItem.analyze,
    eBottomNavigationBarItem.setting
  ];
  List<Widget> bodyList = const [
    RecordBody(),
    HistoryBody(),
    AnalyzeBody(),
    MoreSeeBody()
  ];

  List<BottomNavigationBarItem> items = const [
    BottomNavigationBarItem(icon: Icon(Icons.edit), label: '기록'),
    BottomNavigationBarItem(icon: Icon(Icons.calendar_month), label: '달력'),
    BottomNavigationBarItem(icon: Icon(Icons.equalizer), label: '분석'),
    BottomNavigationBarItem(icon: Icon(Icons.more_horiz), label: '더보기'),
  ];

  @override
  void initState() {
    selectedId = eBottomNavigationBarItem.record;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    onTap(int index) {
      setState(() => selectedId = idList[index]);
    }

    onTapGestureDetector() {
      FocusScope.of(context).unfocus();
    }

    return GestureDetector(
        onTap: onTapGestureDetector,
        child: AppFramework(
          widget: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: HomeAppBarWidget(appBar: AppBar(), id: selectedId),
            body: Padding(
              padding: pagePadding,
              child: SafeArea(child: bodyList[selectedId.index]),
            ),
            bottomNavigationBar: Theme(
              data: Theme.of(context).copyWith(canvasColor: Colors.transparent),
              child: BottomNavigationBar(
                items: items,
                elevation: 0,
                currentIndex: selectedId.index,
                selectedItemColor: buttonBackgroundColor,
                unselectedItemColor: const Color(0xFF151515),
                backgroundColor: Colors.red,
                onTap: onTap,
              ),
            ),
          ),
        ));
  }
}
