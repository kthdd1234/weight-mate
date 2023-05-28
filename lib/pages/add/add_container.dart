import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/button/bottom_submit_button.dart';
import 'package:flutter_app_weight_management/components/framework/app_framework.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';

class AddContainer extends StatelessWidget {
  const AddContainer({
    super.key,
    required this.body,
    required this.buttonEnabled,
    required this.bottomSubmitButtonText,
    required this.onPressedBottomNavigationButton,
  });

  final Widget body;
  final bool buttonEnabled;
  final String bottomSubmitButtonText;
  final VoidCallback onPressedBottomNavigationButton;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: AppFramework(
        widget: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            centerTitle: false,
            foregroundColor: buttonBackgroundColor,
          ),
          body: Padding(
            padding: pagePadding,
            child: SafeArea(child: SingleChildScrollView(child: body)),
          ),
          bottomNavigationBar: BottomSubmitButton(
            isEnabled: buttonEnabled,
            text: bottomSubmitButtonText,
            onPressed: onPressedBottomNavigationButton,
          ),
        ),
      ),
    );
  }
}
