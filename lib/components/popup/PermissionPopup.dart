import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/popup/AlertPopup.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionPopup extends StatelessWidget {
  const PermissionPopup({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertPopup(
      height: 185,
      buttonText: '설정으로 이동',
      text1: '설정으로 이동하여',
      text2: '알림을 허용 해주세요.',
      onTap: () {
        openAppSettings();
        closeDialog(context);
      },
    );
  }
}
