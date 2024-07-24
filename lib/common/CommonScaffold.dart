import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/common/CommonName.dart';
import 'package:flutter_app_weight_management/utils/class.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';

class CommonScaffold extends StatelessWidget {
  CommonScaffold({
    super.key,
    required this.body,
    this.appBarInfo,
    this.bottomNavigationBar,
    this.isFab,
    this.resizeToAvoidBottomInset,
    this.backgroundColor,
    this.foregroundColor,
    this.floatingActionButton,
    this.padding,
  });

  Widget? bottomNavigationBar;
  Widget body;
  AppBarInfoClass? appBarInfo;
  bool? resizeToAvoidBottomInset, isFab;
  Color? backgroundColor, foregroundColor;
  Widget? floatingActionButton;
  EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor ?? Colors.transparent,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      appBar: appBarInfo != null
          ? AppBar(
              title: CommonName(
                text: appBarInfo!.title.tr(namedArgs: appBarInfo!.nameArgs),
                fontSize: 18,
                color: appBarInfo!.titleColor,
                isBold: appBarInfo!.isBold,
              ),
              leading: appBarInfo!.leading,
              centerTitle: appBarInfo!.isCenter,
              actions: appBarInfo!.actions,
              backgroundColor: backgroundColor ?? Colors.transparent,
              foregroundColor: foregroundColor ?? themeColor,
              scrolledUnderElevation: 0,
              elevation: 0,
              automaticallyImplyLeading:
                  appBarInfo!.automaticallyImplyLeading ?? true,
            )
          : null,
      body: SafeArea(
        child: Padding(
          padding: padding ?? const EdgeInsets.all(15),
          child: body,
        ),
      ),
      bottomNavigationBar: bottomNavigationBar != null
          ? Theme(
              data: Theme.of(context).copyWith(canvasColor: Colors.transparent),
              child: bottomNavigationBar!,
            )
          : null,
      floatingActionButton: floatingActionButton,
    );
  }
}
