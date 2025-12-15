import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class AppDateUtils {

  /// Month name based on current app locale
  static String monthName(
      BuildContext context,
      int month,
      ) {
    if (month < 1 || month > 12) return '';

    final locale = context.locale.toString();
    final date = DateTime(2024, month);

    return DateFormat.MMMM(locale).format(date);
  }

  static String formatDateTime(
      BuildContext context,
      DateTime time,
      ) {
    final locale = context.locale.toString();
    return DateFormat('yyyy/MM/dd   HH:mm', locale).format(time);
  }
  static String formatDate(
      BuildContext context,
      DateTime date,
      ) {
    final locale = context.locale.toString();
    return DateFormat.yMd(locale).format(date);
  }
}
