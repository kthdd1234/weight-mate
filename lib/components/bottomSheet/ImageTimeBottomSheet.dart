import 'package:flutter/cupertino.dart';
import 'package:flutter_app_weight_management/common/CommonBottomSheet.dart';
import 'package:flutter_app_weight_management/common/CommonContainer.dart';
import 'package:flutter_app_weight_management/common/CommonText.dart';

class ImageTimeBottomSheet extends StatelessWidget {
  ImageTimeBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return CommonBottomSheet(
      title: '사진 시간 표시',
      height: 200,
      contents: CommonContainer(
        child: Row(
          children: [
            Column(
              children: [CommonText(text: '시간의 시간을', size: 14)],
            )
          ],
        ),
      ),
    );
  }
}
