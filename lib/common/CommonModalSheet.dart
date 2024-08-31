import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/common/CommonBackground.dart';
import 'package:flutter_app_weight_management/common/CommonName.dart';
import 'package:flutter_app_weight_management/common/CommonText.dart';
import 'package:flutter_app_weight_management/components/area/empty_area.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:flutter_app_weight_management/utils/variable.dart';

class CommonModalSheet extends StatelessWidget {
  CommonModalSheet({
    super.key,
    this.title,
    this.isClose,
    this.nameArgs,
    required this.height,
    required this.child,
  });

  String? title;
  double height;
  bool? isClose;
  Widget child;
  Map<String, String>? nameArgs;

  @override
  Widget build(BuildContext context) {
    return CommonBackground(
      height: height,
      isRadius: true,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(10),
        topRight: Radius.circular(10),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              title != null
                  ? Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: Row(
                        children: [
                          isClose == true ? Spacer() : const EmptyArea(),
                          CommonName(
                            text: title!,
                            fontSize: 15,
                            nameArgs: nameArgs,
                          ),
                          isClose == true ? Spacer() : const EmptyArea(),
                          isClose == true
                              ? InkWell(
                                  onTap: () => closeDialog(context),
                                  child:
                                      Icon(Icons.close, color: grey.original),
                                )
                              : const EmptyArea()
                        ],
                      ),
                    )
                  : const EmptyArea(),
              Expanded(child: child),
            ],
          ),
        ),
      ),
    );
  }
}
