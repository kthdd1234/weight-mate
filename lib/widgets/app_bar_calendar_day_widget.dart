import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_weight_management/components/picker/default_date_time_picker.dart';
import 'package:flutter_app_weight_management/components/space/spaceWidth.dart';
import 'package:flutter_app_weight_management/provider/import_date_time_provider.dart';
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
    DateTime importDateTime =
        context.watch<ImportDateTimeProvider>().getImportDateTime();

    onDateTimeChanged(DateTime dateTime) {
      setState(() => changedDateTime = dateTime);
    }

    onTapArrow(String? name) {
      DateTime now = DateTime.now();
      Duration duration = const Duration(days: 1);
      DateTime resultDateTime = name == 'yesterday'
          ? importDateTime.subtract(duration)
          : importDateTime.add(duration);

      if (getDateTimeToInt(now) < getDateTimeToInt(resultDateTime)) {
        return showSnackBar(
          context: context,
          text: '미래의 날짜를 불러올 순 없어요.',
          buttonName: '확인',
        );
      }

      context.read<ImportDateTimeProvider>().setImportDateTime(resultDateTime);
    }

    setImportDateTime() {
      context.read<ImportDateTimeProvider>().setImportDateTime(changedDateTime);
      closeDialog(context);
    }

    onTapCalendarIcon() {
      // todo: 달력 UI로 전환하기
    }

    onTapTitle() {
      showCupertinoModalPopup(
        context: context,
        builder: (context) => DefaultBottomSheet(
          title: '날짜 불러오기',
          height: 380,
          contents: DefaultTimePicker(
            initialDateTime: importDateTime,
            mode: CupertinoDatePickerMode.date,
            onDateTimeChanged: onDateTimeChanged,
          ),
          titleLeftWidget: GestureDetector(
            onTap: onTapCalendarIcon,
            child: const Icon(
              Icons.calendar_month,
              color: themeColor,
            ),
          ),
          isEnabled: true,
          submitText: '불러오기',
          onSubmit: setImportDateTime,
        ),
      );
    }

    arrowIcon({required String name, required IconData icon}) {
      return IconButton(
          onPressed: () => onTapArrow(name),
          icon: Icon(
            icon,
            size: 20,
            color: themeColor,
          ));
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
              InkWell(
                onTap: onTapTitle,
                child: const Icon(Icons.expand_circle_down_outlined,
                    size: 20, color: themeColor),
              ),
            ],
          ),
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        arrowIcon(name: 'yesterday', icon: Icons.arrow_back_ios_new),
        importTitle(),
        arrowIcon(name: 'next', icon: Icons.arrow_forward_ios),
      ],
    );
  }
}
