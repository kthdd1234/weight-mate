import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/common/CommonButton.dart';
import 'package:flutter_app_weight_management/provider/enabled_provider.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/widgets/space/spaceWidth.dart';
import 'package:provider/provider.dart';

class WeightBottmSheet extends StatelessWidget {
  WeightBottmSheet({
    super.key,
    required this.onCompleted,
    required this.onCancel,
  });

  Function() onCompleted, onCancel;

  @override
  Widget build(BuildContext context) {
    bool isEnabled = context.watch<EnabledProvider>().isEnabled;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        color: const Color(0xffCCCDD3),
        padding: const EdgeInsets.all(tinySpace),
        child: Row(
          children: [
            CommonButton(
              text: '취소',
              fontSize: 18,
              radious: 5,
              bgColor: Colors.white,
              textColor: textColor,
              onTap: onCancel,
            ),
            SpaceWidth(width: tinySpace),
            CommonButton(
              text: '완료',
              fontSize: 18,
              radious: 5,
              bgColor: isEnabled ? themeColor : Colors.grey.shade400,
              textColor: isEnabled ? Colors.white : Colors.grey.shade300,
              onTap: onCompleted,
            ),
          ],
        ),
      ),
    );
  }
}
