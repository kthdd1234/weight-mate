import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/area/empty_area.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/components/text/sub_text.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';

class ActionDietPlanCheck extends StatefulWidget {
  ActionDietPlanCheck({
    super.key,
    required this.id,
    required this.text,
    required this.isAction,
    required this.onTap,
  });

  String id;
  String text;
  bool isAction;
  Function({required String id, required bool isSelected}) onTap;

  @override
  State<ActionDietPlanCheck> createState() => _ActionDietPlanCheckState();
}

class _ActionDietPlanCheckState extends State<ActionDietPlanCheck> {
  bool isSeleted = false;

  @override
  void initState() {
    isSeleted = widget.isAction;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    setOnTap() {
      widget.onTap(id: widget.id, isSelected: !isSeleted);
      setState(() => isSeleted = !isSeleted);
    }

    return InkWell(
      onTap: setOnTap,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.check_box,
                    color: isSeleted
                        ? buttonBackgroundColor
                        : disabledButtonBackgroundColor,
                  ),
                  SpaceWidth(width: smallSpace),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(5, 3, 0, 0),
                    child: Text(widget.text),
                  )
                ],
              ),
              isSeleted ? SubText(text: '완료!', value: '') : const EmptyArea(),
            ],
          ),
          SpaceHeight(height: regularSapce)
        ],
      ),
    );
  }
}
