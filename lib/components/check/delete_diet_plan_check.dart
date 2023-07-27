import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';

class DeleteDietPlanCheck extends StatefulWidget {
  DeleteDietPlanCheck({
    super.key,
    required this.id,
    required this.text,
    required this.onTap,
  });

  String id;
  String text;
  Function({String id, bool isSelected}) onTap;

  @override
  State<DeleteDietPlanCheck> createState() => _DeleteDietPlanCheckState();
}

class _DeleteDietPlanCheckState extends State<DeleteDietPlanCheck> {
  bool isSeleted = false;

  @override
  Widget build(BuildContext context) {
    setOnTap() {
      setState(() => isSeleted = !isSeleted);
      widget.onTap(id: widget.id, isSelected: !isSeleted);
    }

    return InkWell(
      onTap: setOnTap,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(5, 3, 0, 0),
                child: Text(widget.text),
              ),
              Icon(
                Icons.remove_circle,
                color: isSeleted
                    ? buttonBackgroundColor
                    : disabledButtonBackgroundColor,
              )
            ],
          ),
          SpaceHeight(height: regularSapce),
        ],
      ),
    );
  }
}
