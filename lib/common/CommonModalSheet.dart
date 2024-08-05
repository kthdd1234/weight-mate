import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/common/CommonBackground.dart';
import 'package:flutter_app_weight_management/common/CommonText.dart';
import 'package:flutter_app_weight_management/widgets/area/empty_area.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/function.dart';

class CommonModalSheet extends StatelessWidget {
  CommonModalSheet({
    super.key,
    this.title,
    this.isBack,
    required this.height,
    required this.child,
  });

  String? title;
  double height;
  bool? isBack;
  Widget child;

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
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        isBack == true
                            ? InkWell(
                                onTap: () => closeDialog(context),
                                child: const Padding(
                                  padding:
                                      EdgeInsets.only(bottom: 15, right: 15),
                                  child: Icon(
                                    Icons.arrow_back_ios_new_rounded,
                                    color: textColor,
                                    size: 16,
                                  ),
                                ),
                              )
                            : const EmptyArea(),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 15),
                            child: CommonText(
                                text: title!, size: 15, isCenter: true),
                          ),
                        ),
                        isBack == true
                            ? const Padding(
                                padding: EdgeInsets.only(left: 15),
                                child: Icon(
                                  Icons.arrow_back_ios_new_rounded,
                                  color: Colors.transparent,
                                  size: 16,
                                ),
                              )
                            : const EmptyArea(),
                      ],
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
