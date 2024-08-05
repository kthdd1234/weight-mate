import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app_weight_management/common/CommonModalSheet.dart';
import 'package:flutter_app_weight_management/common/CommonText.dart';
import 'package:flutter_app_weight_management/widgets/bottomSheet/HashTagBottomSheet.dart';
import 'package:flutter_app_weight_management/widgets/contents_box/contents_box.dart';
import 'package:flutter_app_weight_management/main.dart';
import 'package:flutter_app_weight_management/model/user_box/user_box.dart';
import 'package:flutter_app_weight_management/pages/home/body/record/record_body.dart';
import 'package:flutter_app_weight_management/utils/class.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:flutter_app_weight_management/utils/variable.dart';
import 'package:multi_value_listenable_builder/multi_value_listenable_builder.dart';

class HashTagRemoveBottomSheet extends StatelessWidget {
  const HashTagRemoveBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return CommonModalSheet(
      title: '해시태그 삭제',
      height: 300,
      child: MultiValueListenableBuilder(
        valueListenables: valueListenables,
        builder: (context, values, child) {
          UserBox? user = userRepository.user;
          List<HashTagClass> hashTagClassList =
              getHashTagClassList(user.hashTagList);

          onRemove(String id) async {
            user.hashTagList?.removeWhere((hashTag) => hashTag['id'] == id);
            await user.save();
          }

          return ContentsBox(
            child: hashTagClassList.isNotEmpty
                ? SingleChildScrollView(
                    child: HashTagList(
                      hashTagClassList: hashTagClassList,
                      selectedHashTagList: hashTagClassList
                          .map((hashTag) => hashTag.id)
                          .toList(),
                      isEditMode: true,
                      onItem: (_) {},
                      onRemove: onRemove,
                    ),
                  )
                : Center(
                    child: CommonText(
                      text: '추가된 해시태그가 없어요.',
                      size: 14,
                      color: grey.original,
                      isCenter: true,
                    ),
                  ),
          );
        },
      ),
    );
  }
}
