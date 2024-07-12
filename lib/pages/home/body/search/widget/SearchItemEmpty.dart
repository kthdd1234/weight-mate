import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/common/CommonText.dart';

class SearchItemEmpty extends StatelessWidget {
  const SearchItemEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 5,
                  horizontal: 15,
                ),
                decoration: BoxDecoration(
                  color: Colors.indigo.shade200,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: CommonText(
                  text: '#해시태크 만들기',
                  size: 14,
                  color: Colors.white,
                  isBold: true,
                ),
              ),
            ],
          ),
        ),
        // const Spacer(),
        // CommonText(
        //   text: '이전의 할 일 또는 메모를\n검색해보세요',
        //   color: grey.original,
        //   isBold: !isLight,
        // ),
        // const Spacer(),
      ],
    );
  }
}
