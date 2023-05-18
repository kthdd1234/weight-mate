import 'package:flutter/cupertino.dart';

class DefaultDateTimePicker extends StatelessWidget {
  const DefaultDateTimePicker({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      padding: const EdgeInsets.only(top: 10.0),
      margin: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      color: CupertinoColors.systemBackground.resolveFrom(context),
      child: SafeArea(
        top: false,
        child: CupertinoDatePicker(
          initialDateTime: DateTime.now(),
          mode: CupertinoDatePickerMode.time,
          onDateTimeChanged: (DateTime value) {},
        ),
      ),
    );
  }
}
