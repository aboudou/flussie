import 'dart:ui';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

class Converters {
  static double milesToKm(double? miles) {
    if (miles == null) return 0;
    return miles * 1.60934;
  }

  static Locale get deviceLocale => Get.deviceLocale ?? const Locale('en', 'US');

  // Year-aware date: omits year when the date is in the current year.
  static String formatDate(DateTime dt, Locale locale) {
    final fmt = dt.year == DateTime.now().year ? 'EEE dd MMM, HH:mm' : 'dd MMM yyyy, HH:mm';
    return DateFormat(fmt, locale.toString()).format(dt);
  }

  // Full date always including day-of-week and year (used in drive details).
  static String formatFullDate(DateTime dt, Locale locale) {
    return DateFormat('EEE dd MMM yyyy, HH:mm', locale.toString()).format(dt);
  }

  // Short date for filter display (e.g. "4/25/2025").
  static String formatShortDate(int epochSeconds) {
    final dt = DateTime.fromMillisecondsSinceEpoch(epochSeconds * 1000);
    return DateFormat.yMd(deviceLocale.toString()).format(dt);
  }
}
