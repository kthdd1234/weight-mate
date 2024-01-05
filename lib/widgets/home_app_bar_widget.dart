import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/common/CommonText.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/provider/import_date_time_provider.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/enum.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:provider/provider.dart';

class HomeAppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  HomeAppBarWidget({super.key, required this.appBar, required this.id});

  AppBar appBar;
  BottomNavigationEnum id;

  @override
  Widget build(BuildContext context) {
    DateTime importDateTime =
        context.watch<ImportDateTimeProvider>().getImportDateTime();
    String title = [
      dateTimeFormatter(format: 'yyyy년 MM월', dateTime: importDateTime),
      '2023년',
      '체중 변화',
      '설정'
    ][id.index];
    IconData? rightIcon =
        id.index < 2 ? Icons.keyboard_arrow_down_rounded : null;

    return AppBar(
      title: Row(
        children: [
          SpaceWidth(width: smallSpace),
          CommonText(text: title, size: 20, rightIcon: rightIcon),
        ],
      ),
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      centerTitle: false,
      foregroundColor: themeColor,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(appBar.preferredSize.height);
}
