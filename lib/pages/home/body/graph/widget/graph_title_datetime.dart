import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/common/CommonText.dart';
import 'package:flutter_app_weight_management/utils/function.dart';

class GraphTitleDateTime extends StatelessWidget {
  GraphTitleDateTime({
    super.key,
    required this.startDateTime,
    required this.endDateTime,
  });

  DateTime startDateTime, endDateTime;

  @override
  Widget build(BuildContext context) {
    String locale = context.locale.toString();

    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          CommonText(
            text: '${ymd(
              locale: locale,
              dateTime: startDateTime,
            )} ~ ${ymd(
              locale: locale,
              dateTime: endDateTime,
            )}',
            size: 12,
            color: Colors.grey.shade700,
            isNotTr: true,
          )
        ],
      ),
    );
  }
}
