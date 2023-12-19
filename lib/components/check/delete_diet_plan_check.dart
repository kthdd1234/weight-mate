import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/space/spaceHeight.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';

class DeleteDietPlanCheck extends StatelessWidget {
  DeleteDietPlanCheck({
    super.key,
    required this.id,
    required this.text,
    required this.onTap,
  });

  String id, text;
  Function({required String id}) onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            InkWell(
              onTap: () => onTap(id: id),
              child:
                  const Icon(Icons.remove_circle, color: Colors.red, size: 22),
            ),
            SpaceWidth(width: smallSpace),
            Expanded(
                child: Padding(
                    padding: EdgeInsets.only(top: 3), child: Text(text))),
          ],
        ),
        SpaceHeight(height: regularSapce),
      ],
    );
  }
}
