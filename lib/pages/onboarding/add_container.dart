import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/common/CommonBackground.dart';
import 'package:flutter_app_weight_management/common/CommonScaffold.dart';
import 'package:flutter_app_weight_management/components/area/empty_area.dart';
import 'package:flutter_app_weight_management/components/button/bottom_submit_button.dart';
import 'package:flutter_app_weight_management/utils/class.dart';

class AddContainer extends StatefulWidget {
  AddContainer({
    super.key,
    required this.body,
    required this.buttonEnabled,
    required this.bottomSubmitButtonText,
    this.onPressedBottomNavigationButton,
    this.title,
    this.isCenter,
    this.isNotBack,
  });

  Widget body;
  bool buttonEnabled;
  String bottomSubmitButtonText;
  VoidCallback? onPressedBottomNavigationButton;
  String? title;
  bool? isCenter;
  bool? isNotBack;

  @override
  State<AddContainer> createState() => _AddContainerState();
}

class _AddContainerState extends State<AddContainer> {
  onTap() {
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return CommonBackground(
      path: '1',
      child: CommonScaffold(
        appBarInfo: widget.isNotBack == true
            ? null
            : AppBarInfoClass(
                title: widget.title != null ? widget.title! : '',
                isCenter: true,
              ),
        body: widget.isCenter == true
            ? Center(child: SingleChildScrollView(child: widget.body))
            : SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: widget.body),
        bottomNavigationBar: widget.onPressedBottomNavigationButton != null
            ? SafeArea(
                child: BottomSubmitButton(
                  isEnabled: widget.buttonEnabled,
                  text: widget.bottomSubmitButtonText.tr(),
                  onPressed: widget.onPressedBottomNavigationButton!,
                ),
              )
            : const EmptyArea(),
      ),
    );
  }
}
