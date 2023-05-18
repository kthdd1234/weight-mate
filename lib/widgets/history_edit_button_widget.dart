import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';

class HistoryEditButtonWidget extends StatelessWidget {
  HistoryEditButtonWidget({
    super.key,
    required this.id,
    required this.onTap,
  });

  String id;
  Function(String id) onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(id),
      child: Container(
        decoration: BoxDecoration(
          color: typeBackgroundColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Padding(
          padding: EdgeInsets.symmetric(
            vertical: 7.5,
            horizontal: 15,
          ),
          child: Text(
            '수정',
            style: TextStyle(
              color: disEnabledTypeColor,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }
}
