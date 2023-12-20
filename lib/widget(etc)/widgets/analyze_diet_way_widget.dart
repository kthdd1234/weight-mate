import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/components/text/body_small_text.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';

class AnalyzeDietWayWidget extends StatelessWidget {
  const AnalyzeDietWayWidget({super.key});

  @override
  Widget build(BuildContext context) {
    onPressed() {
      Navigator.pushNamed(context, '/analyze-diet-way-intro');
    }

    return ContentsBox(
      backgroundColor: typeBackgroundColor,
      contentsWidget: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                '다이어트 방법 소개',
                style: TextStyle(
                  fontSize: 15,
                  color: buttonBackgroundColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SpaceWidth(width: 3),
              const Icon(
                Icons.auto_awesome_outlined,
                size: 18,
                color: buttonBackgroundColor,
              )
            ],
          ),
          SpaceHeight(height: regularSapce),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '많이 알려진 다이어트 방법',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SpaceHeight(height: tinySpace),
                  const Text(
                    '5가지를 소개해 드려요.',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SpaceHeight(height: tinySpace),
                  BodySmallText(text: '약 3분 소요')
                ],
              ),
              Row(
                children: [
                  Container(
                    width: 90,
                    height: 90,
                    decoration: const BoxDecoration(
                      color: dialogBackgroundColor,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.content_paste_search,
                      size: 50,
                      color: buttonBackgroundColor,
                    ),
                  ),
                  SpaceWidth(width: smallSpace)
                ],
              ),
            ],
          ),
          SpaceHeight(height: regularSapce),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(45),
              ),
              onPressed: onPressed,
              child: const Text('알아보기'))
        ],
      ),
    );
  }
}
