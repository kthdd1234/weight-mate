import 'package:flutter/cupertino.dart';

class DefaultTimePicker extends StatelessWidget {
  DefaultTimePicker({
    super.key,
    required this.initialDateTime,
    required this.mode,
    required this.onDateTimeChanged,
  });

  DateTime initialDateTime;
  Function(DateTime time) onDateTimeChanged;
  CupertinoDatePickerMode mode;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      padding: const EdgeInsets.only(top: 10.0),
      decoration: BoxDecoration(
        color: CupertinoColors.systemBackground.resolveFrom(context),
        borderRadius: BorderRadius.circular(10.0),
      ),
      margin: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SafeArea(
        top: false,
        child: CupertinoDatePicker(
          initialDateTime: initialDateTime,
          mode: mode,
          maximumDate: DateTime.now(),
          onDateTimeChanged: onDateTimeChanged,
        ),
      ),
    );
  }
}
