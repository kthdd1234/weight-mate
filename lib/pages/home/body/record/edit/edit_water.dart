import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/widgets/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/pages/home/body/record/edit/container/title_container.dart';

class EditWater extends StatelessWidget {
  const EditWater({super.key});

  @override
  Widget build(BuildContext context) {
    final tags = [
      TagClass(text: '0ml', color: 'lightBlue', onTap: () {}),
      TagClass(text: '수분 모아보기', color: 'lightBlue', onTap: () {}),
      TagClass(
        color: 'lightBlue',
        icon: Icons.keyboard_arrow_right_rounded,
        onTap: () {},
      ),
    ];

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: ContentsBox(
        width: double.infinity,
        child: Column(
          children: [
            TitleContainer(
              title: '수분',
              svg: 't-water',
              tags: tags,
              isDivider: false,
            )
          ],
        ),
      ),
    );
  }
}
