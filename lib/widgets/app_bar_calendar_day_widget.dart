import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/picker/default_date_time_picker.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/provider/record_selected_dateTime_provider.dart';
import 'package:flutter_app_weight_management/utils/constants.dart';
import 'package:flutter_app_weight_management/utils/function.dart';
import 'package:flutter_app_weight_management/widgets/dafault_bottom_sheet.dart';
import 'package:provider/provider.dart';

class ImportDateTimeTitleWidget extends StatefulWidget {
  const ImportDateTimeTitleWidget({super.key});

  @override
  State<ImportDateTimeTitleWidget> createState() =>
      _ImportDateTimeTitleWidgetState();
}

class _ImportDateTimeTitleWidgetState extends State<ImportDateTimeTitleWidget> {
  late DateTime changedDateTime;

  @override
  Widget build(BuildContext context) {
    final importDateTime =
        context.watch<ImportDateTimeProvider>().getImportDateTime();

    onDateTimeChanged(DateTime dateTime) {
      setState(() => changedDateTime = dateTime);
    }

    onTapArrow(String? name) {
      print(name);
    }

    setImportDateTime() {
      context.read<ImportDateTimeProvider>().setImportDateTime(changedDateTime);
      closeDialog(context);
    }

    onTapTitle() {
      showCupertinoModalPopup(
        context: context,
        builder: (context) => DefaultBottomSheet(
          title: '날짜 불러오기',
          widgets: [
            DefaultTimePicker(
              initialDateTime: importDateTime,
              mode: CupertinoDatePickerMode.date,
              onDateTimeChanged: onDateTimeChanged,
            )
          ],
          isEnabled: true,
          submitText: '불러오기',
          onSubmit: setImportDateTime,
        ),
      );
    }

    arrowIcon({String? name, required IconData icon}) {
      return InkWell(
        onTap: () => onTapArrow(name),
        child: Icon(icon, size: 20, color: buttonBackgroundColor),
      );
    }

    importTitle() {
      return InkWell(
        onTap: onTapTitle,
        child: Padding(
          padding: pagePadding,
          child: Row(
            children: [
              Text(
                getDateTimeToStr(importDateTime),
                style: const TextStyle(fontSize: 18),
              ),
              SpaceWidth(width: tinySpace),
              arrowIcon(icon: Icons.expand_circle_down_outlined),
            ],
          ),
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        arrowIcon(name: 'left', icon: Icons.arrow_back_ios_new),
        importTitle(),
        arrowIcon(name: 'right', icon: Icons.arrow_forward_ios),
      ],
    );
  }
}
