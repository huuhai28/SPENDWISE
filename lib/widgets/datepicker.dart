import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Datepicker {
  void showCupertinoDatePicker(BuildContext context, DateTime selectedDate,
      Function(DateTime) OnDateChanged) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 300,
          child: CupertinoDatePicker(
            initialDateTime: selectedDate,
            mode: CupertinoDatePickerMode.date,
            onDateTimeChanged: (DateTime newDate) {
              OnDateChanged(newDate);
            },
          ),
        );
      },
    );
  }
}
