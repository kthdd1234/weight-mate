import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';

class PlanCheck extends StatelessWidget {
  PlanCheck({
    super.key,
    required this.id,
    required this.text,
    required this.icon,
    required this.isChecked,
    required this.onTapCheck,
  });

  String id;
  IconData icon;
  String text;
  bool isChecked;
  Function(String id) onTapCheck;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTapCheck(id),
      child: Column(
        children: [
          SpaceHeight(height: smallSpace),
          Row(
            children: [
              Icon(icon),
              SpaceWidth(width: smallSpace),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(5, 3, 0, 0),
                  child: Text(text),
                ),
              ),
              isChecked
                  ? const Icon(Icons.check_box_outlined)
                  : const Icon(Icons.check_box_outline_blank_rounded),
              SpaceWidth(width: regularSapce)
            ],
          ),
          SpaceHeight(height: smallSpace)
        ],
      ),
    );
  }
}
