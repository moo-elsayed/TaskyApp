import 'package:flutter/material.dart';

String getDate(DateTime date) =>
    '${date.day}/${date.month}/${date.year}';

String getTime(TimeOfDay time) =>
    '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';

String getDateTime(DateTime date) =>
    '${getDate(date)} At ${getTime(TimeOfDay(hour: date.hour, minute: date.minute))}';
