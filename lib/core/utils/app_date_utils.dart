import 'package:intl/intl.dart';

class AppDateUtils {
  static String monthName(int month) {
    const names = [
      "",
      "January","February","March","April","May","June",
      "July","August","September","October","November","December"
    ];

    if (month < 1 || month > 12) return "";
    return names[month];
  }

  static String monthNameArabic(int month) {
    const names = [
      "",
      "يناير","فبراير","مارس","أبريل","مايو","يونيو",
      "يوليو","أغسطس","سبتمبر","أكتوبر","نوفمبر","ديسمبر"
    ];

    if (month < 1 || month > 12) return "";
    return names[month];
  }


  static String formatDateTime(DateTime time) {
    return DateFormat('yyyy/MM/dd   HH:mm').format(time);
  }

}
