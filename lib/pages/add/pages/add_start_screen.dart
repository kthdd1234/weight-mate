import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/common/CommonText.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/pages/add/add_container.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';

class AddStartScreen extends StatelessWidget {
  const AddStartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    onPressedStart() {
      Navigator.pushNamed(context, '/add-body-info');
    }

    return AddContainer(
      isCenter: true,
      body: Column(
        children: [
          Image.asset('assets/images/MATE.png', width: 150),
          SpaceHeight(height: regularSapce),
          CommonText(text: '체중 메이트', size: 15, isBold: true, isCenter: true),
          SpaceHeight(height: regularSapce),
          CommonText(text: '반가워요! 체중 메이트와 함께', size: 13, isCenter: true),
          CommonText(text: '건강한 다이어트를 시작해봐요:)', size: 13, isCenter: true),
        ],
      ),
      buttonEnabled: true,
      bottomSubmitButtonText: '시작하기',
      onPressedBottomNavigationButton: onPressedStart,
    );
  }
}
