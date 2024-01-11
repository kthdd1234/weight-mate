import 'package:flutter/material.dart';
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
          const Text(
            '체중 메이트',
            style: TextStyle(
              color: themeColor,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          SpaceHeight(height: regularSapce),
          const Text(
            '매일 체중을 기록하고',
            style: TextStyle(
              color: themeColor,
              fontSize: 13,
            ),
          ),
          SpaceHeight(height: tinySpace),
          const Text(
            '다이어트 계획을 세워 실천해보세요!',
            style: TextStyle(
              color: themeColor,
              fontSize: 13,
            ),
          ),
        ],
      ),
      buttonEnabled: true,
      bottomSubmitButtonText: '시작하기',
      onPressedBottomNavigationButton: onPressedStart,
    );
  }
}
