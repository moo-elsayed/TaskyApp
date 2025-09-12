import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../features/home/presentation/widgets/custom_error_dialog.dart';

String getDate(DateTime date) => '${date.day}/${date.month}/${date.year}';

String getTime(TimeOfDay time) =>
    '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';

String getDateTime(DateTime date) =>
    '${getDay(date)} At ${getTime(TimeOfDay(hour: date.hour, minute: date.minute))}';

void showErrorDialog({
  required BuildContext context,
  required String errorMessage,
}) => showCupertinoDialog(
  context: context,
  barrierDismissible: true,
  builder: (context) =>
      CustomErrorDialog(title: 'Error', description: errorMessage),
);

String getDay(DateTime date) {
  if (date.day == DateTime.now().subtract(const Duration(days: 1)).day) {
    return 'Yesterday';
  } else if (date.day == DateTime.now().day) {
    return 'Today';
  } else if (date.day == DateTime.now().add(const Duration(days: 1)).day) {
    return 'Tomorrow';
  } else {
    return getDate(date);
  }
}
