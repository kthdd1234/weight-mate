import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/area/empty_area.dart';
import 'package:flutter_app_weight_management/components/button/bottom_submit_button.dart';
import 'package:flutter_app_weight_management/components/framework/app_framework.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';

class AddContainer extends StatelessWidget {
  AddContainer({
    super.key,
    required this.body,
    required this.buttonEnabled,
    required this.bottomSubmitButtonText,
    this.onPressedBottomNavigationButton,
    this.title,
  });

  Widget body;
  bool buttonEnabled;
  String bottomSubmitButtonText;
  VoidCallback? onPressedBottomNavigationButton;
  String? title;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: AppFramework(
        widget: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: title != null ? Text(title!) : null,
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            centerTitle: true,
            foregroundColor: buttonBackgroundColor,
          ),
          body: Padding(
            padding: pagePadding,
            child: SafeArea(child: SingleChildScrollView(child: body)),
          ),
          bottomNavigationBar: onPressedBottomNavigationButton != null
              ? SafeArea(
                  child: BottomSubmitButton(
                    isEnabled: buttonEnabled,
                    text: bottomSubmitButtonText,
                    onPressed: onPressedBottomNavigationButton!,
                  ),
                )
              : const EmptyArea(),
        ),
      ),
    );
  }
}
