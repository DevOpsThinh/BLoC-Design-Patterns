///------------------------------------------------------------------
/// Topic: Flutter - Dart
/// Author: Nguyen Truong Thinh
/// Created At: 29/ 4/ 2023
///------------------------------------------------------------------

import 'package:intl/intl.dart';

/// Class's document:
/// Handles formatting dates
class FormatDates {
  String dateFormatShortMonthDayYear(String date) {
    return DateFormat.yMMMd().format(DateTime.parse(date));
  }

  String dateFormatDayNumber(String date) {
    return DateFormat.d().format(DateTime.parse(date));
  }

  String dateFormatShortDayName(String date) {
    return DateFormat.E().format(DateTime.parse(date));
  }
}